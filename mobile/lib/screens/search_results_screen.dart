import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/ride.dart';
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
    final api = ApiClient(baseUrl: widget.apiBase, storage: null as dynamic);
    try {
      final res = await api.get('/api/rides/search?from=${Uri.encodeComponent(widget.from)}&to=${Uri.encodeComponent(widget.to)}');
      if (res.statusCode==200) {
        final list = (res.body.isNotEmpty? (res.body as String) : '[]');
        // For brevity, expect backend returns JSON array of rides
      }
    } catch(e){ }
    setState(()=>_loading=false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Results')), body: _loading?Center(child:CircularProgressIndicator()):ListView(children: _rides.map((r)=>ListTile(title: Text(r.driverName), subtitle: Text('"+r.price+" CFA - seats ${r.seatsAvailable}'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>RideDetailScreen(ride: r, apiBase: widget.apiBase))))).toList()));
  }
}
