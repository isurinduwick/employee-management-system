import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/data/datasources/department_remote_data_source.dart';
import 'package:mobile/features/departments/data/models/department_model.dart';
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

class FakeDepartmentRemoteDataSource implements DepartmentRemoteDataSource {
  FakeDepartmentRemoteDataSource({List<DepartmentModel>? departments})
    : departments =
          departments ??
          const [
            DepartmentModel(id: 1, name: 'Engineering', employeeCount: 2),
            DepartmentModel(id: 2, name: 'People Ops', employeeCount: 1),
          ];

  final List<DepartmentModel> departments;

  @override
  Future<List<DepartmentModel>> getDepartments() async => departments;
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
