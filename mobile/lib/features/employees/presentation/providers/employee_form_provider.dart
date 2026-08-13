import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/employee_draft.dart';
import 'employees_providers.dart';

/// Submission state for the create/edit sheet, kept out of
/// [employeesControllerProvider] so a failed save never blanks the list
/// behind the sheet.
final employeeFormControllerProvider =
    AsyncNotifierProvider<EmployeeFormController, void>(
      EmployeeFormController.new,
    );

class EmployeeFormController extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Returns the saved employee, or null when the save failed — in which case
  /// the message is in [state] for the sheet to show.
  Future<Employee?> create(NewEmployee employee) async {
    state = const AsyncLoading();
    final result = await ref
        .read(employeesControllerProvider.notifier)
        .create(employee);
    return _settle(result);
  }

  Future<Employee?> edit(int id, EmployeeEdit changes) async {
    state = const AsyncLoading();
    final result = await ref
        .read(employeesControllerProvider.notifier)
        .edit(id, changes);
    return _settle(result);
  }

  void reset() => state = const AsyncData(null);

  Employee? _settle(Either<Failure, Employee> result) {
    return result.match((failure) {
      state = AsyncError(failure, StackTrace.current);
      return null;
    }, (employee) {
      state = const AsyncData(null);
      return employee;
    });
  }
}

/// The message to show inside the sheet, or null when there's nothing wrong.
final employeeFormErrorProvider = Provider<String?>((ref) {
  final error = ref.watch(employeeFormControllerProvider).error;
  return switch (error) {
    Failure() => error.message,
    null => null,
    _ => const UnknownFailure().message,
  };
});
