import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/department_remote_data_source.dart';
import '../../data/repositories/department_repository_impl.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../../domain/usecases/create_department.dart';
import '../../domain/usecases/delete_department.dart';
import '../../domain/usecases/get_departments.dart';
import '../../domain/usecases/update_department.dart';

final departmentRemoteDataSourceProvider = Provider<DepartmentRemoteDataSource>(
  (ref) => DepartmentRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final departmentRepositoryProvider = Provider<DepartmentRepository>(
  (ref) => DepartmentRepositoryImpl(
    remote: ref.watch(departmentRemoteDataSourceProvider),
  ),
);

final getDepartmentsUseCaseProvider = Provider<GetDepartments>(
  (ref) => GetDepartments(ref.watch(departmentRepositoryProvider)),
);

final createDepartmentUseCaseProvider = Provider<CreateDepartment>(
  (ref) => CreateDepartment(ref.watch(departmentRepositoryProvider)),
);

final updateDepartmentUseCaseProvider = Provider<UpdateDepartment>(
  (ref) => UpdateDepartment(ref.watch(departmentRepositoryProvider)),
);

final deleteDepartmentUseCaseProvider = Provider<DeleteDepartment>(
  (ref) => DeleteDepartment(ref.watch(departmentRepositoryProvider)),
);

/// Writes are Admin-only at the API; hiding them for everyone else keeps the
/// UI honest instead of offering buttons that would 403.
final canManageDepartmentsProvider = Provider<bool>(
  (ref) => ref.watch(sessionProvider)?.role == Role.admin,
);

/// The department list, fetched on first read and cached for the session.
/// Both the Departments screen and the employee form's picker watch this.
///
/// Mutations return `Either<Failure, T>` to the caller *and* patch this list
/// in place on success, so the screen updates without a full refetch — the
/// same trick [EmployeesController] uses.
final departmentsProvider =
    AsyncNotifierProvider<DepartmentsController, List<Department>>(
      DepartmentsController.new,
    );

class DepartmentsController extends AsyncNotifier<List<Department>> {
  @override
  Future<List<Department>> build() => _fetch();

  Future<List<Department>> _fetch() async {
    final result = await ref.read(getDepartmentsUseCaseProvider)(
      const NoParams(),
    );
    // Throwing hands the Failure to AsyncValue.error, which AsyncValueView
    // renders with a Retry button.
    return result.getOrElse((failure) => throw failure);
  }

  /// Pull-to-refresh. Keeps the current list visible while reloading.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<Either<Failure, Department>> create(String name) async {
    final result = await ref.read(createDepartmentUseCaseProvider)(name);
    return result.map((created) {
      state = AsyncData([...state.valueOrNull ?? [], created]);
      return created;
    });
  }

  /// Named `edit` rather than `update`: [AsyncNotifier] already defines an
  /// `update` with a different contract.
  Future<Either<Failure, Department>> edit(int id, String name) async {
    final result = await ref.read(updateDepartmentUseCaseProvider)(
      UpdateDepartmentParams(id: id, name: name),
    );
    return result.map((updated) {
      state = AsyncData([
        for (final department in state.valueOrNull ?? <Department>[])
          if (department.id == id) updated else department,
      ]);
      return updated;
    });
  }

  Future<Either<Failure, Unit>> delete(int id) async {
    final result = await ref.read(deleteDepartmentUseCaseProvider)(id);
    return result.map((_) {
      state = AsyncData([
        for (final department in state.valueOrNull ?? <Department>[])
          if (department.id != id) department,
      ]);
      return unit;
    });
  }
}
