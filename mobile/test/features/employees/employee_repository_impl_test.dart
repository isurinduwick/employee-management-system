import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:mobile/features/employees/domain/entities/employee_draft.dart';

import '../../helpers/fake_employee_data_sources.dart';

void main() {
  final requestOptions = RequestOptions(path: '/employees');

  DioException responseWith(int status, [dynamic body]) => DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: requestOptions,
      statusCode: status,
      data: body,
    ),
  );

  test('getEmployees maps models to entities', () async {
    final remote = FakeEmployeeRemoteDataSource(
      employees: [
        employeeModelFor(id: 1, firstName: 'Ada', lastName: 'Byron'),
        employeeModelFor(id: 2, role: Role.manager),
      ],
    );
    final repository = EmployeeRepositoryImpl(remote: remote);

    final result = await repository.getEmployees();

    final employees = result.getOrElse((failure) => fail('got $failure'));
    expect(employees, hasLength(2));
    expect(employees.first.fullName, 'Ada Byron');
    expect(employees.last.role, Role.manager);
  });

  test('a 403 on write becomes ForbiddenFailure', () async {
    final remote = FakeEmployeeRemoteDataSource(error: responseWith(403));
    final repository = EmployeeRepositoryImpl(remote: remote);

    final result = await repository.createEmployee(
      const NewEmployee(
        employeeCode: 'EMP-0009',
        firstName: 'Sam',
        lastName: 'Reed',
        email: 'sam@company.com',
        password: 'password1',
        departmentId: 1,
        role: Role.employee,
      ),
    );

    expect(result.getLeft().toNullable(), isA<ForbiddenFailure>());
  });

  test('a 409 conflict surfaces the API message', () async {
    final remote = FakeEmployeeRemoteDataSource(
      error: responseWith(409, "Email 'sam@company.com' is already in use."),
    );
    final repository = EmployeeRepositoryImpl(remote: remote);

    final result = await repository.createEmployee(
      const NewEmployee(
        employeeCode: 'EMP-0009',
        firstName: 'Sam',
        lastName: 'Reed',
        email: 'sam@company.com',
        password: 'password1',
        departmentId: 1,
        role: Role.employee,
      ),
    );

    final failure = result.getLeft().toNullable();
    expect(failure, isA<ServerFailure>());
    expect(failure?.message, "Email 'sam@company.com' is already in use.");
  });

  test('a 400 with ProblemDetails errors becomes ValidationFailure', () async {
    final remote = FakeEmployeeRemoteDataSource(
      error: responseWith(400, {
        'title': 'One or more validation errors occurred.',
        'errors': {
          'Email': ['The Email field is not a valid e-mail address.'],
        },
      }),
    );
    final repository = EmployeeRepositoryImpl(remote: remote);

    final result = await repository.updateEmployee(
      1,
      const EmployeeEdit(
        firstName: 'Sam',
        lastName: 'Reed',
        email: 'nope',
        departmentId: 1,
        role: Role.employee,
        isActive: true,
      ),
    );

    final failure = result.getLeft().toNullable();
    expect(failure, isA<ValidationFailure>());
    expect(
      (failure! as ValidationFailure).fieldErrors['Email'],
      contains('The Email field is not a valid e-mail address.'),
    );
  });

  test('deactivate flips isActive without removing the row', () async {
    final remote = FakeEmployeeRemoteDataSource(
      employees: [employeeModelFor(id: 7)],
    );
    final repository = EmployeeRepositoryImpl(remote: remote);

    final result = await repository.deactivateEmployee(7);

    expect(result.isRight(), isTrue);
    expect(remote.deactivatedId, 7);
    expect(remote.employees.single.isActive, isFalse);
  });
}
