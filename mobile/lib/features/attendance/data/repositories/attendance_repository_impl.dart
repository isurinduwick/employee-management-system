import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  const AttendanceRepositoryImpl({required this.remote});

  final AttendanceRemoteDataSource remote;

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendance(
    AttendanceFilters filters,
  ) async {
    try {
      final models = await remote.getAttendance(filters);
      return Right([for (final model in models) model.toEntity()]);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> checkIn(
    DeviceType deviceType,
  ) async {
    try {
      final model = await remote.checkIn(deviceType);
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> checkOut() async {
    try {
      final model = await remote.checkOut();
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
