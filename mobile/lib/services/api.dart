import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage storage;

  ApiClient({required this.baseUrl, required this.storage});

  Future<http.Response> post(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$path');
    final h = <String, String>{'Content-Type': 'application/json'};
    if (headers != null) h.addAll(headers);
    final res = await http.post(url, headers: h, body: jsonEncode(body));
    return res;
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$path');
    final h = <String, String>{};
    if (headers != null) h.addAll(headers);
    final res = await http.get(url, headers: h);
    return res;
  }
}
