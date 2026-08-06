import 'package:flutter/material.dart';

void main() {
  runApp(const KovoApp());
}

class KovoApp extends StatelessWidget {
  const KovoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kovo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kovo')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kovo', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text(
              'Application de covoiturage au Bénin.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statut', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Mobile stabilisé, base prête pour les écrans métier.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
