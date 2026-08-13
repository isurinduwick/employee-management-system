import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class GetEmployeesParams {
  const GetEmployeesParams({this.departmentId});

  /// Null lists everyone; a value scopes the list to one department.
  final int? departmentId;
}

class GetEmployees implements UseCase<List<Employee>, GetEmployeesParams> {
  const GetEmployees(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, List<Employee>>> call(GetEmployeesParams params) =>
      _repository.getEmployees(departmentId: params.departmentId);
}
