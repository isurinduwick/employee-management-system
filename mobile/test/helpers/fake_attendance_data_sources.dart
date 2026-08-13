import 'package:mobile/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:mobile/features/attendance/data/models/attendance_record_model.dart';
import 'package:mobile/features/attendance/domain/entities/attendance_status.dart';
import 'package:mobile/features/attendance/domain/repositories/attendance_repository.dart';

/// In-memory stand-in for the /api/attendance endpoints. Set [error] to make
/// the next call throw, which is how the failure paths get exercised.
class FakeAttendanceRemoteDataSource implements AttendanceRemoteDataSource {
  FakeAttendanceRemoteDataSource({List<AttendanceRecordModel>? records, this.error})
    : records = [...?records];

  List<AttendanceRecordModel> records;
  Object? error;

  AttendanceFilters? lastFilters;
  DeviceType? lastCheckInDevice;
  int checkOutCalls = 0;

  int _nextId = 500;

  void _throwIfPrimed() {
    final pending = error;
    if (pending != null) throw pending;
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendance(
    AttendanceFilters filters,
  ) async {
    _throwIfPrimed();
    lastFilters = filters;

    return [
      for (final record in records)
        if (_matches(record, filters)) record,
    ];
  }

  bool _matches(AttendanceRecordModel record, AttendanceFilters filters) {
    if (filters.employeeId != null && record.employeeId != filters.employeeId) {
      return false;
    }
    if (filters.startDate != null && record.workDate.isBefore(filters.startDate!)) {
      return false;
    }
    if (filters.endDate != null && record.workDate.isAfter(filters.endDate!)) {
      return false;
    }
    return true;
  }

  @override
  Future<AttendanceRecordModel> checkIn(DeviceType deviceType) async {
    _throwIfPrimed();
    lastCheckInDevice = deviceType;

    final now = DateTime.now();
    final created = attendanceModelFor(
      id: _nextId++,
      workDate: DateTime(now.year, now.month, now.day),
      checkInTime: now,
      deviceType: deviceType,
    );
    records = [created, ...records];
    return created;
  }

  @override
  Future<AttendanceRecordModel> checkOut() async {
    _throwIfPrimed();
    checkOutCalls++;

    final open = records.firstWhere((r) => r.checkOutTime == null);
    final closed = open.copyWith(checkOutTime: DateTime.now());
    records = [
      for (final r in records)
        if (r.id == open.id) closed else r,
    ];
    return closed;
  }
}

AttendanceRecordModel attendanceModelFor({
  required int id,
  int employeeId = 1,
  String employeeName = 'Dana Cole',
  DateTime? workDate,
  AttendanceStatus status = AttendanceStatus.present,
  DeviceType deviceType = DeviceType.mobile,
  DateTime? checkInTime,
  DateTime? checkOutTime,
}) {
  final date = workDate ?? DateTime(2026, 3, 2);
  return AttendanceRecordModel(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    workDate: date,
    status: status,
    deviceType: deviceType,
    checkInTime: checkInTime,
    checkOutTime: checkOutTime,
  );
}

/// A record dated today, which is what the status card reads.
AttendanceRecordModel todayAttendanceModel({
  int id = 900,
  int employeeId = 1,
  DateTime? checkInTime,
  DateTime? checkOutTime,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return attendanceModelFor(
    id: id,
    employeeId: employeeId,
    workDate: today,
    checkInTime: checkInTime ?? today.add(const Duration(hours: 9)),
    checkOutTime: checkOutTime,
  );
}
