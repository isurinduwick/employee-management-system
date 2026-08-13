import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/attendance_status.dart';
import 'attendance_enum_converters.dart';

part 'check_in_request_model.freezed.dart';
part 'check_in_request_model.g.dart';

/// Wire shape of backend/DTOs/Attendance/CheckInDto.cs.
@freezed
abstract class CheckInRequestModel with _$CheckInRequestModel {
  const factory CheckInRequestModel({
    @DeviceTypeConverter() required DeviceType deviceType,
  }) = _CheckInRequestModel;

  factory CheckInRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInRequestModelFromJson(json);
}
