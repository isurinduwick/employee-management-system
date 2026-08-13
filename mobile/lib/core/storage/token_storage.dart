import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../error/exceptions.dart';

/// Holds the raw bearer token in the platform keystore (Android Keystore /
/// iOS Keychain) — mobile's equivalent of the web client's AUTH_STORAGE_KEY.
///
/// It stores the token *only*, with no knowledge of the session model, which
/// is what lets `core/network`'s interceptor read it without reaching into the
/// auth feature.
class TokenStorage {
  const TokenStorage(this._storage);

  static const _key = 'ems_token';

  final FlutterSecureStorage _storage;

  Future<String?> read() async {
    try {
      return await _storage.read(key: _key);
    } on Exception catch (e) {
      throw CacheException('Could not read the saved token: $e');
    }
  }

  Future<void> write(String token) async {
    try {
      await _storage.write(key: _key, value: token);
    } on Exception catch (e) {
      throw CacheException('Could not save the token: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } on Exception catch (e) {
      throw CacheException('Could not clear the token: $e');
    }
  }
}
