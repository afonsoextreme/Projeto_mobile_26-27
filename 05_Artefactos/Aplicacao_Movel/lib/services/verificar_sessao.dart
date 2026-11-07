import 'package:flutter/material.dart';
import 'package:ridesync/screens/auth_screen.dart';
import 'sessao_store.dart';

bool verificarSessao(BuildContext context) {
  if(SessaoStore.iniciada.value) return true;

  Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (context) => const AuthScreen(),
    ),
  );

  return false;
}