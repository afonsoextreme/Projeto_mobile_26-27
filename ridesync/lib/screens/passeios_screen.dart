import 'package:flutter/material.dart';
import 'package:ridesync/models/passeio.dart';
import 'package:ridesync/widgets/passeio_card.dart';
import 'criar_passeio_screen.dart';

class PasseiosScreen extends StatefulWidget{
  const PasseiosScreen({super.key});
  
  @override
  State<PasseiosScreen> createState() => _PasseioScreenState();
}

class _PasseioScreenState extends State<PasseiosScreen>{
  final List <Passeio> passeios = [];

  String formatarData(DateTime data){
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}'
        '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  Future<void> criarPasseio() async{
    final novoPasseio = await Navigator.of(context).push<Passeio>(
      MaterialPageRoute(
        builder: (context) => const CriarPasseioScreen(),
      ),
    );  
    
    if (!mounted || novoPasseio == null) return;

    setState(() {
      passeios.add(novoPasseio);

      passeios.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio criado com sucesso!'),
      ),
    );
  }

  Future<void> editarPasseio(Passeio passeio) async{
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

    setState(() {
      passeios[indice] = passeioEditado;

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

  Future<void> apagarPasseio(Passeio passeio) async {
    final confirmar = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Apagar passeio'),
        content: Text(
          'Queres apagar o passeio "${passeio.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Cancelar'),
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

    setState(() {
      passeios.remove(passeio);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio Apagado.'),
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
          onPressed: criarPasseio, 
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
        if(passeios.isEmpty)
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
              participantes: 1, 
              limiteParticipantes: passeio.limiteParticipantes,
              icon: Icons.route,
              onEditar: () => editarPasseio(passeio),
              onApagar: () => apagarPasseio(passeio),
            ),
          ),
        ),
      ],
    );
  }
}