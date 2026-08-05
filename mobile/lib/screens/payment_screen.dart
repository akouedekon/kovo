import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  const PaymentScreen({super.key, required this.url});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: (req) {
        final url = req.url;
        if (url.contains('/payments/success')) {
                try {
                  final u = Uri.parse(url);
                  final bookingId = u.queryParameters['bookingId'];
                  final paymentId = u.queryParameters['paymentId'];
                  Navigator.pop(context, {'status': 'success', 'bookingId': bookingId, 'paymentId': paymentId});
                } catch (_) {
                  Navigator.pop(context, {'status': 'success'});
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            }))
            ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Payment')), body: WebViewWidget(controller: _controller));
  }
}
