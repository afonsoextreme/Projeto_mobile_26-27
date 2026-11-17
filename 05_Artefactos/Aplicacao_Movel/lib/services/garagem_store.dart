import 'dart:async';
import 'dart:convert';


import 'package:ridesync/models/veiculo.dart';
import 'package:http/http.dart' as http;
import 'package:ridesync/services/passeios_service.dart';
import 'package:ridesync/services/sessao_store.dart';

class GaragemException implements Exception {
  final String mensagem;

  const GaragemException(this.mensagem);

  @override
  String toString() => mensagem;
}

class GaragemStore {
  static final List<Veiculo> veiculos = [];

  static int _versao = 0;

  static void limpar() {
    _versao++;
    veiculos.clear();
  }

  static Future<dynamic> _pedido(
    String metodo, {
      int? id,
      Veiculo? veiculo,
    }) async {
      final token = SessaoStore.token;

      if (token == null || token.isEmpty) {
        throw const GaragemException('Inicia sessão para continuar.');
      }

      final uri = Uri.parse(
        '${PasseiosService.baseUrl}/api/veiculos'
        '${id == null ? '' : '/$id'}',
      );

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      late http.Response resposta;

      try{
        final Future<http.Response> pedido;
        
        switch (metodo) {
          case 'GET':
            pedido = http.get(uri, headers: headers);
            break;
          case 'POST':
            pedido = http.post(
              uri,
              headers: headers,
              body: jsonEncode(veiculo!.toJson()),
            );
            break;
          case 'DELETE':
            pedido = http.delete(uri, headers: headers);
            break;
          default:
            throw const GaragemException('Pedido inválido');
        }

        resposta = await pedido.timeout(const Duration(seconds: 15));
      } on TimeoutException {
        throw const GaragemException(
          'O servidor demorou a responder.'
          'Atualiza a garagem para confimar o resultado.',
        );
      } on http.ClientException {
        throw const GaragemException(
          'Não foi possivel contactar o servidor.'
          'Verifica a ligação e atualiza a garagem',
        );
      }

      if(SessaoStore.token != token){
        throw const GaragemException(
          'A sessão mudou. Abre novamenre a garagem'
        );
      }

      if(resposta.statusCode == 401) {
        limpar();
        SessaoStore.sair();

        throw const GaragemException(
          'A sessão expirou. Entra novamente.',
        );
      }

      if(resposta.statusCode == 204) return null;

      final dynamic dados;

      try {
        dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      } on FormatException {
        throw const GaragemException(
          'Não foi possivel confrimar o pedido. Atualiza a garagem',
        );
      }

      if(resposta.statusCode < 200 || resposta.statusCode >= 300) {
        throw GaragemException(
          dados is Map && dados['mensagem'] is String
              ? dados['mensagem'] as String
              : 'Não foi possivel concluir o pedido.',
        );
      }

      return dados;
    }

    static Future<void> carregar() async {
      final versao = ++_versao;

      if (!SessaoStore.iniciada.value) {
        veiculos.clear();
        return;
      }

      final dados = await _pedido('GET') as List<dynamic>;

      if(versao != _versao) return;

      final carregados = dados
          .map(
            (item) => Veiculo.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      veiculos
        ..clear()
        ..addAll(carregados);
    }

    static Future<void> guardar(Veiculo veiculo) async {
      final dados = await _pedido(
        veiculo.id == null ? 'POST' : 'PUT',
        id: veiculo.id,
        veiculo: veiculo, 
      );

      final guardado = Veiculo.fromJson(
        dados as Map<String, dynamic>,
      );

      _versao++;

      final indice = veiculos.indexWhere(
        (item) => item.id == guardado.id,
      );

      if (indice == -1) {
        veiculos.insert(0, guardado);
      } else {
        veiculos[indice] = guardado;
      }
    }

    static Future<void> apagar(Veiculo veiculo) async {
      if (veiculo.id == null) {
        throw const GaragemException('Veiculo sem identificador');
      }

      await _pedido('DELETE', id: veiculo.id);

      _versao++;
      veiculos.removeWhere((item) => item.id == veiculo.id);
    }
}