import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import 'home_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String apiBase;
  final String email;
  const OtpVerifyScreen({super.key, required this.apiBase, required this.email});
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpCtl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _verify() async {
    setState(()=>_loading=true);
    final storage = TokenStorage();
    final api = ApiClient(baseUrl: widget.apiBase, storage: storage);
    final auth = AuthService(api, storage);
    final res = await auth.verifyOtp(widget.email, _otpCtl.text.trim());
    setState(()=>_loading=false);
    if (res!=null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(apiBase: widget.apiBase)));
    } else {
      setState(()=>_error='OTP verification failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Verify OTP')), body: Padding(
      padding: EdgeInsets.all(16), child: Column(children: [Text('OTP sent to ${widget.email}'), TextField(controller: _otpCtl, decoration: InputDecoration(labelText: 'OTP')), SizedBox(height:12), if (_error!=null) Text(_error!, style: TextStyle(color:Colors.red)), ElevatedButton(onPressed:_loading?null:_verify, child: _loading?CircularProgressIndicator(color:Colors.white):Text('Verify')) ],), ), );
  }
}
