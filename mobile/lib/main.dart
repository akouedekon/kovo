import 'package:flutter/material.dart';

void main() {
  runApp(const KovoApp());
}

class KovoApp extends StatelessWidget {
  const KovoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kovo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kovo')),
      body: const Center(child: Text('Bienvenue sur Kovo — prototype')),
    );
  }
}
