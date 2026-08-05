import 'package:flutter/material.dart';
import '../models/ride.dart';
import 'booking_screen.dart';

class RideDetailScreen extends StatelessWidget {
  final Ride ride;
  final String apiBase;
  const RideDetailScreen({super.key, required this.ride, this.apiBase=''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Ride detail')), body: Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Driver: ${ride.driverName}'), SizedBox(height:8), Text('Price: ${ride.price} CFA'), SizedBox(height:8), ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingScreen(ride: ride, apiBase: apiBase))), child: Text('Book'))])));
  }
}
