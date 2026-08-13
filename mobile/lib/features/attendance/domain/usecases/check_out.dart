import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

class CheckOut implements UseCase<AttendanceRecord, NoParams> {
  const CheckOut(this._repository);

  final AttendanceRepository _repository;

  @override
  Future<Either<Failure, AttendanceRecord>> call(NoParams params) =>
      _repository.checkOut();
}
