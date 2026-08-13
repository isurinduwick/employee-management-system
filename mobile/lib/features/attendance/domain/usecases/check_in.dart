import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_record.dart';
import '../entities/attendance_status.dart';
import '../repositories/attendance_repository.dart';

class CheckIn implements UseCase<AttendanceRecord, DeviceType> {
  const CheckIn(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecord>> call(DeviceType params) =>
      _repository.checkIn(params);
}
