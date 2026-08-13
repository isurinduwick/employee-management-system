// Mirrors the backend's DTOs exactly (backend/DTOs/Auth/*.cs).

enum Role { admin, manager, employee }

Role roleFromString(String value) {
  switch (value) {
    case 'Admin':
      return Role.admin;
    case 'Manager':
      return Role.manager;
    case 'Employee':
      return Role.employee;
    default:
      throw ArgumentError('Unknown role: $value');
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.admin:
      return 'Admin';
    case Role.manager:
      return 'Manager';
    case Role.employee:
      return 'Employee';
  }
}

class LoginResponse {
  final String token;
  final DateTime expiresAt;
  final int employeeId;
  final String fullName;
  final Role role;

  LoginResponse({
    required this.token,
    required this.expiresAt,
    required this.employeeId,
    required this.fullName,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      employeeId: json['employeeId'] as int,
      fullName: json['fullName'] as String,
      role: roleFromString(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'expiresAt': expiresAt.toIso8601String(),
        'employeeId': employeeId,
        'fullName': fullName,
        'role': roleToString(role),
      };
}
