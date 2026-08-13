// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveCreateModel _$LeaveCreateModelFromJson(
  Map<String, dynamic> json,
) => _LeaveCreateModel(
  leaveType: const LeaveTypeConverter().fromJson(json['leaveType'] as String),
  startDate: const DateOnlyConverter().fromJson(json['startDate'] as String),
  endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$LeaveCreateModelToJson(_LeaveCreateModel instance) =>
    <String, dynamic>{
      'leaveType': const LeaveTypeConverter().toJson(instance.leaveType),
      'startDate': const DateOnlyConverter().toJson(instance.startDate),
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'reason': instance.reason,
    };

_LeaveDecisionModel _$LeaveDecisionModelFromJson(Map<String, dynamic> json) =>
    _LeaveDecisionModel(
      status: const LeaveStatusConverter().fromJson(json['status'] as String),
    );

Map<String, dynamic> _$LeaveDecisionModelToJson(_LeaveDecisionModel instance) =>
    <String, dynamic>{
      'status': const LeaveStatusConverter().toJson(instance.status),
    };
