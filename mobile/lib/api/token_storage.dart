import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth.dart';

// Secure-storage equivalent of the frontend's AUTH_STORAGE_KEY in
// client.ts — mobile has no localStorage, so the token/session live in the
// platform keystore (Android Keystore / iOS Keychain) instead.
class TokenStorage {
  static const _key = 'ems_auth';
  final _storage = const FlutterSecureStorage();

  Future<void> save(LoginResponse session) async {
    await _storage.write(key: _key, value: jsonEncode(session.toJson()));
  }

  Future<LoginResponse?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      return LoginResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Malformed/stale entry — treat it the same as no session.
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
