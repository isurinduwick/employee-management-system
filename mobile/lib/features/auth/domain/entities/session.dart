import 'package:freezed_annotation/freezed_annotation.dart';

import 'role.dart';

part 'session.freezed.dart';

/// The signed-in user, as the rest of the app sees them.
///
/// Pure domain: no JSON, no annotations tying it to the API's field names —
/// that lives in `data/models/session_model.dart`.
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String token,
    required DateTime expiresAt,
    required int employeeId,
    required String fullName,
    required Role role,
  }) = _Session;

  const Session._();

  /// The API rejects an expired token, so the app treats it as signed out
  /// before making the call.
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
