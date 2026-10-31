import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ridesync/models/passeio.dart';

class PasseiosService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Passeio>> listarPasseios() async {
    final resposta = await http
        .get(Uri.parse('$baseUrl/api/passeios'))
        .timeout(const Duration(seconds: 10));
    if(resposta.statusCode != 200){
      throw Exception(
        'Erro ao carregar passeios: ${resposta.statusCode}',
      );
    }

    final dados = jsonDecode(
      utf8.decode(resposta.bodyBytes),
    ) as List<dynamic>;

    final passeios = dados.map((item){
      final json = item as Map<String, dynamic>;

      return Passeio(
        nome: json['nome'] as String, 
        descricao: json['descricao'] as String, 
        partida: json ['partida'] as String, 
        destino: json['destino'] as String, 
        dataHora: DateTime.parse(json['data'] as String), 
        limiteParticipantes: json['limiteParticipantes'] as int,
        cancelado: json['estado'] == 'cancelado'
      );
    }).toList();

    passeios.sort(
      (a, b) => a.dataHora.compareTo(b.dataHora),
    );

    return passeios;
  }
}