import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/role.dart';

part 'employee_draft.freezed.dart';

/// What the form collects to create a new employee, mirroring
/// EmployeeCreateDto — including the one-time password that opens their login.
@freezed
abstract class NewEmployee with _$NewEmployee {
  const factory NewEmployee({
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int departmentId,
    required Role role,
    String? phoneNumber,
    int? managerId,
  }) = _NewEmployee;

  const NewEmployee._();
}

/// What an edit can change, mirroring EmployeeUpdateDto.
///
/// No password and no employee code: the backend deliberately keeps password
/// changes to their own endpoint, and the code is immutable once issued.
@freezed
abstract class EmployeeEdit with _$EmployeeEdit {
  const factory EmployeeEdit({
    required String firstName,
    required String lastName,
    required String email,
    required int departmentId,
    required Role role,
    required bool isActive,
    String? phoneNumber,
    int? managerId,
  }) = _EmployeeEdit;

  const EmployeeEdit._();
}
