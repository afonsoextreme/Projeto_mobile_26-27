class Passeio {
  final String nome;
  final String descricao;
  final String partida;
  final String destino;
  final DateTime dataHora;
  final int limiteParticipantes;

  const Passeio({
    required this.nome,
    required this.descricao,
    required this.partida,
    required this.destino,
    required this.dataHora,
    required this.limiteParticipantes,
  }); 
}