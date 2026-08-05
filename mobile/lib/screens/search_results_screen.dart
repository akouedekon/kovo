import 'package:flutter/material.dart';
import '../services/api.dart';
import 'dart:convert';
import '../models/ride.dart';
import '../services/token_storage.dart';
import 'ride_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String apiBase;
  final String from;
  final String to;
  const SearchResultsScreen({super.key, required this.apiBase, required this.from, required this.to});
  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Ride> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(()=>_loading=true);
    final storage = TokenStorage();
    final api = ApiClient(baseUrl: widget.apiBase, storage: storage);
    try {
      final res = await api.get('/api/rides/search?from=${Uri.encodeComponent(widget.from)}&to=${Uri.encodeComponent(widget.to)}', withAuth: true);
      if (res.statusCode==200) {
        final listJson = res.body.isNotEmpty ? res.body : '[]';
        try {
          final parsed = (listJson.isNotEmpty) ? (await Future.value(List.from(jsonDecode(listJson)))) : <dynamic>[];
          _rides = parsed.map((e) => Ride.fromJson(e as Map<String, dynamic>)).toList();
        } catch (e) {
          // ignore parse error
        }
      }
    } catch(e){ }
    setState(()=>_loading=false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: _rides
                  .map((r) => ListTile(
                        title: Text(r.driverName),
                        subtitle: Text('${r.price} CFA - seats ${r.seatsAvailable}'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RideDetailScreen(ride: r, apiBase: widget.apiBase))),
                      ))
                  .toList(),
            ));
  }
}
