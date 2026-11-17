import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/services/verificar_sessao.dart';
import 'package:ridesync/services/passeios_service.dart';

class PasseioEmCursoScreen extends StatefulWidget{
  final Passeio passeio;

  const PasseioEmCursoScreen({
    super.key,
    required this.passeio,
  });

  @override
  State<PasseioEmCursoScreen> createState() =>
      _PasseioEmCursoScreenState();
  
}

class _PasseioEmCursoScreenState extends State<PasseioEmCursoScreen> {
  bool _aTerminar = false;

  Passeio get passeio => widget.passeio;
  
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _subscricaoLocalizacao;

  LatLng? _minhaPosicao;
  double? _precisaoMetros;

  bool _aLocalizar = false;
  bool _mapaPronto = false;

  String? _erroLocalizacao;

  @override
  void dispose() {
    _subscricaoLocalizacao?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _receberPosicao(Position posicao){
    if(!mounted) return;

    final primeiraPosicao = _minhaPosicao == null;

    setState(() {
     _minhaPosicao = LatLng(
        posicao.latitude, 
        posicao.longitude,
      );
      _precisaoMetros = posicao.accuracy;
      _erroLocalizacao = null;
    });

    if (primeiraPosicao) {
      _centrarMapa();
    }
  }

  void _centrarMapa() {
    final posicao = _minhaPosicao;

    if (!_mapaPronto || posicao == null) return;

    _mapController.move(posicao, 16);
  }

  Future<void> _ativarLocalizacao() async {
    if(_aLocalizar) return;

    setState(() {
      _aLocalizar = true;
      _erroLocalizacao = null;
    });

    try {
      await _subscricaoLocalizacao?.cancel();
      _subscricaoLocalizacao = null;

      if(!mounted) return;

      if (!kIsWeb) {
         final servicoAtivo =
             await Geolocator.isLocationServiceEnabled();
         if (!servicoAtivo) {
          throw Exception(
            'Ativa a localização nas definições do dispositivo'
            'e tenta novamente.',
          );
         }
       }

      var permissao = await Geolocator.checkPermission();

      if(!mounted) return;

      if(permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if(!mounted) return;

      if(permissao == LocationPermission.deniedForever) {
        throw Exception(
          kIsWeb
              ? 'Permite a localização nas definições deste site '
                  'no navegador e tenta novamente.'
              : 'Permite o acesso a localização nas definições'
                  'da app e tenta novamente.',
        );
      }

      if(!kIsWeb && permissao == LocationPermission.denied) {
        throw Exception(
          'Precisamos da tua autorização para mostrar'
          'a tua posição no mapa.',
        );
      }

      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if(!mounted) return;

      _receberPosicao(posicao);
      _centrarMapa();

      _subscricaoLocalizacao = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen(
        _receberPosicao,
        onError: (Object erro) {
          if(!mounted) return;

          setState(() {
            _minhaPosicao = null;
            _precisaoMetros = null;
            _erroLocalizacao =
                'A localização foi interrompida. '
                'A verifica as permissões e tenta novamente.';
          });
        },
        cancelOnError: true,
      );
    } on TimeoutException{
      if(!mounted) return;

      setState(() {
        _erroLocalizacao =
            'Não foi possivel obter a posição a tempo. '
            'Tenta novamente num local com melhor sinal.';
      });
    } catch (erro) {
      if(!mounted) return;

      setState(() {
        _erroLocalizacao = erro is PermissionDeniedException
            ? 'Permite o acesso à localização nas definições '
                'da app ou do navegador e tenta novamente.'
            : erro is LocationServiceDisabledException
                ? 'Ativa a localização do disposititvo e tenta novamente.'
                : erro.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if(mounted) {
        setState(() {
          _aLocalizar = false;
        });
      }
    }
  }

  Future<void> terminarPasseio() async {
    if(_aTerminar) return;
    if(!verificarSessao(context)) return;
    if(!passeio.souOrganizador || !passeio.emCurso) return;

    setState(() {
      _aTerminar = true;
    });

    try{
      final confirmar = await showDialog<bool>(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Terminar Passeio'),
          content: const Text(
            'Queres terminar este passeio?' 
            'Não poderá ser iniciado novamente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), 
              child: const Text('Voltar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Terminar'),
            ),
          ],
        ),
      );

      if(!mounted || confirmar !=true) return;
      if(!verificarSessao(context)) return;

      final atualizado = await PasseiosService.alterarEstado(
        passeio, 
        EstadoPasseio.terminado,
      );

      if(!mounted) return;

      Navigator.of(context).pop(atualizado);
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possivel confirmar o fim do passseio. '
            '${erro.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if(mounted){
        setState(() {
          _aTerminar = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passeio em curso'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.route),
              title: Text(passeio.nome),
              subtitle: Text('${passeio.partida} -> ${passeio.destino}'),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  Text(
                    _minhaPosicao == null
                        ? 'Ativa a localização para veres a tua posição no mapa.'
                        : 'A tua posição está assinalada a azul. '
                            'Precisão aproximada: '
                            '${_precisaoMetros?.round() ?? 0} m.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _aLocalizar
                        ? null
                        : _minhaPosicao == null
                            ? _ativarLocalizacao
                            : _centrarMapa,
                    icon: const Icon(Icons.my_location), 
                    label: Text(
                      _aLocalizar
                          ? 'A obter localização...'
                          : _minhaPosicao == null
                              ? 'Ativar localização'
                              : 'Centrar na minha localização',
                    ),
                  ),
                  if (_erroLocalizacao != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _erroLocalizacao!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(38.48, -8.99),
                  initialZoom: 12,
                  minZoom: 3,
                  maxZoom: 18,
                  onMapReady: () {
                    _mapaPronto = true;

                    WidgetsBinding.instance.addPostFrameCallback((_){
                      if (mounted) {
                        _centrarMapa();
                      }
                    });
                  }
                ),
                children: [
                  TileLayer(
                    urlTemplate: 
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'pt.ridesync.prototype',
                  ),
                  if(_minhaPosicao != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _minhaPosicao!,
                        width: 40,
                        height: 40, 
                        child: Tooltip(
                          message: 'A minha localização',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                              'https://www.openstreetmap.org/copyright',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(passeio.souOrganizador)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _aTerminar ? null : terminarPasseio,
                    icon: const Icon(Icons.flag_outlined),
                    label: Text(
                      _aTerminar ?'Aguarda...' : 'Terminar Passeio',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}