import 'package:ridesync/models/veiculo.dart';

enum EstadoPasseio{
  agendado,
  emCurso,
  terminado,
  cancelado,
}

class Passeio {
  final String nome;
  final String descricao;
  final String partida;
  final String destino;
  final DateTime dataHora;
  final int limiteParticipantes;
  final EstadoPasseio estado;
  final bool souOrganizador;

  final int participantesBase;
  final bool inscrito;
  final Veiculo? veiculoSelecionado;

  int get participantes => participantesBase + (inscrito ? 1 : 0);

  bool get cancelado => estado == EstadoPasseio.cancelado;
  bool get agendado => estado == EstadoPasseio.agendado;
  bool get emCurso => estado == EstadoPasseio.emCurso;
  bool get terminado => estado == EstadoPasseio.terminado;

  String get estadoTexto {
    switch(estado) {
      case EstadoPasseio.agendado:
        return 'Agendado';
      case EstadoPasseio.emCurso:
        return 'Em curso';
      case EstadoPasseio.terminado:
        return 'Terminado';
      case EstadoPasseio.cancelado:
        return 'Cancelado';
    }
  }


  const Passeio({
    required this.nome,
    required this.descricao,
    required this.partida,
    required this.destino,
    required this.dataHora,
    required this.limiteParticipantes,
    bool cancelado = false,
    EstadoPasseio estado = EstadoPasseio.agendado,
    this.participantesBase = 1,
    this.inscrito = false,
    this.veiculoSelecionado,
    this.souOrganizador = false,
  }) : estado = cancelado ? EstadoPasseio.cancelado : estado; 

  Passeio copywith({
    bool? cancelado,
    int? participantesBase,
    EstadoPasseio? estado,
    bool? inscrito,
    Veiculo? veiculoSelecionado,
  }) {
    return Passeio(
      nome: nome, 
      descricao: descricao, 
      partida: partida, 
      destino: destino, 
      dataHora: dataHora, 
      limiteParticipantes: limiteParticipantes,
      estado: cancelado == true
          ? EstadoPasseio.cancelado
          : estado ?? this.estado,
      participantesBase: participantesBase ?? this.participantesBase,
      inscrito: inscrito ?? this.inscrito,
      veiculoSelecionado: veiculoSelecionado ?? this.veiculoSelecionado,
      souOrganizador: souOrganizador,
    );
  }

  Passeio cancelar(){
    return copywith(estado: EstadoPasseio.cancelado);
  }
}