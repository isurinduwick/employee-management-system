import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/data/datasources/department_remote_data_source.dart';
import 'package:mobile/features/departments/data/models/department_model.dart';
import 'package:mobile/features/departments/data/models/department_request_model.dart';
import 'package:mobile/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:mobile/features/employees/data/models/employee_model.dart';
import 'package:mobile/features/employees/data/models/employee_request_models.dart';

/// In-memory stand-in for the /api/employees endpoints. Set [error] to make
/// the next call throw, which is how the failure paths get exercised.
class FakeEmployeeRemoteDataSource implements EmployeeRemoteDataSource {
  FakeEmployeeRemoteDataSource({List<EmployeeModel>? employees, this.error})
    : employees = [...?employees];

  List<EmployeeModel> employees;
  Object? error;

  int? lastDepartmentIdQuery;
  EmployeeCreateModel? lastCreate;
  EmployeeUpdateModel? lastUpdate;
  int? deactivatedId;

  int _nextId = 100;

  void _throwIfPrimed() {
    final pending = error;
    if (pending != null) throw pending;
  }

  @override
  Future<List<EmployeeModel>> getEmployees({int? departmentId}) async {
    _throwIfPrimed();
    lastDepartmentIdQuery = departmentId;
    return departmentId == null
        ? employees
        : [for (final e in employees) if (e.departmentId == departmentId) e];
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeCreateModel body) async {
    _throwIfPrimed();
    lastCreate = body;

    final created = employeeModelFor(
      id: _nextId++,
      employeeCode: body.employeeCode,
      firstName: body.firstName,
      lastName: body.lastName,
      email: body.email,
      departmentId: body.departmentId,
      role: body.role,
      phoneNumber: body.phoneNumber,
      managerId: body.managerId,
    );
    employees = [...employees, created];
    return created;
  }

  @override
  Future<EmployeeModel> updateEmployee(int id, EmployeeUpdateModel body) async {
    _throwIfPrimed();
    lastUpdate = body;

    final existing = employees.firstWhere((e) => e.id == id);
    final updated = existing.copyWith(
      firstName: body.firstName,
      lastName: body.lastName,
      email: body.email,
      departmentId: body.departmentId,
      role: body.role,
      isActive: body.isActive,
      phoneNumber: body.phoneNumber,
      managerId: body.managerId,
    );
    employees = [
      for (final e in employees)
        if (e.id == id) updated else e,
    ];
    return updated;
  }

  @override
  Future<void> deactivateEmployee(int id) async {
    _throwIfPrimed();
    deactivatedId = id;
    employees = [
      for (final e in employees)
        if (e.id == id) e.copyWith(isActive: false) else e,
    ];
  }
}

/// In-memory stand-in for the /api/departments endpoints. Set [error] to make
/// the next call throw, which is how the failure paths get exercised.
class FakeDepartmentRemoteDataSource implements DepartmentRemoteDataSource {
  FakeDepartmentRemoteDataSource({List<DepartmentModel>? departments, this.error})
    : departments =
          departments ??
          [
            const DepartmentModel(id: 1, name: 'Engineering', employeeCount: 2),
            const DepartmentModel(id: 2, name: 'People Ops', employeeCount: 1),
          ];

  List<DepartmentModel> departments;
  Object? error;

  DepartmentRequestModel? lastCreate;
  DepartmentRequestModel? lastUpdate;
  int? deletedId;

  int _nextId = 100;

  void _throwIfPrimed() {
    final pending = error;
    if (pending != null) throw pending;
  }

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    _throwIfPrimed();
    return departments;
  }

  @override
  Future<DepartmentModel> createDepartment(DepartmentRequestModel body) async {
    _throwIfPrimed();
    lastCreate = body;

    final created = DepartmentModel(
      id: _nextId++,
      name: body.name,
      employeeCount: 0,
    );
    departments = [...departments, created];
    return created;
  }

  @override
  Future<DepartmentModel> updateDepartment(
    int id,
    DepartmentRequestModel body,
  ) async {
    _throwIfPrimed();
    lastUpdate = body;

    final existing = departments.firstWhere((d) => d.id == id);
    final updated = existing.copyWith(name: body.name);
    departments = [
      for (final d in departments)
        if (d.id == id) updated else d,
    ];
    return updated;
  }

  @override
  Future<void> deleteDepartment(int id) async {
    _throwIfPrimed();
    deletedId = id;
    departments = [
      for (final d in departments)
        if (d.id != id) d,
    ];
  }
}

EmployeeModel employeeModelFor({
  required int id,
  String? employeeCode,
  String firstName = 'Dana',
  String lastName = 'Cole',
  String? email,
  int departmentId = 1,
  String departmentName = 'Engineering',
  Role role = Role.employee,
  bool isActive = true,
  String? phoneNumber,
  int? managerId,
  String? managerName,
}) {
  return EmployeeModel(
    id: id,
    employeeCode: employeeCode ?? 'EMP-${id.toString().padLeft(4, '0')}',
    firstName: firstName,
    lastName: lastName,
    email: email ?? '${firstName.toLowerCase()}@company.com',
    departmentId: departmentId,
    departmentName: departmentName,
    role: role,
    isActive: isActive,
    createdAt: DateTime(2026, 1, 15),
    phoneNumber: phoneNumber,
    managerId: managerId,
    managerName: managerName,
  );
}
