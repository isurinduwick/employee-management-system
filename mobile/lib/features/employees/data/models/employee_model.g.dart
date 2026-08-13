// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    _EmployeeModel(
      id: (json['id'] as num).toInt(),
      employeeCode: json['employeeCode'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
      departmentName: json['departmentName'] as String,
      role: const RoleConverter().fromJson(json['role'] as String),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      managerId: (json['managerId'] as num?)?.toInt(),
      managerName: json['managerName'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeCode': instance.employeeCode,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'role': const RoleConverter().toJson(instance.role),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'managerId': instance.managerId,
      'managerName': instance.managerName,
    };
