import 'package:flutter/material.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/models/veiculo.dart';
import 'package:ridesync/services/garagem_store.dart';

class DetalhesPasseioScreen extends StatefulWidget {
  final Passeio passeio;
  final int participantes;

  const DetalhesPasseioScreen({
    super.key,
    required this.passeio,
    required this.participantes,
  });

  @override
  State<DetalhesPasseioScreen> createState() => _DetalhesPasseioScreenState();
}

  class _DetalhesPasseioScreenState extends State<DetalhesPasseioScreen> {
    Veiculo? _veiculoSelecionado;

    Passeio get passeio => widget.passeio;
    int get participantes => widget.participantes;

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
    if(passeio.cancelado) return;

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

    setState(() {
      _veiculoSelecionado = escolhido;
    });
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
                      : Icons.check_circle_outline,
                  color: passeio.cancelado ? Colors.redAccent : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  passeio.cancelado ? 'Cancelado' : 'Ativo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: passeio.cancelado ? Colors.redAccent : Colors.green,
                  ),
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
                valor: '${_veiculoSelecionado!.marca}'
                    '${_veiculoSelecionado!.modelo}\n'
                    '${_veiculoSelecionado!.matricula}',
              ),

            FilledButton.icon(
              onPressed: passeio.cancelado ? null : escolherVeiculo,
              icon: const Icon(Icons.directions_car_outlined), 
              label: Text(
                _veiculoSelecionado == null
                    ? 'Escolher veiculo'
                    :'Alterar veiculo',
              ),
            ),

            const SizedBox(height: 12),
            
            if (passeio.cancelado)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Este Passeio foi Cancelado',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
