import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/attendance_status.dart';

class AttendanceStatusConverter
    implements JsonConverter<AttendanceStatus, String> {
  const AttendanceStatusConverter();

  @override
  AttendanceStatus fromJson(String json) => AttendanceStatus.fromLabel(json);

  @override
  String toJson(AttendanceStatus status) => status.label;
}

class DeviceTypeConverter implements JsonConverter<DeviceType, String> {
  const DeviceTypeConverter();

  @override
  DeviceType fromJson(String json) => DeviceType.fromLabel(json);

  @override
  String toJson(DeviceType type) => type.label;
}
