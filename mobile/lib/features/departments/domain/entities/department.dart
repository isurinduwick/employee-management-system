import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

/// A department, as the rest of the app sees it.
/// Mirrors backend/DTOs/Departments/DepartmentResponseDto.cs.
@freezed
abstract class Department with _$Department {
  const factory Department({
    required int id,
    required String name,
    required int employeeCount,
  }) = _Department;

  const Department._();
}
