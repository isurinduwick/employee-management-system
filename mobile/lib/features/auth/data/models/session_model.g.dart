// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      employeeId: (json['employeeId'] as num).toInt(),
      fullName: json['fullName'] as String,
      role: const RoleConverter().fromJson(json['role'] as String),
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'employeeId': instance.employeeId,
      'fullName': instance.fullName,
      'role': const RoleConverter().toJson(instance.role),
    };
