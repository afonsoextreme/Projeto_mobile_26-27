import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ridesync/services/passeios_service.dart';
import 'package:ridesync/services/sessao_store.dart';

class AuthException implements Exception {
  final String mensagem;

  const AuthException(this.mensagem);

  @override
  String toString() => mensagem;
}

class AuthService {
  static Future<void> autenticar({
    required bool registo,
    required String email, 
    required String password,
    String? nome,
  }) async {
    final rota = registo ? 'registo' : 'login';

    late http.Response resposta;

    try {
      resposta = await http
          .post(
            Uri.parse(
              '${PasseiosService.baseUrl}/api/auth/$rota',
            ),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body:  jsonEncode({
              if (registo) 'nome': nome,
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const AuthException(
        'O servidor demorou a responder. Tenta novamente.',
      );
    }

    final Object? conteudo;

    try {
      conteudo = jsonDecode(utf8.decode(resposta.bodyBytes));
    } on FormatException {
      throw const AuthException('Não foi possivel concluir o pedido. Tenta novamente');
    }

    if (conteudo is! Map<String, dynamic>) {
      throw const AuthException('Não foi possivel concluir o pedido. Tenta novamente');
    }

    final sucesso = registo
        ? resposta.statusCode == 201
        : resposta.statusCode == 200;
    
    if (!sucesso) {
      throw AuthException(
        conteudo['mensagem'] is String
            ? conteudo['mensagem'] as String
            : 'Não foi possivel autenticar.',
      );
    }

    final utilizador = conteudo['utilizador'];
    final token = conteudo['token'];

    if (utilizador is! Map<String, dynamic> ||
        utilizador['id'] is! int ||
        utilizador['nome'] is! String ||
        utilizador['email'] is! String ||
        token is! String ||
        token.isEmpty) {
      throw const AuthException('Dados de sessão invalidos');
    }

    SessaoStore.entrar(
      idUtilizador: utilizador['id'] as int, 
      nomeUtilizador: utilizador['nome'] as String, 
      emailUtilizador: utilizador['email'] as String, 
      tokenSessao: token,
    );
  }
}