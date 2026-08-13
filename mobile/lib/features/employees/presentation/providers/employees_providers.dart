import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/employee_remote_data_source.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/employee_draft.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/usecases/create_employee.dart';
import '../../domain/usecases/deactivate_employee.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/update_employee.dart';

/// Wiring for the employees feature, same chain as `features/auth/`:
/// data source -> repository -> use cases -> controller.

final employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>(
  (ref) => EmployeeRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) =>
      EmployeeRepositoryImpl(remote: ref.watch(employeeRemoteDataSourceProvider)),
);

final getEmployeesUseCaseProvider = Provider<GetEmployees>(
  (ref) => GetEmployees(ref.watch(employeeRepositoryProvider)),
);

final createEmployeeUseCaseProvider = Provider<CreateEmployee>(
  (ref) => CreateEmployee(ref.watch(employeeRepositoryProvider)),
);

final updateEmployeeUseCaseProvider = Provider<UpdateEmployee>(
  (ref) => UpdateEmployee(ref.watch(employeeRepositoryProvider)),
);

final deactivateEmployeeUseCaseProvider = Provider<DeactivateEmployee>(
  (ref) => DeactivateEmployee(ref.watch(employeeRepositoryProvider)),
);

/// Writes are Admin-only at the API; hiding them for everyone else keeps the
/// UI honest instead of offering buttons that would 403.
final canManageEmployeesProvider = Provider<bool>(
  (ref) => ref.watch(sessionProvider)?.role == Role.admin,
);

/// The employee directory.
///
/// Mutations return `Either<Failure, T>` to the caller *and* patch this list
/// in place on success, so the screen updates without a full refetch — the
/// same trick the web page uses with `setEmployees`.
final employeesControllerProvider =
    AsyncNotifierProvider<EmployeesController, List<Employee>>(
      EmployeesController.new,
    );

class EmployeesController extends AsyncNotifier<List<Employee>> {
  @override
  Future<List<Employee>> build() => _fetch();

  Future<List<Employee>> _fetch() async {
    final result = await ref.read(getEmployeesUseCaseProvider)(
      const GetEmployeesParams(),
    );
    // Throwing hands the Failure to AsyncValue.error, which AsyncValueView
    // renders with a Retry button.
    return result.getOrElse((failure) => throw failure);
  }

  /// Pull-to-refresh. Keeps the current list visible while reloading.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<Either<Failure, Employee>> create(NewEmployee employee) async {
    final result = await ref.read(createEmployeeUseCaseProvider)(employee);
    return result.map((created) {
      state = AsyncData([...state.valueOrNull ?? [], created]);
      return created;
    });
  }

  /// Named `edit` rather than `update`: [AsyncNotifier] already defines an
  /// `update` with a different contract.
  Future<Either<Failure, Employee>> edit(int id, EmployeeEdit changes) async {
    final result = await ref.read(updateEmployeeUseCaseProvider)(
      UpdateEmployeeParams(id: id, edit: changes),
    );
    return result.map((updated) {
      state = AsyncData([
        for (final employee in state.valueOrNull ?? <Employee>[])
          if (employee.id == id) updated else employee,
      ]);
      return updated;
    });
  }

  Future<Either<Failure, Unit>> deactivate(int id) async {
    final result = await ref.read(deactivateEmployeeUseCaseProvider)(id);
    return result.map((_) {
      // The API returns 204 with no body, so the row is patched locally
      // rather than replaced with a response.
      state = AsyncData([
        for (final employee in state.valueOrNull ?? <Employee>[])
          if (employee.id == id)
            employee.copyWith(isActive: false)
          else
            employee,
      ]);
      return unit;
    });
  }
}
