import 'package:flutter/foundation.dart';

/// Where the backend lives, per platform.
///
/// A physical device can't see the host's localhost, so pass the machine's LAN
/// IP at build time:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5133/api`
class ApiHost {
  const ApiHost._();

  static const _override = String.fromEnvironment('API_BASE_URL');

  /// 10.0.2.2 is the Android emulator's alias for the host machine.
  static const _androidEmulator = 'http://10.0.2.2:5133/api';
  static const _localhost = 'http://localhost:5133/api';

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (kIsWeb) return _localhost;
    return defaultTargetPlatform == TargetPlatform.android
        ? _androidEmulator
        : _localhost;
  }
}
