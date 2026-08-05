import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  runApp(const KovoApp());
}

Future<void> _requestPermissions() async {
  await Permission.location.request();
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
