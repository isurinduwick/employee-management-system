// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRecordModel(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  employeeName: json['employeeName'] as String,
  workDate: const DateOnlyConverter().fromJson(json['workDate'] as String),
  status: const AttendanceStatusConverter().fromJson(json['status'] as String),
  deviceType: const DeviceTypeConverter().fromJson(
    json['deviceType'] as String,
  ),
  checkInTime: json['checkInTime'] == null
      ? null
      : DateTime.parse(json['checkInTime'] as String),
  checkOutTime: json['checkOutTime'] == null
      ? null
      : DateTime.parse(json['checkOutTime'] as String),
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  _AttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'workDate': const DateOnlyConverter().toJson(instance.workDate),
  'status': const AttendanceStatusConverter().toJson(instance.status),
  'deviceType': const DeviceTypeConverter().toJson(instance.deviceType),
  'checkInTime': instance.checkInTime?.toIso8601String(),
  'checkOutTime': instance.checkOutTime?.toIso8601String(),
};
