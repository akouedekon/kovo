import 'dart:convert';
import 'api.dart';

class PaymentService {
  final ApiClient api;
  PaymentService(this.api);

  Future<String?> createPayment(String bookingId, int amountCfa) async {
    final res = await api.post('/api/payments/create', {'bookingId': bookingId, 'amount': amountCfa}, withAuth: true);
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return j['paymentUrl'] as String?;
    }
    return null;
  }
}
