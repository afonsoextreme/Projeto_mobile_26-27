import 'package:flutter/material.dart';
import 'package:ridesync/theme/app_theme.dart';
import 'package:ridesync/models/passeio.dart';

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
  final bool souOrganizador;
  final bool agendado;
  final EstadoPasseio estado;
  

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
    required this.souOrganizador,
    required this.agendado,
    required this.estado,
  });

  @override
  Widget build (BuildContext context){
    final (textoEstado, corEstado, iconeEstado) = switch (estado) {
      EstadoPasseio.agendado => (
        'Agendado',
        Colors.blue.shade800,
        Icons.schedule,
      ),
      EstadoPasseio.emCurso => (
        'Em curso',
        Colors.orange.shade900,
        Icons.navigation_outlined,
      ),
      EstadoPasseio.terminado => (
        'Terminado',
        Colors.green.shade800,
        Icons.flag_outlined,
      ),
      EstadoPasseio.cancelado => (
        'Cancelado',
        Colors.red.shade800,
        Icons.cancel_outlined,
      ),
    };
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
                    color: cancelado ? AppTheme.cinza : AppTheme.asfalto,
                    size: 36,
                  ),
                  if(souOrganizador && agendado)
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    iconeEstado,
                    color: corEstado,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    textoEstado,
                    style: TextStyle(
                      color: corEstado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(percurso),
              const SizedBox(height: 8),
              Text(
                data,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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