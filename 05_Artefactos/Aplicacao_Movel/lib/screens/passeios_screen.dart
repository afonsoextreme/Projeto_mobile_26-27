import 'package:flutter/material.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/widgets/passeio_card.dart';
import 'criar_passeio_screen.dart';
import 'detalhes_passeio_screen.dart';
import 'package:ridesync/services/passeios_service.dart';
import 'package:ridesync/services/verificar_sessao.dart';
import 'package:ridesync/services/sessao_store.dart';

class PasseiosScreen extends StatefulWidget{
  const PasseiosScreen({super.key});
  
  @override
  State<PasseiosScreen> createState() => _PasseioScreenState();
}

class _PasseioScreenState extends State<PasseiosScreen>{
  final List <Passeio> passeios = [];

  bool _aCarregar = true;
  String? _erroCarregamento;
  int _versaoCarregamento = 0;

  @override
  void initState() {
    super.initState();
    SessaoStore.iniciada.addListener(_aoMudarSessao);
    carregarPasseios();
  }

  void _aoMudarSessao() {
    carregarPasseios();
  }

  @override
  void dispose() {
    SessaoStore.iniciada.removeListener(_aoMudarSessao);
    super.dispose();
  }

  Future<void> carregarPasseios() async {
    if (!mounted) return;

    final versao = ++_versaoCarregamento;

    setState(() {
      _aCarregar = true;
      _erroCarregamento = null;
      passeios.clear();
    });

    try{
      final resultado = await PasseiosService.listarPasseios();
      
      if(!mounted || versao != _versaoCarregamento) return;

      setState(() {
        passeios
          ..clear()
          ..addAll(resultado);
        _aCarregar = false;
      });
    } catch (erro) {
      debugPrint('Erro ao carregar passeios: $erro');

      if(!mounted || versao != _versaoCarregamento) return;

      setState(() {
        _aCarregar = false;
        _erroCarregamento =
            'Não foi possivel carregar os passeios. Tenta novamente';
      });
    }
  }

  String formatarData(DateTime data){
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}'
        ' - ${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  Future<void> criarPasseio() async{
    if(!verificarSessao(context)) return;
    final novoPasseio = await Navigator.of(context).push<Passeio>(
      MaterialPageRoute(
        builder: (context) => const CriarPasseioScreen(),
      ),
    );  
    
    if (!mounted || novoPasseio == null) return;

    try {
      final passeioGuardado =
          await PasseiosService.criarPasseio(novoPasseio);

      if (!mounted) return;

      setState(() {
        passeios.add(passeioGuardado);
        passeios.sort(
          (a, b) => a.dataHora.compareTo(b.dataHora),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passeio criado com Sucesso!'),
        ),
      );
    } catch (erro) {
      debugPrint('Erro ao criar Passeio: $erro');

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possivel confirmar a criação do passeio. '
            'Verifica a ligação ao backend.',
          ),
        ),
      );
    }
  }

  Future<void> editarPasseio(Passeio passeio) async{
    if(!verificarSessao(context)) return;
    if(!passeio.souOrganizador || !passeio.agendado) return;

    final passeioEditado = await Navigator.of(context).push<Passeio>(
      MaterialPageRoute(
        builder: (context) => CriarPasseioScreen(
          passeio: passeio,
        ),
      ),
    );

    if(!mounted || passeioEditado == null) return;

    final indice = passeios.indexOf(passeio);
    
    if(indice == -1) return;

    if(passeioEditado.limiteParticipantes < passeio.participantes){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'O limite não pode ser inferior ao numero atual de participantes',
          ),
        ),
      );
      return;
    }

    setState(() {
      passeios[indice] = passeioEditado.copywith(
        cancelado: passeio.cancelado,
        participantesBase: passeio.participantesBase,
        inscrito: passeio.inscrito,
        veiculoSelecionado: passeio.veiculoSelecionado,
      );

      passeios.sort(
        (a, b) => a.dataHora.compareTo(b.dataHora),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio atualizado com sucesso!'),
      ),
    );
  }

  Future<void> cancelarPasseio(Passeio passeio) async {
    if(!verificarSessao(context)) return;
    if(!passeio.souOrganizador|| !passeio.agendado) return;

    final confirmar = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Passeio'),
        content: Text(
          'Queres cancelar o passeio "${passeio.nome}"?\n\n'
          'O passeio continuará na lista como cancelado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text(
              'Cancelar Passeio',
              style: TextStyle(color: Colors.red),
            )
          ),
        ],
      ),
    );

    if(!mounted || confirmar != true) return;
    
    final indice = passeios.indexOf(passeio);

    if (indice == -1) return;

    setState(() {
      passeios[indice] = passeio.cancelar();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio Cancelado.'),
      ),
    );
  }

  void abrirDetalhes(Passeio passeio){
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) =>DetalhesPasseioScreen(
            passeio: passeio, 
            onAtualizar: (atualizado) {
              if(!mounted) return;

              final indice = passeios.indexOf(passeio);
              if(indice == -1) return;

              setState(() {
                passeios[indice] = atualizado;
              });

              passeio = atualizado;
            },
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'A proxima aventura começa aqui.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Organiza passeios e junta te ao teu grupo',
          style: TextStyle(color: Colors.white60),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _aCarregar || _erroCarregamento != null
              ? null
              : criarPasseio, 
          icon: const Icon(Icons.add),
          label: const Text('Criar Passeio'),
        ),
        const SizedBox(height: 30),
        const Text(
          'Proximos Passeios',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_aCarregar)
          const Padding(
            padding:EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          if (_erroCarregamento != null)
            Column(
              children: [
                Text(
                  _erroCarregamento!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: carregarPasseios,
                  icon: const Icon(Icons.refresh), 
                  label: const Text('Tentar Novamente'),
                ),
              ],
            ),
        if(!_aCarregar && 
        _erroCarregamento == null &&
        passeios.isEmpty)
        const Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.route,
                  size: 48,
                  color: Colors.orange,
                ),
                SizedBox(height: 12),
                Text(
                  'Ainda não tens Passeios.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Cria o primeiro para começar!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        ...passeios.map(
          (passeio) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PasseioCard(
              titulo: passeio.nome, 
              percurso: '${passeio.partida} -> ${passeio.destino}', 
              data: formatarData(passeio.dataHora), 
              participantes: passeio.participantes, 
              limiteParticipantes: passeio.limiteParticipantes,
              icon: Icons.route,
              cancelado: passeio.cancelado,
              souOrganizador: passeio.souOrganizador,
              agendado: passeio.agendado,
              onAbrir: () => abrirDetalhes(passeio),
              onEditar: () => editarPasseio(passeio),
              onCancelar: () => cancelarPasseio(passeio),
            ),
          ),
        ),
      ],
    );
  }
}