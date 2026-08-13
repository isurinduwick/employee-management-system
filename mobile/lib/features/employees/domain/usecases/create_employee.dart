import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee.dart';
import '../entities/employee_draft.dart';
import '../repositories/employee_repository.dart';

/// Admin-only at the API. Trims the free-text fields so a stray space can't
/// create a duplicate-looking employee code or email.
class CreateEmployee implements UseCase<Employee, NewEmployee> {
  const CreateEmployee(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, Employee>> call(NewEmployee params) {
    final phone = params.phoneNumber?.trim();
    return _repository.createEmployee(
      params.copyWith(
        employeeCode: params.employeeCode.trim(),
        firstName: params.firstName.trim(),
        lastName: params.lastName.trim(),
        email: params.email.trim(),
        // The API treats an absent phone number as "none"; an empty string
        // would fail its [Phone] validation.
        phoneNumber: (phone == null || phone.isEmpty) ? null : phone,
      ),
    );
  }
}
