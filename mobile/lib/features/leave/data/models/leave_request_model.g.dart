// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveRequestModel _$LeaveRequestModelFromJson(
  Map<String, dynamic> json,
) => _LeaveRequestModel(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  employeeName: json['employeeName'] as String,
  leaveType: const LeaveTypeConverter().fromJson(json['leaveType'] as String),
  startDate: const DateOnlyConverter().fromJson(json['startDate'] as String),
  endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
  status: const LeaveStatusConverter().fromJson(json['status'] as String),
  appliedOn: DateTime.parse(json['appliedOn'] as String),
  reason: json['reason'] as String?,
  approvedById: (json['approvedById'] as num?)?.toInt(),
  approvedByName: json['approvedByName'] as String?,
);

Map<String, dynamic> _$LeaveRequestModelToJson(_LeaveRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'leaveType': const LeaveTypeConverter().toJson(instance.leaveType),
      'startDate': const DateOnlyConverter().toJson(instance.startDate),
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'status': const LeaveStatusConverter().toJson(instance.status),
      'appliedOn': instance.appliedOn.toIso8601String(),
      'reason': instance.reason,
      'approvedById': instance.approvedById,
      'approvedByName': instance.approvedByName,
    };
