import 'package:flutter/material.dart';

class PasseioCard extends StatelessWidget{
  final String titulo;
  final String percurso;
  final String data;
  final int participantes;
  final IconData icon;
  final VoidCallback onEditar;
  final VoidCallback onApagar;
  final int limiteParticipantes;

  const PasseioCard({
    super.key,
    required this.titulo,
    required this.percurso,
    required this.data,
    required this.participantes,
    required this.icon,
    required this.onEditar,
    required this.onApagar,
    required this.limiteParticipantes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.orange, size: 36
                ),
                PopupMenuButton<String>(
                  tooltip: 'Opções do Passeio',
                  onSelected: (opcao){
                    if(opcao == 'Editar'){
                      onEditar();
                    } else if (opcao == 'Apagar'){
                      onApagar();
                    }
                  },
                  itemBuilder: (context) => const[
                    PopupMenuItem(
                      value: 'Editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 12),
                          Text('Editar'),
                        ],
                      )
                    ),
                    PopupMenuItem(
                      value: 'Apagar',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Apagar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(percurso),
            const SizedBox(height: 8),
            Text(
              data,
              style: const TextStyle(color: Colors.white60),
            ),
            const Divider(height: 28),
            Row(
              children: [
                const Icon(Icons.group_outlined, size: 20),
                const SizedBox(width: 8),
                Text('$participantes / $limiteParticipantes participantes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}