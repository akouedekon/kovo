import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  LatLng _center = const LatLng(6.369028, 2.391903); // Cotonou default
  GoogleMapController? _mapCtrl;

  void _search() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsScreen(apiBase: widget.apiBase, from: _fromCtl.text, to: _toCtl.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kovo')),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: _fromCtl, decoration: InputDecoration(labelText: 'From'))), SizedBox(width:8), Expanded(child: TextField(controller: _toCtl, decoration: InputDecoration(labelText: 'To'))), SizedBox(width:8), ElevatedButton(onPressed: _search, child: Text('Search'))])),
        Expanded(child: GoogleMap(initialCameraPosition: CameraPosition(target: _center, zoom: 12), onMapCreated: (c) => _mapCtrl = c)),
      ],),
    );
  }
}
