import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/attendance_record.dart';
import '../entities/attendance_status.dart';

class AttendanceFilters {
  const AttendanceFilters({
    this.employeeId,
    this.departmentId,
    this.startDate,
    this.endDate,
  });

  /// Ignored by the API for the Employee role — reads are always scoped to
  /// the caller there regardless of what is passed.
  final int? employeeId;
  final int? departmentId;
  final DateTime? startDate;
  final DateTime? endDate;
}

abstract interface class AttendanceRepository {
  Future<Either<Failure, List<AttendanceRecord>>> getAttendance(
    AttendanceFilters filters,
  );

  /// Rejected with a [ServerFailure] (409) if the caller already checked in
  /// today.
  Future<Either<Failure, AttendanceRecord>> checkIn(DeviceType deviceType);

  /// Rejected if the caller hasn't checked in today, or already checked out.
  Future<Either<Failure, AttendanceRecord>> checkOut();
}
