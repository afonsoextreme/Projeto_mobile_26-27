import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
void main() {
  runApp(const RideSyncApp());
}

class RideSyncApp extends StatelessWidget{
  const RideSyncApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RideSync',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange,
        brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101114),
      ),
      home: const MainScreen(),
    );
  }
}






  










