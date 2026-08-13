import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/departments/data/repositories/department_repository_impl.dart';

import '../../helpers/fake_employee_data_sources.dart';

void main() {
  final requestOptions = RequestOptions(path: '/departments');

  DioException responseWith(int status, [dynamic body]) => DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: requestOptions,
      statusCode: status,
      data: body,
    ),
  );

  test('getDepartments maps models to entities', () async {
    final remote = FakeDepartmentRemoteDataSource();
    final repository = DepartmentRepositoryImpl(remote: remote);

    final result = await repository.getDepartments();

    final departments = result.getOrElse((failure) => fail('got $failure'));
    expect(departments, hasLength(2));
    expect(departments.first.name, 'Engineering');
    expect(departments.first.employeeCount, 2);
  });

  test('createDepartment returns the created entity', () async {
    final remote = FakeDepartmentRemoteDataSource(departments: const []);
    final repository = DepartmentRepositoryImpl(remote: remote);

    // Trimming is CreateDepartment's job, not the repository's — this level
    // just forwards what it's given, so the input here is already trimmed.
    final result = await repository.createDepartment('Sales');

    final department = result.getOrElse((failure) => fail('got $failure'));
    expect(department.name, 'Sales');
    expect(remote.lastCreate?.name, 'Sales');
  });

  test('a 409 conflict on create surfaces the API message', () async {
    final remote = FakeDepartmentRemoteDataSource(
      error: responseWith(409, "Department 'Sales' already exists."),
    );
    final repository = DepartmentRepositoryImpl(remote: remote);

    final result = await repository.createDepartment('Sales');

    final failure = result.getLeft().toNullable();
    expect(failure, isA<ServerFailure>());
    expect(failure?.message, "Department 'Sales' already exists.");
  });

  test('a 403 on write becomes ForbiddenFailure', () async {
    final remote = FakeDepartmentRemoteDataSource(error: responseWith(403));
    final repository = DepartmentRepositoryImpl(remote: remote);

    final result = await repository.updateDepartment(1, 'Sales');

    expect(result.getLeft().toNullable(), isA<ForbiddenFailure>());
  });

  test('deleteDepartment removes the row', () async {
    final remote = FakeDepartmentRemoteDataSource();
    final repository = DepartmentRepositoryImpl(remote: remote);

    final result = await repository.deleteDepartment(1);

    expect(result.isRight(), isTrue);
    expect(remote.deletedId, 1);
    expect(remote.departments.any((d) => d.id == 1), isFalse);
  });

  test('a 409 conflict on delete surfaces the API message', () async {
    final remote = FakeDepartmentRemoteDataSource(
      error: responseWith(
        409,
        'Cannot delete a department that still has employees assigned to it.',
      ),
    );
    final repository = DepartmentRepositoryImpl(remote: remote);

    final result = await repository.deleteDepartment(1);

    final failure = result.getLeft().toNullable();
    expect(failure, isA<ServerFailure>());
    expect(
      failure?.message,
      'Cannot delete a department that still has employees assigned to it.',
    );
  });
}
