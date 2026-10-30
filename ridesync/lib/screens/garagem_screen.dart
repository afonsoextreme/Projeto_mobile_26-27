import 'package:flutter/material.dart';
import 'package:ridesync/models/veiculo.dart';
import 'criar_veiculo_screen.dart';
import 'package:ridesync/theme/app_theme.dart';

class GaragemScreen extends StatefulWidget{
  const GaragemScreen({super.key});

  @override
  State<GaragemScreen> createState() => _GaragemScreenState();
}

class _GaragemScreenState extends State<GaragemScreen>{
  final List<Veiculo> veiculos =[];

  Future<void> abrirFormulario({Veiculo? veiculo}) async {
    final resultado = await Navigator.of(context).push<Veiculo>(
      MaterialPageRoute(
        builder: (context) => CriarVeiculoScreen(
          veiculo: veiculo,
        ),
      ),
    );

    if(!mounted || resultado == null) return;

    if(veiculo == null){
      setState(() {
        veiculos.add(resultado);
      });
    } else {
      final indice = veiculos.indexOf(veiculo);

      if(indice == -1) return;

      setState(() {
        veiculos[indice] = resultado;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          veiculo == null
              ? 'Veiculo adicionado à garagem'
              : 'Veiculo adicionado'
        ),
      ),
    );
  }

  Future<void> apagarVeiculo(Veiculo veiculo) async{
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
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text(
              'Apagar',style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if(!mounted || confirmar != true) return;

    setState(() {
      veiculos.remove(veiculo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Veiculo Apagado'),
      ),
    );
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
          onPressed: () => abrirFormulario(), 
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Veiculo'),
        ),
        const SizedBox(height: 24),
        if(veiculos.isEmpty)
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