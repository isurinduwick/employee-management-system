import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/session_model.dart';

/// The session as it lives on the device.
abstract interface class AuthLocalDataSource {
  Future<SessionModel?> readSession();
  Future<void> writeSession(SessionModel session);
  Future<void> clearSession();
}

/// Keeps the full session under its own key and mirrors the bearer token into
/// [TokenStorage], which is the only part `core/network` needs to see.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._storage, this._tokenStorage);

  static const _sessionKey = 'ems_auth';

  final FlutterSecureStorage _storage;
  final TokenStorage _tokenStorage;

  @override
  Future<SessionModel?> readSession() async {
    final String? raw;
    try {
      raw = await _storage.read(key: _sessionKey);
    } on Exception catch (e) {
      throw CacheException('Could not read the saved session: $e');
    }
    if (raw == null) return null;

    try {
      return SessionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Exception {
      // A malformed or stale entry is treated the same as no session rather
      // than trapping the user on a screen that can never load.
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> writeSession(SessionModel session) async {
    try {
      await _storage.write(
        key: _sessionKey,
        value: jsonEncode(session.toJson()),
      );
    } on Exception catch (e) {
      throw CacheException('Could not save the session: $e');
    }
    await _tokenStorage.write(session.token);
  }

  @override
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _sessionKey);
    } on Exception catch (e) {
      throw CacheException('Could not clear the session: $e');
    }
    await _tokenStorage.clear();
  }
}
