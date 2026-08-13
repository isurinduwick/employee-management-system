/// State of a single day's attendance record.
/// Mirrors backend/Models/Enums.cs — AttendanceStatus.
enum AttendanceStatus {
  present('Present'),
  absent('Absent'),
  late('Late'),
  halfDay('HalfDay'),
  onLeave('OnLeave');

  const AttendanceStatus(this.label);

  final String label;

  static AttendanceStatus fromLabel(String value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.label == value,
      orElse: () => throw ArgumentError('Unknown attendance status: $value'),
    );
  }
}

/// Origin of a check-in/check-out — both the web app and this app write here.
/// Mirrors backend/Models/Enums.cs — DeviceType.
enum DeviceType {
  web('Web'),
  mobile('Mobile');

  const DeviceType(this.label);

  final String label;

  static DeviceType fromLabel(String value) {
    return DeviceType.values.firstWhere(
      (type) => type.label == value,
      orElse: () => throw ArgumentError('Unknown device type: $value'),
    );
  }
}
