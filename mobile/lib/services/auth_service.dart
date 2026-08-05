import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import 'api.dart';

class AuthService {
  final ApiClient api;
  final TokenStorage storage;
  AuthService(this.api, this.storage);

  Future<bool> requestOtp(String email) async {
    final res = await api.post('/api/auth/request-otp', {'email': email});
    return res.statusCode == 200 || res.statusCode == 204;
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    final res = await api.post('/api/auth/verify-otp', {'email': email, 'code': otp});
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      if (j['accessToken'] != null && j['refreshToken'] != null) {
        await storage.saveTokens(j['accessToken'], j['refreshToken']);
      }
      return j;
    }
    return null;
  }

  Future<void> logout() async { await storage.clear(); }
}
