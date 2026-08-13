/// Who the signed-in user is, mirroring the backend's role claim
/// (backend/Models/Employee.cs) and the web client's Role union.
enum Role {
  admin('Admin'),
  manager('Manager'),
  employee('Employee');

  const Role(this.label);

  /// Wire value used by the API and shown in the UI.
  final String label;

  /// Throws [ArgumentError] on an unknown role — a token that carries one is
  /// not something the app should silently downgrade.
  static Role fromLabel(String value) {
    return Role.values.firstWhere(
      (role) => role.label == value,
      orElse: () => throw ArgumentError('Unknown role: $value'),
    );
  }
}
