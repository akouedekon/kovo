import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage storage;

  ApiClient({required this.baseUrl, required this.storage});

  Future<http.Response> post(String path, Map<String, dynamic> body, {Map<String, String>? headers, bool withAuth = false}) async {
    return _send('POST', path, body: body, headers: headers, withAuth: withAuth);
  }

  Future<http.Response> get(String path, {Map<String, String>? headers, bool withAuth = false}) async {
    return _send('GET', path, headers: headers, withAuth: withAuth);
  }

  Future<http.Response> _send(String method, String path, {Map<String, dynamic>? body, Map<String, String>? headers, bool withAuth = false, int retry = 0}) async {
    final url = Uri.parse('$baseUrl$path');
    final h = <String, String>{'Content-Type': 'application/json'};
    if (headers != null) h.addAll(headers);

    if (withAuth) {
      final access = await storage.getAccessToken();
      if (access != null) {
        h['Authorization'] = 'Bearer $access';
      }
    }

    http.Response res;
    if (method == 'POST') {
      res = await http.post(url, headers: h, body: jsonEncode(body ?? {}));
    } else {
      res = await http.get(url, headers: h);
    }

    // If unauthorized and we haven't retried yet, try to refresh
    if (res.statusCode == 401 && retry == 0 && withAuth) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _send(method, path, body: body, headers: headers, withAuth: withAuth, retry: 1);
      }
    }

    return res;
  }

  Future<bool> _tryRefresh() async {
    final refresh = await storage.getRefreshToken();
    if (refresh == null) return false;
    final url = Uri.parse('$baseUrl/api/auth/refresh');
    final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'refreshToken': refresh}));
    if (res.statusCode == 200) {
      try {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        final access = j['accessToken'] as String?;
        final newRefresh = j['refreshToken'] as String?;
        if (access != null && newRefresh != null) {
          await storage.saveTokens(access, newRefresh);
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
