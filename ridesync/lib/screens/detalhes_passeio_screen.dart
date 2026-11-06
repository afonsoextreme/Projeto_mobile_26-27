import 'package:flutter/material.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/models/veiculo.dart';
import 'package:ridesync/services/garagem_store.dart';
import 'package:ridesync/services/verificar_sessao.dart';
import 'passeio_em_curso_screen.dart';

class DetalhesPasseioScreen extends StatefulWidget {
  final Passeio passeio;
  final ValueChanged<Passeio> onAtualizar;

  const DetalhesPasseioScreen({
    super.key,
    required this.passeio,
    required this.onAtualizar,
  });

  @override
  State<DetalhesPasseioScreen> createState() => _DetalhesPasseioScreenState();
}

  class _DetalhesPasseioScreenState extends State<DetalhesPasseioScreen> {
    late Passeio passeio;

    Veiculo? get _veiculoSelecionado => passeio.veiculoSelecionado;
    int get participantes => passeio.participantes;

    @override
    void initState(){
      super.initState();
      passeio = widget.passeio;
    }

    void atualizarPasseio(Passeio atualizado) {
      setState(() {
        passeio = atualizado;
      });

      widget.onAtualizar(atualizado);
    }

    void confirmarParticipacao(){
      if(!verificarSessao(context)) return;
      if(!passeio.agendado || 
         passeio.inscrito ||
         passeio.souOrganizador){
       return;
      }

      if(passeio.participantes >= passeio.limiteParticipantes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este Passeio ja está lotado'),
          ),
        );
        return;
      }

      final veiculo = _veiculoSelecionado;

      if(veiculo == null || !GaragemStore.veiculos.contains(veiculo)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Escolhe um veiculo disponível na tua garagem.'),
          ),
        );
        return;
      }

      atualizarPasseio(passeio.copywith(inscrito: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participação confirmada!'),
        ),
      );
    }

    void cancelarParticipacao() {
      if(!verificarSessao(context)) return;
      if(!passeio.inscrito || !passeio.agendado) return;

      atualizarPasseio(passeio.copywith(inscrito: false));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(

          content: Text('Participação Cancelada'),
        ),
      );
    }
    Future<void> iniciarPasseio() async {
      if(!verificarSessao(context)) return;
      if(!passeio.souOrganizador || !passeio.agendado) return;
      
      final confirmar = await showDialog<bool>(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Iniciar Passeio'),
          content: Text(
            'Queres iniciar "${passeio.nome}"?'
            'As novas inscrições serão encerradas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), 
              child: const Text('Voltar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true), 
              child: const Text('Iniciar'),
            ),
          ],
        ),
      );

      if(!mounted || confirmar != true) return;
      if(!verificarSessao(context)) return;
      if(!passeio.souOrganizador || !passeio.agendado) return;

      atualizarPasseio(
        passeio.copywith(estado: EstadoPasseio.emCurso),
      );

      await abrirPasseioEmCurso();
    }
    
    Future<void> abrirPasseioEmCurso() async {
        if(!verificarSessao(context)) return;
        if(!passeio.emCurso) return;
        if(!passeio.souOrganizador && !passeio.inscrito) return;

        final terminou = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => PasseioEmCursoScreen(passeio: passeio),
          ),
        );

        if(!mounted || terminou != true) return;

        atualizarPasseio(
          passeio.copywith(estado: EstadoPasseio.terminado),
        );
      }

  String formatarData(DateTime data) {
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/'
        '${data.year} : '
        '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  Widget informacao({
    required IconData icon,
    required String titulo,
    required String valor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(titulo),
        subtitle: Text(valor),
      ),
    );
  }

  Future<void> escolherVeiculo() async{
    if(!verificarSessao(context)) return;
    if(!passeio.agendado) return;

    if(GaragemStore.veiculos.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Adiciona primeiro um carro ou mota na Garagem',
          ),
        ),
      );
      return;
    }

    final escolhido = await showModalBottomSheet<Veiculo>(
      context: context,
      showDragHandle: true, 
      builder: (context){
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              Text(
                'Escoher veiculo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...GaragemStore.veiculos.map(
                (veiculo) => ListTile(
                  leading: Icon(
                    veiculo.tipo == 'Carro'
                        ? Icons.directions_car
                        : Icons.two_wheeler,
                  ),
                  title: Text(
                    '${veiculo.marca} ${veiculo.modelo}',
                  ),
                  subtitle: Text(veiculo.matricula),
                  trailing: identical(veiculo, _veiculoSelecionado)
                      ? const Icon(Icons.check)
                      : null,
                  onTap: (){
                    Navigator.of(context).pop(veiculo);
                  },
                ),
              ),
            ],
          ),
        );
      }
    );

    if(!mounted || escolhido == null) return;

    atualizarPasseio(passeio.copywith(veiculoSelecionado: escolhido),);
  }

  @override
  Widget build(BuildContext context) {
    final descricao = passeio.descricao.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Passeio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              passeio.nome,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  passeio.cancelado
                      ? Icons.cancel_outlined
                      : passeio.terminado
                          ? Icons.flag_outlined
                          : passeio.emCurso
                              ? Icons.navigation_outlined
                              : Icons.schedule,
                  color: passeio.cancelado ? Colors.redAccent : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  passeio.estadoTexto,
                  style: const TextStyle(fontWeight: FontWeight.bold,),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              descricao.isEmpty ? 'Este passeio não tem descrição.' : descricao,
            ),
            const SizedBox(height: 24),
            informacao(
              icon: Icons.trip_origin,
              titulo: 'Local de Partida',
              valor: passeio.partida,
            ),
            informacao(
              icon: Icons.location_on_outlined,
              titulo: 'Destino',
              valor: passeio.destino,
            ),
            informacao(
              icon: Icons.calendar_month,
              titulo: 'Data e hora',
              valor: formatarData(passeio.dataHora),
            ),
            informacao(
              icon: Icons.groups_outlined,
              titulo: 'Participantes',
              valor:
                  '$participantes / '
                  '${passeio.limiteParticipantes} participantes',
            ),
            if(_veiculoSelecionado != null)
              informacao(
                icon: _veiculoSelecionado!.tipo == 'Carro'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                titulo: 'Veiculo escolhido', 
                valor:  '${_veiculoSelecionado!.marca}'
                    '${_veiculoSelecionado!.modelo}\n'
                    '${_veiculoSelecionado!.matricula}',
              ),

              if(passeio.agendado)
                FilledButton.icon(
                  onPressed: escolherVeiculo, 
                  icon: const Icon(Icons.directions_car_outlined),
                  label: Text(
                    _veiculoSelecionado == null
                        ? 'Escolher Veiculo'
                        : 'Alterar Veiculo',
                  ),
                ),
              const SizedBox(height: 12),

              if(passeio.souOrganizador)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'És o organizador deste passeio.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if(passeio.agendado && !passeio.souOrganizador)
                if(passeio.inscrito)
                  OutlinedButton.icon(
                    onPressed: cancelarParticipacao,
                    icon: const Icon(Icons.person_remove_outlined), 
                    label: Text('Cancelar Participação'),
                  )
                else
                  FilledButton.icon(
                    onPressed: participantes >= passeio.limiteParticipantes
                        ? null
                        :confirmarParticipacao,
                    icon: const Icon(Icons.person_add_outlined), 
                    label: Text(
                      participantes >= passeio.limiteParticipantes
                          ? 'Passeio lotado'
                          : 'Confirmação Participação',
                    ),
                  ),
              if (passeio.inscrito &&
                  !passeio.souOrganizador &&
                  passeio.agendado)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'A tua participação está confirmada.',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                
              if (passeio.souOrganizador && passeio.agendado)
                FilledButton.icon(
                  onPressed: iniciarPasseio, 
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Passeio'),
                ),
              
              if (passeio.emCurso &&
                  (passeio.souOrganizador || passeio.inscrito))
                FilledButton.icon(
                  onPressed: abrirPasseioEmCurso,
                  icon: const Icon(Icons.map_outlined), 
                  label: const Text('Ver Passeio em curso'),
                ),
              if (passeio.emCurso &&
                  !passeio.souOrganizador &&
                  !passeio.inscrito)
                const Text('Este Passeio já começou. As inscrições estão encerradas.'),
              
              if (passeio.terminado)
                const Text('Este passeio terminou'),
              
              if (passeio.cancelado)
                const Text(
                  'Este Passeio foi cancelado.',
                  style: TextStyle(color: Colors.redAccent),
                ),
          ],
        ),
      ),
    );
  }
}
