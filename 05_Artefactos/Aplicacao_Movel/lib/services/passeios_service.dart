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
        id: json['id'] as int,
        nome: json['nome'] as String, 
        descricao: json['descricao'] as String, 
        partida: json ['partida'] as String, 
        destino: json['destino'] as String, 
        dataHora: DateTime.parse(json['data'] as String).toLocal(), 
        limiteParticipantes: json['limiteParticipantes'] as int,
        participantesBase: json['participantes'] as int? ?? 1,
        estado: switch(json['estado']){
          'emCurso' => EstadoPasseio.emCurso,
          'terminado' => EstadoPasseio.terminado,
          'cancelado' => EstadoPasseio.cancelado,
          _ => EstadoPasseio.agendado,
        },
      );
    }).toList();

    passeios.sort(
      (a, b) => a.dataHora.compareTo(b.dataHora),
    );

    return passeios;
  }

  static Future<Passeio> criarPasseio(Passeio passeio) async {
      final resposta = await http
          .post(
            Uri.parse('$baseUrl/api/passeios'),
            headers: {
              'Content-Type' : 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'nome': passeio.nome,
              'descricao': passeio.descricao,
              'partida': passeio.partida,
              'destino': passeio.destino,
              'data': passeio.dataHora.toUtc().toIso8601String(),
              'limiteParticipantes': passeio.limiteParticipantes,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (resposta.statusCode != 201) {
        throw Exception(
          'Não foi possivel criar o passeio '
          '(codigo ${resposta.statusCode}).',
        );
      }

      final json = jsonDecode(
        utf8.decode(resposta.bodyBytes),
      ) as Map<String, dynamic>;
        
      return passeio.copywith(
        id: json['id'] as int,
        estado: EstadoPasseio.agendado,
      );
    }
}