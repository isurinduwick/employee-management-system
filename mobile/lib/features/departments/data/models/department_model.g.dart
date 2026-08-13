// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    _DepartmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      employeeCount: (json['employeeCount'] as num).toInt(),
    );

Map<String, dynamic> _$DepartmentModelToJson(_DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'employeeCount': instance.employeeCount,
    };
