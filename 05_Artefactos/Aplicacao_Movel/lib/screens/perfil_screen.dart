import 'package:flutter/material.dart';
import 'package:ridesync/services/sessao_store.dart';
import 'auth_screen.dart';

class PerfilScreen extends StatelessWidget{
  const PerfilScreen({super.key});

  void abrirAutenticacao(
    BuildContext context, {
      bool registo = false,
  }) {
    Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AuthScreen(
          iniciarNoRegisto: registo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SessaoStore.iniciada, 
      builder: (context, temSessao, child) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              temSessao ? SessaoStore.nome : 'O meu Perfil',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              temSessao
                  ? SessaoStore.email
                  : 'Entra ou cria conta para organizar e participar '
                      'em passeios.',
              textAlign: TextAlign.center,
            ),
            if (!temSessao) ...[
              FilledButton.icon(
                onPressed: () => abrirAutenticacao(context), 
                icon: const Icon(Icons.login),
                label: const Text('Entrar'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>abrirAutenticacao(
                  context,
                  registo: true,
                ),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Criar Conta'),
              ),
            ] else ...[
              const Card(
                child: ListTile(
                  leading: Icon(Icons.speed),
                  title: Text('Quilometros percorridos'),
                  trailing: Text('0 km'),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: SessaoStore.sair,
                icon: const Icon(Icons.logout), 
                label: const Text('Terminar Sessão'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sessão e estatisticas de demonstração.',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      }
    );
  }
}