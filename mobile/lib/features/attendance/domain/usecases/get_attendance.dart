import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

class GetAttendance
    implements UseCase<List<AttendanceRecord>, AttendanceFilters> {
  const GetAttendance(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, List<AttendanceRecord>>> call(
    AttendanceFilters params,
  ) => _repository.getAttendance(params);
}
