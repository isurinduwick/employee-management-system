import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/date_only_converter.dart';
import '../../domain/entities/leave_status.dart';
import 'leave_enum_converters.dart';

part 'leave_request_models.freezed.dart';
part 'leave_request_models.g.dart';

/// Wire shape of backend/DTOs/Leave/LeaveRequestCreateDto.cs.
@freezed
abstract class LeaveCreateModel with _$LeaveCreateModel {
  const factory LeaveCreateModel({
    @LeaveTypeConverter() required LeaveType leaveType,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,
    String? reason,
  }) = _LeaveCreateModel;

  const LeaveCreateModel._();

  factory LeaveCreateModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveCreateModelFromJson(json);
}

/// Wire shape of backend/DTOs/Leave/LeaveDecisionDto.cs.
@freezed
abstract class LeaveDecisionModel with _$LeaveDecisionModel {
  const factory LeaveDecisionModel({
    @LeaveStatusConverter() required LeaveStatus status,
  }) = _LeaveDecisionModel;

  const LeaveDecisionModel._();

  factory LeaveDecisionModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveDecisionModelFromJson(json);
}
