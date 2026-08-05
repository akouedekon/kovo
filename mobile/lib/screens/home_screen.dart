import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../services/api.dart';
import '../services/token_storage.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  final String apiBase;
  const HomeScreen({super.key, required this.apiBase});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fromCtl = TextEditingController();
  final _toCtl = TextEditingController();
  final LatLng _center = LatLng(6.369028, 2.391903); // Cotonou default
  late MapController _mapCtrl;

  @override
  void initState() {
    super.initState();
    _mapCtrl = MapController();
  }

  void _search() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsScreen(apiBase: widget.apiBase, from: _fromCtl.text, to: _toCtl.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kovo')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: _fromCtl, decoration: const InputDecoration(labelText: 'From'))), const SizedBox(width:8), Expanded(child: TextField(controller: _toCtl, decoration: const InputDecoration(labelText: 'To'))), const SizedBox(width:8), ElevatedButton(onPressed: _search, child: const Text('Search'))])),
        Expanded(child: FlutterMap(
          mapController: _mapCtrl,
          options: MapOptions(
            center: _center,
            zoom: 12,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.kovo.mobile',
            ),
          ],
        )),
      ],),
    );
  }
}
