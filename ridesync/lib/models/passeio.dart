class Passeio {
  final String nome;
  final String descricao;
  final String partida;
  final String destino;
  final DateTime dataHora;
  final int limiteParticipantes;
  final bool cancelado;

  const Passeio({
    required this.nome,
    required this.descricao,
    required this.partida,
    required this.destino,
    required this.dataHora,
    required this.limiteParticipantes,
    this.cancelado = false,
  }); 

  Passeio cancelar(){
    return Passeio(
      nome: nome, 
      descricao: descricao, 
      partida: partida, 
      destino: destino, 
      dataHora: dataHora, 
      limiteParticipantes: limiteParticipantes, 
      cancelado: true,
    );
  }
}