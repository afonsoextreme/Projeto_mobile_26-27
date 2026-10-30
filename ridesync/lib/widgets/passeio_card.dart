import 'package:flutter/material.dart';

class PasseioCard extends StatelessWidget{
  final String titulo;
  final String percurso;
  final String data;
  final int participantes;
  final int limiteParticipantes;
  final IconData icon;
  final bool cancelado;
  final VoidCallback onEditar;
  final VoidCallback onCancelar;
  final VoidCallback onAbrir;
  

  const PasseioCard({
    super.key,
    required this.titulo,
    required this.percurso,
    required this.data,
    required this.participantes,
    required this.limiteParticipantes,
    required this.cancelado,
    required this.icon,
    required this.onEditar,
    required this.onCancelar,
    required this.onAbrir,
  });

  @override
  Widget build (BuildContext context){
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAbrir,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: cancelado ? Colors.grey : Colors.orange,
                    size: 36,
                  ),
                  if(!cancelado)
                    PopupMenuButton<String>(
                      tooltip: 'Opções do Passeio',
                      onSelected: (opcao){
                        if(opcao == 'editar'){
                          onEditar();
                        } else if (opcao == 'cancelar'){
                        onCancelar();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'editar',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(width: 12),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cancelar',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Cancelar Passeio',
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
              if(cancelado) ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color:  Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Cancelado',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
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
                  const Icon(Icons.group_add_outlined,size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$participantes / $limiteParticipantes participantes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ), 
      ),
    );
  }
}