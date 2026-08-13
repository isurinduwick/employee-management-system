import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_format.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/attendance_remote_data_source.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/usecases/check_in.dart';
import '../../domain/usecases/check_out.dart';
import '../../domain/usecases/get_attendance.dart';

final attendanceRemoteDataSourceProvider = Provider<AttendanceRemoteDataSource>(
  (ref) => AttendanceRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepositoryImpl(
    remote: ref.watch(attendanceRemoteDataSourceProvider),
  ),
);

final getAttendanceUseCaseProvider = Provider<GetAttendance>(
  (ref) => GetAttendance(ref.watch(attendanceRepositoryProvider)),
);

final checkInUseCaseProvider = Provider<CheckIn>(
  (ref) => CheckIn(ref.watch(attendanceRepositoryProvider)),
);

final checkOutUseCaseProvider = Provider<CheckOut>(
  (ref) => CheckOut(ref.watch(attendanceRepositoryProvider)),
);

/// Team Attendance is only meaningful for roles that manage other people —
/// an Employee's own reads are already scoped to themself by the API.
final canViewTeamAttendanceProvider = Provider<bool>((ref) {
  final role = ref.watch(sessionProvider)?.role;
  return role == Role.admin || role == Role.manager;
});

/// Today's attendance for the signed-in user — drives the status card and the
/// dashboard banner. Independent of [myAttendanceHistoryProvider] so checking
/// in doesn't force the whole history list into a loading state.
final todayAttendanceProvider =
    AsyncNotifierProvider<TodayAttendanceController, AttendanceRecord?>(
      TodayAttendanceController.new,
    );

class TodayAttendanceController extends AsyncNotifier<AttendanceRecord?> {
  @override
  Future<AttendanceRecord?> build() => _fetch();

  Future<AttendanceRecord?> _fetch() async {
    final session = ref.read(sessionProvider);
    if (session == null) return null;

    final today = DateFormatting.today();
    final result = await ref.read(getAttendanceUseCaseProvider)(
      AttendanceFilters(
        employeeId: session.employeeId,
        startDate: today,
        endDate: today,
      ),
    );
    final records = result.getOrElse((failure) => throw failure);
    // The API stores at most one row per (employee, day).
    return records.isEmpty ? null : records.first;
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<Either<Failure, AttendanceRecord>> checkIn() async {
    final result = await ref.read(checkInUseCaseProvider)(DeviceType.mobile);
    return result.map((record) {
      state = AsyncData(record);
      // The history list would otherwise miss today's new row until its own
      // next refresh.
      ref.invalidate(myAttendanceHistoryProvider);
      return record;
    });
  }

  Future<Either<Failure, AttendanceRecord>> checkOut() async {
    final result = await ref.read(checkOutUseCaseProvider)(const NoParams());
    return result.map((record) {
      state = AsyncData(record);
      ref.invalidate(myAttendanceHistoryProvider);
      return record;
    });
  }
}

/// The signed-in user's full attendance history (self-service Attendance
/// screen — no filters, since the API already scopes an Employee's reads to
/// themself and this screen is "my" history for every role).
final myAttendanceHistoryProvider =
    AsyncNotifierProvider<MyAttendanceHistoryController, List<AttendanceRecord>>(
      MyAttendanceHistoryController.new,
    );

class MyAttendanceHistoryController extends AsyncNotifier<List<AttendanceRecord>> {
  @override
  Future<List<AttendanceRecord>> build() => _fetch();

  Future<List<AttendanceRecord>> _fetch() async {
    final session = ref.read(sessionProvider);
    if (session == null) return const [];

    final result = await ref.read(getAttendanceUseCaseProvider)(
      AttendanceFilters(employeeId: session.employeeId),
    );
    return result.getOrElse((failure) => throw failure);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }
}

/// Filters for the Team Attendance screen (Manager/Admin). Replaced wholesale
/// on Apply/Clear rather than patched field-by-field.
final teamAttendanceFiltersProvider = StateProvider<AttendanceFilters>(
  (ref) => const AttendanceFilters(),
);

/// The filtered, company-wide (or department-wide) attendance list. Rebuilds
/// whenever the filters change; pull-to-refresh re-runs it via invalidate.
final teamAttendanceProvider = FutureProvider<List<AttendanceRecord>>((
  ref,
) async {
  final filters = ref.watch(teamAttendanceFiltersProvider);
  final result = await ref.watch(getAttendanceUseCaseProvider)(filters);
  return result.getOrElse((failure) => throw failure);
});
