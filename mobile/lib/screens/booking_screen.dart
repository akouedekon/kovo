import 'package:flutter/material.dart';
import '../models/ride.dart';
import 'dart:convert';
import '../services/api.dart';
import '../services/token_storage.dart';
import '../services/payment_service.dart';
import 'payment_screen.dart';
import 'payment_success_screen.dart';

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
    final storage = TokenStorage();
    final api = ApiClient(baseUrl: widget.apiBase, storage: storage);

    try {
      // create booking (backend should return booking id)
      final res = await api.post('/api/bookings', {
        'rideId': widget.ride.id,
        'seats': 1
      }, withAuth: true);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final booking = res.body.isNotEmpty ? (await Future.value(Map<String,dynamic>.from(jsonDecode(res.body)))) : <String,dynamic>{};
        final bookingId = (booking['bookingId'] ?? booking['id'])?.toString() ?? '';

        final paymentService = PaymentService(api);
        final paymentUrl = await paymentService.createPayment(bookingId, (widget.ride.price * 100).toInt());
        setState(()=>_loading=false);
        if (paymentUrl != null) {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(url: paymentUrl)));
          if (res is Map && res['status'] == 'success'){
            final bookingId = res['bookingId']?.toString();
            final paymentId = res['paymentId']?.toString();
            // show dedicated success screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PaymentSuccessScreen(bookingId: bookingId, paymentId: paymentId)));
            return;
          }
          return;
        }
      }
    } catch (e) {
      // ignore
    }

    setState(()=>_loading=false);
    // fallback
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create booking or payment')));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Book ride')), body: Padding(padding: EdgeInsets.all(16), child: Column(children:[Text('Booking ${widget.ride.driverName} - ${widget.ride.price} CFA'), SizedBox(height:12), ElevatedButton(onPressed:_loading?null:_book, child:_loading?CircularProgressIndicator():Text('Proceed to payment'))],),));
  }
}
