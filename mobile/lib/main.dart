import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const KovoApp());

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'KOVO_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}

class ApiClient {
  const ApiClient();

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: queryParameters);
  }

  Future<List<RideItem>> searchRides({String? from, String? to}) async {
    final response = await http.get(
      _uri('/api/rides', {
        if (from != null && from.isNotEmpty) 'from': from,
        if (to != null && to.isNotEmpty) 'to': to,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load rides');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => RideItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> requestOtp(String email) async {
    final response = await http.post(
      _uri('/api/auth/request-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String code) async {
    final response = await http.post(
      _uri('/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createBooking({
    required int rideId,
    required int passengerId,
    required int seatsBooked,
  }) async {
    final response = await http.post(
      _uri('/api/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rideId': rideId,
        'passengerId': passengerId,
        'seatsBooked': seatsBooked,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPayment({
    required int bookingId,
    required int amount,
  }) async {
    final response = await http.post(
      _uri('/api/payments/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'bookingId': bookingId, 'amount': amount}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class RideItem {
  final int? id;
  final String origin;
  final String destination;
  final String departureTime;
  final int seatsAvailable;

  RideItem({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.seatsAvailable,
  });

  factory RideItem.fromJson(Map<String, dynamic> json) {
    return RideItem(
      id: json['id'] as int?,
      origin: (json['origin'] ?? '') as String,
      destination: (json['destination'] ?? '') as String,
      departureTime: (json['departureTime'] ?? '') as String,
      seatsAvailable: (json['seatsAvailable'] ?? 0) as int,
    );
  }
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
      home: const AppShell(api: ApiClient()),
    );
  }
}

class AppShell extends StatefulWidget {
  final ApiClient api;
  const AppShell({super.key, required this.api});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  late final List<Widget> _screens = [
    HomeTab(api: widget.api),
    SearchTab(api: widget.api),
    const TripsTab(),
    const MessagesTab(),
    ProfileTab(api: widget.api),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Recherche'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Trajets'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final ApiClient api;
  const HomeTab({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kovo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HeroCard(),
          SizedBox(height: 16),
          _SectionTitle(title: 'Accès rapide'),
          SizedBox(height: 8),
          _QuickGrid(),
          SizedBox(height: 20),
          _SectionTitle(title: 'Recommandations'),
          SizedBox(height: 8),
          _TripCard(from: 'Cotonou', to: 'Abomey-Calavi', time: '08:30', price: '1 500 FCFA', seats: '3 places'),
          _TripCard(from: 'Porto-Novo', to: 'Cotonou', time: '17:10', price: '2 000 FCFA', seats: '2 places'),
        ],
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  final ApiClient api;
  const SearchTab({super.key, required this.api});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  late Future<List<RideItem>> ridesFuture = widget.api.searchRides();

  void _search() {
    setState(() {
      ridesFuture = widget.api.searchRides(
        from: fromController.text.trim(),
        to: toController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: fromController, decoration: const InputDecoration(labelText: 'Départ', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: toController, decoration: const InputDecoration(labelText: 'Destination', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _search, icon: const Icon(Icons.search), label: const Text('Rechercher')),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Résultats'),
          const SizedBox(height: 8),
          FutureBuilder<List<RideItem>>(
            future: ridesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Impossible de charger les trajets: ${snapshot.error}');
              }
              final rides = snapshot.data ?? [];
              if (rides.isEmpty) {
                return const Text('Aucun trajet trouvé.');
              }
              return Column(
                children: rides
                    .map(
                      (ride) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.directions_car)),
                          title: Text('${ride.origin} → ${ride.destination}'),
                          subtitle: Text('${ride.departureTime} • ${ride.seatsAvailable} places'),
                          trailing: TextButton(
                            onPressed: () => _book(context, ride),
                            child: const Text('Réserver'),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _book(BuildContext context, RideItem ride) async {
    if (ride.id == null) return;
    final result = await widget.api.createBooking(rideId: ride.id!, passengerId: 1, seatsBooked: 1);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Réservation créée: ${result['bookingId']}')));
  }
}

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trajets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle(title: 'Mes trajets'),
          SizedBox(height: 8),
          _TripCard(from: 'Réservé: Cotonou', to: 'Abomey-Calavi', time: 'Aujourd’hui', price: 'Payé', seats: '2 passagers'),
          _TripCard(from: 'Terminé: Porto-Novo', to: 'Cotonou', time: 'Hier', price: '2 000 FCFA', seats: '1 passager'),
        ],
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _MessageTile(name: 'Awa', message: 'Je serai au point de rendez-vous dans 10 min.', time: '08:12'),
          _MessageTile(name: 'Koffi', message: 'Le siège avant est disponible ?', time: 'Hier'),
          _MessageTile(name: 'Support Kovo', message: 'Votre paiement a été confirmé.', time: 'Hier'),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final ApiClient api;
  const ProfileTab({super.key, required this.api});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final emailController = TextEditingController(text: 'demo@kovo.app');
  final otpController = TextEditingController();
  String? _message;
  Map<String, dynamic>? _tokens;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 34)),
          const SizedBox(height: 12),
          const Text('Utilisateur Kovo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Compte vérifié • Bénin'),
          const SizedBox(height: 20),
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _requestOtp,
            child: const Text('Demander OTP'),
          ),
          const SizedBox(height: 12),
          TextField(controller: otpController, decoration: const InputDecoration(labelText: 'OTP', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: _verifyOtp,
            child: const Text('Vérifier OTP'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(_message!),
          ],
          if (_tokens != null) ...[
            const SizedBox(height: 12),
            Text('Access: ${_tokens!['accessToken'] ?? ''}'),
            Text('Refresh: ${_tokens!['refreshToken'] ?? ''}'),
          ],
          const SizedBox(height: 20),
          const _ProfileAction(icon: Icons.payment_outlined, title: 'Portefeuille'),
          const _ProfileAction(icon: Icons.history, title: 'Historique'),
          const _ProfileAction(icon: Icons.security, title: 'Sécurité'),
          const _ProfileAction(icon: Icons.settings_outlined, title: 'Paramètres'),
        ],
      ),
    );
  }

  Future<void> _requestOtp() async {
    final result = await widget.api.requestOtp(emailController.text.trim());
    setState(() => _message = 'OTP demandé: ${result['status'] ?? result}');
  }

  Future<void> _verifyOtp() async {
    final result = await widget.api.verifyOtp(emailController.text.trim(), otpController.text.trim());
    setState(() {
      _tokens = result;
      _message = 'Connexion réussie';
    });
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Déplace-toi plus vite au Bénin', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Trouve un trajet, réserve ta place et suis ton conducteur en quelques gestes.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: () {}, child: const Text('Commencer')),
          ],
        ),
      ),
    );
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: const [
        _QuickAction(icon: Icons.my_location, title: 'Où aller ?', subtitle: 'Trouver un trajet'),
        _QuickAction(icon: Icons.add_circle_outline, title: 'Publier', subtitle: 'Créer un trajet'),
        _QuickAction(icon: Icons.payments_outlined, title: 'Paiement', subtitle: 'Wallet et coupons'),
        _QuickAction(icon: Icons.support_agent, title: 'Assistance', subtitle: 'Aide 24/7'),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _QuickAction({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final String from;
  final String to;
  final String time;
  final String price;
  final String seats;
  const _TripCard({required this.from, required this.to, required this.time, required this.price, required this.seats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.directions_car)),
        title: Text('$from → $to'),
        subtitle: Text('$time • $seats'),
        trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _MessageTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  const _MessageTile({required this.name, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name.characters.first)),
        title: Text(name),
        subtitle: Text(message),
        trailing: Text(time),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ProfileAction({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right)),
    );
  }
}
