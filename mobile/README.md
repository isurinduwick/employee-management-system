# EMS Mobile

Flutter client for the Employee Management System, talking to the ASP.NET API
in [`backend/`](../backend) and mirroring the web client in
[`frontend/`](../frontend).

## Tech stack

| Concern | Choice |
|---|---|
| Architecture | Clean Architecture — `domain` / `data` / `presentation` per feature |
| State / DI | [riverpod](https://riverpod.dev) — `AsyncNotifier` + `AsyncValue<T>` |
| Networking | [dio](https://pub.dev/packages/dio) with a bearer-token interceptor |
| Models | [freezed](https://pub.dev/packages/freezed) 3.x + json_serializable (codegen) |
| Errors | [fpdart](https://pub.dev/packages/fpdart) `Either<Failure, T>` |
| Routing | [go_router](https://pub.dev/packages/go_router) with an auth redirect |
| Storage | flutter_secure_storage (Android Keystore / iOS Keychain) |

## Project structure

```
lib/
  main.dart                    entry point -> bootstrap()
  app/                         guarded zone + ProviderScope + MaterialApp.router
  core/
    error/                     sealed Failure · exceptions · mapExceptionToFailure()
    usecase/                   UseCase<T, Params> / SyncUseCase base
    network/                   ApiClient (dio) · AuthInterceptor · ApiHost
    storage/                   TokenStorage (raw bearer token)
    di/                        secureStorage · tokenStorage · dio · apiClient providers
    router/                    AppRoutes + go_router config
    theme/                     colour / radius / spacing tokens + ThemeData
    utils/                     shared form validators
    widgets/                   reusable, feature-agnostic widgets
  features/
    auth/                      <- reference feature (copy this)
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{providers,screens,widgets}/
    shell/                     app bar + role-filtered drawer around every route
    dashboard/ employees/ departments/ attendance/ leave/
                               presentation-only placeholders, ready to grow
                               the same three layers
test/
  helpers/                     fake data sources + pumpApp()
  features/auth/               repository mapping + full login flow
```

### The dependency rule

`presentation -> domain <- data`. The domain layer holds entities, repository
*interfaces* and use cases, and imports nothing from Flutter, dio or freezed's
JSON support. `data` implements those interfaces; `presentation` depends only
on the domain plus Riverpod providers that wire the two together.

`core/` never imports `features/` — that is why the bearer token lives in
`core/storage/token_storage.dart` rather than the auth feature's local data
source.

### How a call flows

```
LoginForm  ->  LoginFormController  ->  AuthController
                                            |
                                        Login (use case)
                                            |
                                  AuthRepository (interface)
                                            |
                                  AuthRepositoryImpl  ->  remote data source -> ApiClient -> dio
                                            |            local data source  -> secure storage
                                    Either<Failure, Session>
```

Nothing above `AuthRepositoryImpl` throws: data sources throw, the repository
catches once via `mapExceptionToFailure()`, and everything higher up pattern
matches on a `sealed Failure`.

### Adding a feature

1. `features/<name>/domain/` — entity, repository interface, use case(s).
2. `features/<name>/data/` — freezed model with `fromJson`/`toEntity`, a data
   source, the repository implementation.
3. `features/<name>/presentation/` — providers (data source -> repository ->
   use case -> `AsyncNotifier`), then screens/widgets built out of
   `core/widgets/`.
4. Add the route to `core/router/app_routes.dart`, the destination to
   `features/shell/domain/entities/nav_item.dart` (with the roles allowed to
   see it) and its icon to `features/shell/presentation/widgets/nav_icons.dart`.

Screens render their state with `AsyncValueView<T>`, which handles the
loading / error / data cases in one place.

## Running

```bash
flutter pub get
dart run build_runner build          # after touching any @freezed model
flutter run
```

The API base URL is resolved in `core/network/api_host.dart`: `10.0.2.2` on the
Android emulator, `localhost` elsewhere. A physical device needs the host
machine's LAN IP:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5133/api
```

Generated files (`*.freezed.dart`, `*.g.dart`) are committed, so a fresh clone
builds without running the generator first. Watch mode during development:

```bash
dart run build_runner watch
```

## Tests

```bash
flutter analyze
flutter test
```

The suite boots the real app — router, providers, use cases and repository —
with only the two auth data sources replaced by in-memory fakes
(`test/helpers/`), so role-based navigation, session restore and the login
failure paths are all covered without a running backend.
