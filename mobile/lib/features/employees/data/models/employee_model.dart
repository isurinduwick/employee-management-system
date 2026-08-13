import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/models/role_converter.dart';
import '../../../auth/domain/entities/role.dart';
import '../../domain/entities/employee.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

/// Wire shape of backend/DTOs/Employees/EmployeeResponseDto.cs.
@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required int id,
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String email,
    required int departmentId,
    required String departmentName,
    @RoleConverter() required Role role,
    required bool isActive,
    required DateTime createdAt,
    String? phoneNumber,
    int? managerId,
    String? managerName,
  }) = _EmployeeModel;

  const EmployeeModel._();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Employee toEntity() => Employee(
    id: id,
    employeeCode: employeeCode,
    firstName: firstName,
    lastName: lastName,
    email: email,
    departmentId: departmentId,
    departmentName: departmentName,
    role: role,
    isActive: isActive,
    createdAt: createdAt,
    phoneNumber: phoneNumber,
    managerId: managerId,
    managerName: managerName,
  );
}
