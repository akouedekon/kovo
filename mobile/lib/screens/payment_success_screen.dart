import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? bookingId;
  final String? paymentId;
  const PaymentSuccessScreen({super.key, this.bookingId, this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment successful')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 96),
            const SizedBox(height: 16),
            const Text('Payment completed', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Merci — votre réservation a été confirmée.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (bookingId != null) Text('Réservation: $bookingId', textAlign: TextAlign.center),
            if (paymentId != null) Text('Paiement: $paymentId', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: (){
              // go to home (pop until root)
              Navigator.of(context).popUntil((route) => route.isFirst);
            }, child: const Text('Retour à l\'accueil')),
          ],
        ),
      ),
    );
  }
}
