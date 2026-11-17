import 'package:flutter/foundation.dart';

class SessaoStore {
  static final iniciada = ValueNotifier<bool>(false);

  static int? utilizadorId;
  static String nome = '';
  static String email = '';
  static String? token;

  static void entrar({
    required int idUtilizador,
    required String nomeUtilizador,
    required String emailUtilizador,
    required String tokenSessao,
  }) {
    utilizadorId = idUtilizador;
    nome = nomeUtilizador;
    email = emailUtilizador;
    iniciada.value = true;
    token = tokenSessao;
    iniciada.value = true;
  }

  static void sair() {
    utilizadorId = null;
    nome = '';
    email = '';
    token = null;
    iniciada.value = false;
  }
}