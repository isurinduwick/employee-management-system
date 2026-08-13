import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import 'auth_providers.dart';

/// Submission state for the login form, kept separate from
/// [authControllerProvider] so a failed attempt never puts the *session* into
/// an error/loading state the router would react to.
final loginFormControllerProvider =
    AsyncNotifierProvider<LoginFormController, void>(LoginFormController.new);

class LoginFormController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();

    final result = await ref
        .read(authControllerProvider.notifier)
        .signIn(email: email, password: password);

    state = result.match(
      (failure) => AsyncError(failure, StackTrace.current),
      // On success the router redirects away from this screen; the data state
      // just clears any error left over from a previous attempt.
      (_) => const AsyncData(null),
    );
  }

  /// Drops the visible error, e.g. when the user edits a field.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}

/// The message to show under the form, or null when there's nothing to say.
final loginErrorProvider = Provider<String?>((ref) {
  final error = ref.watch(loginFormControllerProvider).error;
  return switch (error) {
    Failure() => error.message,
    null => null,
    _ => const UnknownFailure().message,
  };
});
