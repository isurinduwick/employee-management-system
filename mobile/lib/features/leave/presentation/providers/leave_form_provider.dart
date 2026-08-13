import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/leave_draft.dart';
import '../../domain/entities/leave_request.dart';
import 'leave_providers.dart';

/// Submission state for the request sheet, kept out of
/// [myLeaveRequestsProvider] so a failed submit never blanks the list behind
/// the sheet.
final leaveFormControllerProvider =
    AsyncNotifierProvider<LeaveFormController, void>(LeaveFormController.new);

class LeaveFormController extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Returns the created request, or null when it failed — in which case the
  /// message is in [state] for the sheet to show.
  Future<LeaveRequest?> submit(NewLeaveRequest draft) async {
    state = const AsyncLoading();
    final result = await ref
        .read(myLeaveRequestsProvider.notifier)
        .submit(draft);

    return result.match((failure) {
      state = AsyncError(failure, StackTrace.current);
      return null;
    }, (request) {
      state = const AsyncData(null);
      return request;
    });
  }

  void reset() => state = const AsyncData(null);
}

/// The message to show inside the sheet, or null when there's nothing wrong.
final leaveFormErrorProvider = Provider<String?>((ref) {
  final error = ref.watch(leaveFormControllerProvider).error;
  return switch (error) {
    Failure() => error.message,
    null => null,
    _ => const UnknownFailure().message,
  };
});
