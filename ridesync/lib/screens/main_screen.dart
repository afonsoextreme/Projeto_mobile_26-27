import 'package:flutter/material.dart';
import 'package:ridesync/services/sessao_store.dart';
import 'auth_screen.dart';
import 'passeios_screen.dart';
import 'garagem_screen.dart';
import 'perfil_screen.dart';


class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int paginaAtual = 0;
  
  @override
  Widget build(BuildContext context) {
    final paginas = [
      const PasseiosScreen(),
      ValueListenableBuilder<bool>(
        valueListenable: SessaoStore.iniciada, 
        builder: (context,  temSessao, child) {
          if(temSessao) {
            return const GaragemScreen();
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.garage_outlined, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Inicia sessão para gerir a tua garagem.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    }, 
                    icon: const Icon(Icons.login),
                    label: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          );
        }
      ),
      const PerfilScreen(),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RideSync', style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle:  true,
      ),
      body: IndexedStack(
        index: paginaAtual,
        children: paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        onDestinationSelected: (index){
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: const[
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Passeios'
          ),
          NavigationDestination(
            icon: Icon(Icons.garage_outlined),
            selectedIcon: Icon(Icons.garage),
            label: 'Garagem'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}