import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/department.dart';
import 'department_providers.dart';

/// Submission state for the create/edit sheet, kept out of
/// [departmentsProvider] so a failed save never blanks the list behind the
/// sheet.
final departmentFormControllerProvider =
    AsyncNotifierProvider<DepartmentFormController, void>(
      DepartmentFormController.new,
    );

class DepartmentFormController extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Returns the saved department, or null when the save failed — in which
  /// case the message is in [state] for the sheet to show.
  Future<Department?> create(String name) async {
    state = const AsyncLoading();
    final result = await ref.read(departmentsProvider.notifier).create(name);
    return _settle(result);
  }

  Future<Department?> edit(int id, String name) async {
    state = const AsyncLoading();
    final result = await ref
        .read(departmentsProvider.notifier)
        .edit(id, name);
    return _settle(result);
  }

  void reset() => state = const AsyncData(null);

  Department? _settle(Either<Failure, Department> result) {
    return result.match((failure) {
      state = AsyncError(failure, StackTrace.current);
      return null;
    }, (department) {
      state = const AsyncData(null);
      return department;
    });
  }
}

/// The message to show inside the sheet, or null when there's nothing wrong.
final departmentFormErrorProvider = Provider<String?>((ref) {
  final error = ref.watch(departmentFormControllerProvider).error;
  return switch (error) {
    Failure() => error.message,
    null => null,
    _ => const UnknownFailure().message,
  };
});
