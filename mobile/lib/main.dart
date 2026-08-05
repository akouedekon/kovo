import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const KovoApp());
}

class KovoApp extends StatelessWidget {
  const KovoApp({super.key});

  // Replace with your backend base URL
  static const apiBase = 'https://api.kovo.example.com';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kovo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(apiBase: apiBase),
    );
  }
}
