import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _store = const FlutterSecureStorage();
  static const _accessKey = 'kovo_access_token';
  static const _refreshKey = 'kovo_refresh_token';

  Future<void> saveTokens(String access, String refresh) async {
    await _store.write(key: _accessKey, value: access);
    await _store.write(key: _refreshKey, value: refresh);
  }

  Future<String?> getAccessToken() => _store.read(key: _accessKey);
  Future<String?> getRefreshToken() => _store.read(key: _refreshKey);
  Future<void> clear() async { await _store.delete(key: _accessKey); await _store.delete(key: _refreshKey); }
}
