import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api.dart';
import '../services/token_storage.dart';
import 'otp_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  final String apiBase;
  const LoginScreen({super.key, required this.apiBase});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _requestOtp() async {
    setState((){_loading=true;_error=null;});
    final api = ApiClient(baseUrl: widget.apiBase, storage: TokenStorage());
    final auth = AuthService(api, TokenStorage());
    final ok = await auth.requestOtp(_emailCtl.text.trim());
    setState(()=>_loading=false);
    if (ok) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpVerifyScreen(apiBase: widget.apiBase, email: _emailCtl.text.trim())));
    } else {
      setState(()=>_error='Failed to request OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kovo - Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _emailCtl, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height:12),
          if (_error!=null) Text(_error!, style: TextStyle(color:Colors.red)),
          ElevatedButton(onPressed: _loading?null:_requestOtp, child: _loading?CircularProgressIndicator(color:Colors.white):Text('Request OTP'))
        ],),
      ),
    );
  }
}
