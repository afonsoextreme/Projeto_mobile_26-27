class Veiculo {
  final int? id;
  final String tipo;
  final String marca;
  final String modelo;
  final String matricula;

  const Veiculo({
    this.id,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.matricula,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      id: json['id'] as int,
      tipo: json['tipo'] as String, 
      marca: json ['marca'] as String, 
      modelo: json['modelo'] as String, 
      matricula: json['matricula'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'marca': marca,
      'modelo': modelo,
      'matricula': matricula,
    };
  }
}
