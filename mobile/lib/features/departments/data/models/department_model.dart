import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/department.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

/// Wire shape of backend/DTOs/Departments/DepartmentResponseDto.cs.
@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required int id,
    required String name,
    required int employeeCount,
  }) = _DepartmentModel;

  const DepartmentModel._();

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Department toEntity() =>
      Department(id: id, name: name, employeeCount: employeeCount);
}
