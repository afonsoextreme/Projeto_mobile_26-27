import 'package:flutter/foundation.dart';

class SessaoStore {
  static final iniciada = ValueNotifier<bool>(false);

  static String nome = '';
  static String email = '';

  static void entrar({
    required String nomeUtilizador,
    required String emailUtilizador,
  }) {
    nome = nomeUtilizador;
    email = emailUtilizador;
    iniciada.value = true;
  }

  static void sair() {
    nome = '';
    email = '';
    iniciada.value = false;
  }
}