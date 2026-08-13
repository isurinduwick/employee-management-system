import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/models/role_converter.dart';
import '../../../auth/domain/entities/role.dart';
import '../../domain/entities/employee_draft.dart';

part 'employee_request_models.freezed.dart';
part 'employee_request_models.g.dart';

/// Wire shape of EmployeeCreateDto.
///
/// `includeIfNull: false` matters here: the API's `[Phone]` and manager checks
/// treat an absent field as "not provided", which is not the same as null.
@freezed
abstract class EmployeeCreateModel with _$EmployeeCreateModel {
  @JsonSerializable(includeIfNull: false)
  const factory EmployeeCreateModel({
    required String employeeCode,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int departmentId,
    @RoleConverter() required Role role,
    String? phoneNumber,
    int? managerId,
  }) = _EmployeeCreateModel;

  const EmployeeCreateModel._();

  factory EmployeeCreateModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeCreateModelFromJson(json);

  factory EmployeeCreateModel.fromEntity(NewEmployee employee) =>
      EmployeeCreateModel(
        employeeCode: employee.employeeCode,
        firstName: employee.firstName,
        lastName: employee.lastName,
        email: employee.email,
        password: employee.password,
        departmentId: employee.departmentId,
        role: employee.role,
        phoneNumber: employee.phoneNumber,
        managerId: employee.managerId,
      );
}

/// Wire shape of EmployeeUpdateDto.
@freezed
abstract class EmployeeUpdateModel with _$EmployeeUpdateModel {
  @JsonSerializable(includeIfNull: false)
  const factory EmployeeUpdateModel({
    required String firstName,
    required String lastName,
    required String email,
    required int departmentId,
    @RoleConverter() required Role role,
    required bool isActive,
    String? phoneNumber,
    int? managerId,
  }) = _EmployeeUpdateModel;

  const EmployeeUpdateModel._();

  factory EmployeeUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeUpdateModelFromJson(json);

  factory EmployeeUpdateModel.fromEntity(EmployeeEdit edit) =>
      EmployeeUpdateModel(
        firstName: edit.firstName,
        lastName: edit.lastName,
        email: edit.email,
        departmentId: edit.departmentId,
        role: edit.role,
        isActive: edit.isActive,
        phoneNumber: edit.phoneNumber,
        managerId: edit.managerId,
      );
}
