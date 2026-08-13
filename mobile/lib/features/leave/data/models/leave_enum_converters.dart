import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/leave_status.dart';

class LeaveTypeConverter implements JsonConverter<LeaveType, String> {
  const LeaveTypeConverter();

  @override
  LeaveType fromJson(String json) => LeaveType.fromLabel(json);

  @override
  String toJson(LeaveType type) => type.label;
}

class LeaveStatusConverter implements JsonConverter<LeaveStatus, String> {
  const LeaveStatusConverter();

  @override
  LeaveStatus fromJson(String json) => LeaveStatus.fromLabel(json);

  @override
  String toJson(LeaveStatus status) => status.label;
}
