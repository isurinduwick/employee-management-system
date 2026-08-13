import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/role.dart';

part 'employee.freezed.dart';

/// Someone on the payroll. Mirrors
/// backend/DTOs/Employees/EmployeeResponseDto.cs — notably never a password.
@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    required int id,
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String email,
    required int departmentId,
    required String departmentName,
    required Role role,
    required bool isActive,
    required DateTime createdAt,
    String? phoneNumber,
    int? managerId,
    String? managerName,
  }) = _Employee;

  const Employee._();

  String get fullName => '$firstName $lastName';
}
