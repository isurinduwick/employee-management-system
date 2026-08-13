import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/auth_api.dart';
import '../api/token_storage.dart';
import '../models/auth.dart';

// Mirrors AuthContext.tsx: holds the current session, restores it from
// storage on startup, and exposes login/logout to the rest of the app.
class AuthState extends ChangeNotifier {
  final TokenStorage _tokenStorage;
  final AuthApi _authApi;

  LoginResponse? _session;
  bool _isLoading = true;

  AuthState({TokenStorage? tokenStorage, ApiClient? apiClient})
      : _tokenStorage = tokenStorage ?? TokenStorage(),
        _authApi = AuthApi(apiClient ?? ApiClient(tokenStorage ?? TokenStorage())) {
    _restore();
  }

  LoginResponse? get session => _session;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _session != null;

  Future<void> _restore() async {
    _session = await _tokenStorage.read();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final session = await _authApi.login(email, password);
    await _tokenStorage.save(session);
    _session = session;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _session = null;
    notifyListeners();
  }
}
