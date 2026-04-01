import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SavingsApp());
}

class SavingsApp extends StatefulWidget {
  const SavingsApp({super.key});

  @override
  State<SavingsApp> createState() => _SavingsAppState();
}

class _SavingsAppState extends State<SavingsApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savings',
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}
