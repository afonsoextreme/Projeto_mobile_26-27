import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/services/verificar_sessao.dart';

class PasseioEmCursoScreen extends StatelessWidget{
  final Passeio passeio;

  const PasseioEmCursoScreen({
    super.key,
    required this.passeio,
  });

  Future<void> terminarPasseio(BuildContext context) async {
    if(!verificarSessao(context)) return;
    if(!passeio.souOrganizador || !passeio.emCurso) return;

    final confirmar = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Terminar Passeio'),
        content: const Text(
          'Queres terminar este passeio? Não poderá ser iniciado novamente.',
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

    if(!context.mounted || confirmar !=true) return;
    if(!verificarSessao(context)) return;

    Navigator.of(context).pop(true);
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
            const Padding(
              padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Mapa de demonstração centrado na arrabida.'
                'Percurso e localização do grupo ainda não disponiveis.',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(38.48, -8.99),
                  initialZoom: 12,
                  minZoom: 3,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'pt.ridesync.prototype',
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
                    onPressed: () => terminarPasseio(context),
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Terminar Passeio'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}