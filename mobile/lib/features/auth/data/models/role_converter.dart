import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/role.dart';

/// Maps the API's role string ("Admin") to the domain [Role] enum, keeping the
/// wire format out of the domain layer.
class RoleConverter implements JsonConverter<Role, String> {
  const RoleConverter();

  @override
  Role fromJson(String json) => Role.fromLabel(json);

  @override
  String toJson(Role role) => role.label;
}
