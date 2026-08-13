// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeCreateModel _$EmployeeCreateModelFromJson(Map<String, dynamic> json) =>
    _EmployeeCreateModel(
      employeeCode: json['employeeCode'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
      role: const RoleConverter().fromJson(json['role'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      managerId: (json['managerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeCreateModelToJson(
  _EmployeeCreateModel instance,
) => <String, dynamic>{
  'employeeCode': instance.employeeCode,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'departmentId': instance.departmentId,
  'role': const RoleConverter().toJson(instance.role),
  'phoneNumber': ?instance.phoneNumber,
  'managerId': ?instance.managerId,
};

_EmployeeUpdateModel _$EmployeeUpdateModelFromJson(Map<String, dynamic> json) =>
    _EmployeeUpdateModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
      role: const RoleConverter().fromJson(json['role'] as String),
      isActive: json['isActive'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      managerId: (json['managerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeUpdateModelToJson(
  _EmployeeUpdateModel instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'departmentId': instance.departmentId,
  'role': const RoleConverter().toJson(instance.role),
  'isActive': instance.isActive,
  'phoneNumber': ?instance.phoneNumber,
  'managerId': ?instance.managerId,
};
