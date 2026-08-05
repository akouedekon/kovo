import 'package:flutter/material.dart';
import '../models/ride.dart';

class BookingScreen extends StatefulWidget {
  final Ride ride;
  final String apiBase;
  const BookingScreen({super.key, required this.ride, required this.apiBase});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _loading=false;
  void _book() async {
    setState(()=>_loading=true);
    // call backend to create booking; for now simulate
    await Future.delayed(Duration(seconds:1));
    setState(()=>_loading=false);
    // go to payment
    Navigator.push(context, MaterialPageRoute(builder: (_)=>Scaffold(appBar: AppBar(title: Text('Payment')), body: Center(child: Text('Payment flow placeholder for Kkiapay')))));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Book ride')), body: Padding(padding: EdgeInsets.all(16), child: Column(children:[Text('Booking ${widget.ride.driverName} - ${widget.ride.price} CFA'), SizedBox(height:12), ElevatedButton(onPressed:_loading?null:_book, child:_loading?CircularProgressIndicator():Text('Proceed to payment'))],),));
  }
}
