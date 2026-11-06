import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

class RideSyncApp extends StatelessWidget{
  const RideSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RideSync',
      theme: AppTheme.light,
      home: const MainScreen(),
    );
  }
}