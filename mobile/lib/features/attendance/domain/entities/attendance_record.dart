import 'package:freezed_annotation/freezed_annotation.dart';

import 'attendance_status.dart';

part 'attendance_record.freezed.dart';

/// One employee's attendance for one calendar day. Mirrors
/// backend/DTOs/Attendance/AttendanceResponseDto.cs.
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required int id,
    required int employeeId,
    required String employeeName,
    required DateTime workDate,
    required AttendanceStatus status,
    required DeviceType deviceType,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) = _AttendanceRecord;

  const AttendanceRecord._();

  bool get hasCheckedIn => checkInTime != null;
  bool get hasCheckedOut => checkOutTime != null;
}
