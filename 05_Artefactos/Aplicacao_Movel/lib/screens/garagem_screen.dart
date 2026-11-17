import 'package:flutter/material.dart';
import 'package:ridesync/models/veiculo.dart';
import 'criar_veiculo_screen.dart';
import 'package:ridesync/theme/app_theme.dart';
import 'package:ridesync/services/garagem_store.dart';
import 'package:ridesync/services/sessao_store.dart';
import 'package:ridesync/services/verificar_sessao.dart';

class GaragemScreen extends StatefulWidget{
  const GaragemScreen({super.key});

  @override
  State<GaragemScreen> createState() => _GaragemScreenState();
}

class _GaragemScreenState extends State<GaragemScreen>{
  final List<Veiculo> veiculos = GaragemStore.veiculos;

  bool _aCarregar = false;
  bool _aGuardar = false;
  String? _erro;
  int _versaoCarregamento = 0;

  @override
  void initState() {
    super.initState();
    SessaoStore.iniciada.addListener(_aoMudarSessao);
    _carregar();
  }

  @override
  void dispose() {
    SessaoStore.iniciada.removeListener(_aoMudarSessao);
    super.dispose();
  }

  void _aoMudarSessao() {
    GaragemStore.limpar();
    _carregar();
  }

  Future<void> _carregar() async {
    if (!mounted) return;

    final versao = ++_versaoCarregamento;

    setState(() {
      _aCarregar = true;
      _erro = null;
    });

    try {
      await GaragemStore.carregar();
    } catch (erro) {
      if (!mounted || versao != _versaoCarregamento) return;
      _erro = erro.toString();
    } finally {
      if (mounted && versao == _versaoCarregamento) {
        setState(() {
          _aCarregar = false;
        });
      }
    }
  }

  Future<void> abrirFormulario({Veiculo? veiculo}) async {
    final resultado = await Navigator.of(context).push<Veiculo>(
      MaterialPageRoute(
        builder: (context) => CriarVeiculoScreen(veiculo: veiculo),
      ),
    );

    final tokenInicial = SessaoStore.token;

    if(!mounted || resultado == null) return;
    if(SessaoStore.token != tokenInicial) return;

    setState(() {
      _aGuardar = true;
    });

    try {
      await GaragemStore.guardar(resultado);

      if(!mounted) return;

      setState(() {});


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            veiculo == null
                ? 'Veiculo adicionado à garagem'
                : 'Veiculo adicionado'
          ),
        ),
      );
    } catch (erro) {
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _aGuardar = false;
        });
      }
    }
  }

  Future<void> apagarVeiculo(Veiculo veiculo) async{
    if(_aGuardar || _aCarregar) return;
    if(!verificarSessao(context)) return;
    final tokenInicial = SessaoStore.token;

    final confirmar = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Apagar veiculo'),
        content: Text(
          'Queres apagar o veiculo '
          '"${veiculo.marca} ${veiculo.modelo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text(
              'Apagar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if(!mounted || confirmar != true) return;
    if (SessaoStore.token != tokenInicial) return;

    setState(() {
      _aGuardar = true;
    });

    try {
      await GaragemStore.apagar(veiculo);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veiculo Apagado')),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _aGuardar = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'A Minha Garagem',
          style: Theme.of(context).textTheme.headlineSmall
          ),
        const SizedBox(height: 12),
        const Text(
          'Gere os teus carros e motas',
          style: TextStyle(color: Colors.white60),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _aGuardar || _aCarregar
              ? null 
              : () => abrirFormulario(), 
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Veiculo'),
        ),

        if (_aGuardar || _aCarregar)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          ),

        if (SessaoStore.iniciada.value)
          TextButton.icon(
            onPressed: _aGuardar || _aCarregar ? null : _carregar,
            icon: const Icon(Icons.refresh), 
            label: const Text('Atualizar garagem')
          ),

        if (!SessaoStore.iniciada.value)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text('Inicia sessão para veres a tua garagem.'),
          ),
        const SizedBox(height: 24),
        if(SessaoStore.iniciada.value &&
           !_aCarregar &&
           _erro == null &&
           veiculos.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.garage_outlined,
                    size: 48,
                    color: AppTheme.asfalto,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ainda não tens veiculos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adiciona o teu primeiro primeiro carro ou mota!',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ...veiculos.map(
          (veiculo) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                veiculo.tipo == 'Carro'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: AppTheme.asfalto,
                size: 36,
              ),
              title: Text(
                '${veiculo.marca} ${veiculo.modelo}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${veiculo.tipo} - ${veiculo.matricula}',
              ),
              trailing: PopupMenuButton<String>(
                enabled: !_aGuardar && !_aCarregar,
                tooltip: 'Opções do veiculo',
                onSelected: (opcao) {
                  if(opcao == 'editar'){
                    abrirFormulario(veiculo: veiculo);
                  } else if(opcao == 'apagar'){
                    apagarVeiculo(veiculo);
                  }
                },
                itemBuilder: (context) => const[
                  PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar'),
                  ),
                  PopupMenuItem(
                    value: 'apagar',
                    child: Text(
                      'Apagar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}