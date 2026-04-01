import 'package:flutter/material.dart';
import 'package:tofu_expressive/tofu_expressive.dart';
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
      theme: TofuTheme.light(Colors.teal),
      darkTheme: TofuTheme.dark(Colors.teal),
      home: HomeScreen(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}
