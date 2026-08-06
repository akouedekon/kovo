import 'package:flutter/material.dart';

void main() => runApp(const KovoApp());

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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeTab(),
    SearchTab(),
    TripsTab(),
    MessagesTab(),
    ProfileTab(),
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
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kovo'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroCard(),
          const SizedBox(height: 16),
          const _SectionTitle(title: 'Accès rapide'),
          const SizedBox(height: 8),
          GridView.count(
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
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Recommandations'),
          const SizedBox(height: 8),
          const _TripCard(
            from: 'Cotonou',
            to: 'Abomey-Calavi',
            time: '08:30',
            price: '1 500 FCFA',
            seats: '3 places',
          ),
          const _TripCard(
            from: 'Porto-Novo',
            to: 'Cotonou',
            time: '17:10',
            price: '2 000 FCFA',
            seats: '2 places',
          ),
        ],
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SearchField(label: 'Départ', hint: 'Ville, quartier, point de rendez-vous'),
          const SizedBox(height: 12),
          const _SearchField(label: 'Destination', hint: 'Où veux-tu aller ?'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text('Rechercher'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: 'Résultats'),
          const SizedBox(height: 8),
          const _TripCard(
            from: 'Cotonou',
            to: 'Parakou',
            time: '06:45',
            price: '7 000 FCFA',
            seats: '4 places',
          ),
          const _TripCard(
            from: 'Abomey-Calavi',
            to: 'Sèmè-Kpodji',
            time: '18:15',
            price: '1 200 FCFA',
            seats: '3 places',
          ),
        ],
      ),
    );
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
          SizedBox(height: 20),
          _SectionTitle(title: 'Historique'),
          SizedBox(height: 8),
          _InfoTile(icon: Icons.check_circle, title: 'Trajet confirmé', subtitle: 'Départ 08:30, arrivée 09:10'),
          _InfoTile(icon: Icons.star_outline, title: 'Note du conducteur', subtitle: '4.8/5 sur 132 courses'),
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

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CircleAvatar(radius: 34, child: Icon(Icons.person, size: 34)),
          SizedBox(height: 12),
          Text('Utilisateur Kovo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Compte vérifié • Bénin'),
          SizedBox(height: 20),
          _ProfileAction(icon: Icons.payment_outlined, title: 'Portefeuille'),
          _ProfileAction(icon: Icons.history, title: 'Historique'),
          _ProfileAction(icon: Icons.security, title: 'Sécurité'),
          _ProfileAction(icon: Icons.settings_outlined, title: 'Paramètres'),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
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

class _SearchField extends StatelessWidget {
  final String label;
  final String hint;
  const _SearchField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(subtitle));
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
