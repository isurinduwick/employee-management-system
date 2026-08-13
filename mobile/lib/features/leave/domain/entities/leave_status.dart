/// Why a day off was requested.
/// Mirrors backend/Models/Enums.cs — LeaveType.
enum LeaveType {
  sick('Sick'),
  vacation('Vacation'),
  casual('Casual'),
  unpaid('Unpaid'),
  other('Other');

  const LeaveType(this.label);

  final String label;

  static LeaveType fromLabel(String value) {
    return LeaveType.values.firstWhere(
      (type) => type.label == value,
      orElse: () => throw ArgumentError('Unknown leave type: $value'),
    );
  }
}

/// Lifecycle state of a leave request, driven by the Manager/Admin approval
/// workflow. Mirrors backend/Models/Enums.cs — LeaveStatus.
enum LeaveStatus {
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected');

  const LeaveStatus(this.label);

  final String label;

  static LeaveStatus fromLabel(String value) {
    return LeaveStatus.values.firstWhere(
      (status) => status.label == value,
      orElse: () => throw ArgumentError('Unknown leave status: $value'),
    );
  }
}

/// The two states a request can be moved into. `Pending` is deliberately
/// absent — the API rejects it as a decision, since it isn't one.
enum LeaveDecision {
  approved(LeaveStatus.approved),
  rejected(LeaveStatus.rejected);

  const LeaveDecision(this.status);

  final LeaveStatus status;
}
