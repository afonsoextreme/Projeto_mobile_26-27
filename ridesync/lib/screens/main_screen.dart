import 'package:flutter/material.dart';
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
    const paginas = [
      PasseiosScreen(),
      GaragemScreen(),
      PerfilScreen(),
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