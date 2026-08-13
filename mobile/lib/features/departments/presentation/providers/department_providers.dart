import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/department_remote_data_source.dart';
import '../../data/repositories/department_repository_impl.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../../domain/usecases/get_departments.dart';

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

/// The department list, fetched on first read and cached for the session.
/// The employee form's picker watches this.
final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final result = await ref.watch(getDepartmentsUseCaseProvider)(
    const NoParams(),
  );
  // Throwing hands the Failure to AsyncValue.error, which AsyncValueView and
  // the form both already know how to render.
  return result.getOrElse((failure) => throw failure);
});
