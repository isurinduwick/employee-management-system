import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/date_only_converter.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_status.dart';
import 'attendance_enum_converters.dart';

part 'attendance_record_model.freezed.dart';
part 'attendance_record_model.g.dart';

/// Wire shape of backend/DTOs/Attendance/AttendanceResponseDto.cs.
@freezed
abstract class AttendanceRecordModel with _$AttendanceRecordModel {
  const factory AttendanceRecordModel({
    required int id,
    required int employeeId,
    required String employeeName,
    @DateOnlyConverter() required DateTime workDate,
    @AttendanceStatusConverter() required AttendanceStatus status,
    @DeviceTypeConverter() required DeviceType deviceType,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) = _AttendanceRecordModel;

  const AttendanceRecordModel._();

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  AttendanceRecord toEntity() => AttendanceRecord(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    workDate: workDate,
    status: status,
    deviceType: deviceType,
    checkInTime: checkInTime,
    checkOutTime: checkOutTime,
  );
}
