import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee.dart';
import '../entities/employee_draft.dart';
import '../repositories/employee_repository.dart';

class UpdateEmployeeParams {
  const UpdateEmployeeParams({required this.id, required this.edit});

  final int id;
  final EmployeeEdit edit;
}

/// Admin-only at the API. Same trimming rules as [CreateEmployee].
class UpdateEmployee implements UseCase<Employee, UpdateEmployeeParams> {
  const UpdateEmployee(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, Employee>> call(UpdateEmployeeParams params) {
    final edit = params.edit;
    final phone = edit.phoneNumber?.trim();

    return _repository.updateEmployee(
      params.id,
      edit.copyWith(
        firstName: edit.firstName.trim(),
        lastName: edit.lastName.trim(),
        email: edit.email.trim(),
        phoneNumber: (phone == null || phone.isEmpty) ? null : phone,
      ),
    );
  }
}
