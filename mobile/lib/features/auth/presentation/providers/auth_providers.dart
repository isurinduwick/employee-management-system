import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/restore_session.dart';

/// Wiring for the auth feature: data sources -> repository -> use cases ->
/// controller. Tests override the two data sources and get the real domain
/// logic for free.

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDataSourceImpl(
    ref.watch(secureStorageProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: ref.watch(authLocalDataSourceProvider),
  ),
);

final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<Logout>(
  (ref) => Logout(ref.watch(authRepositoryProvider)),
);

final restoreSessionUseCaseProvider = Provider<RestoreSession>(
  (ref) => RestoreSession(ref.watch(authRepositoryProvider)),
);

/// The signed-in session, or null. The router watches this to decide between
/// the splash, the login screen and the app shell.
final authControllerProvider = AsyncNotifierProvider<AuthController, Session?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<Session?> {
  /// Runs once at startup: the initial `AsyncLoading` is what the splash
  /// screen is showing.
  @override
  Future<Session?> build() async {
    final result = await ref.read(restoreSessionUseCaseProvider)(
      const NoParams(),
    );
    // A broken keystore read shouldn't wedge the app on the splash screen —
    // fall back to signed out.
    return result.getOrElse((_) => null);
  }

  /// Signs in and, on success, flips the app into its authenticated state.
  /// The caller decides how to surface a [Failure]; this state stays clean so
  /// the router never sees a half-finished login.
  Future<Either<Failure, Session>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await ref.read(loginUseCaseProvider)(
      LoginParams(email: email, password: password),
    );
    return result.map((session) {
      state = AsyncData(session);
      return session;
    });
  }

  Future<void> signOut() async {
    await ref.read(logoutUseCaseProvider)(const NoParams());
    // Clearing local state matters even if the keystore delete failed —
    // otherwise the user stays inside the app after tapping Log out.
    state = const AsyncData(null);
  }
}

/// Convenience reads for widgets that only need the current user.
final sessionProvider = Provider<Session?>(
  (ref) => ref.watch(authControllerProvider).valueOrNull,
);

/// Closes the loop `core/di` deliberately leaves open: when the API rejects a
/// stored token, drop the session so the router returns to the login screen
/// instead of leaving the user inside an app whose every call now 401s.
final authWiringOverrides = <Override>[
  unauthorizedHandlerProvider.overrideWith(
    (ref) => () => ref.read(authControllerProvider.notifier).signOut(),
  ),
];
