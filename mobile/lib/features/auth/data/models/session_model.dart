import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/role.dart';
import '../../domain/entities/session.dart';
import 'role_converter.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

/// Wire shape of backend/DTOs/Auth/LoginResponseDto.cs.
///
/// It is also what gets written to secure storage, so a saved session survives
/// an app restart in exactly the form the API returned it.
@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String token,
    required DateTime expiresAt,
    required int employeeId,
    required String fullName,
    @RoleConverter() required Role role,
  }) = _SessionModel;

  const SessionModel._();

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  factory SessionModel.fromEntity(Session session) => SessionModel(
    token: session.token,
    expiresAt: session.expiresAt,
    employeeId: session.employeeId,
    fullName: session.fullName,
    role: session.role,
  );

  Session toEntity() => Session(
    token: token,
    expiresAt: expiresAt,
    employeeId: employeeId,
    fullName: fullName,
    role: role,
  );
}
