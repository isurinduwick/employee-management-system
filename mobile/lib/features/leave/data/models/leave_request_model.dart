import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/date_only_converter.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_status.dart';
import 'leave_enum_converters.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

/// Wire shape of backend/DTOs/Leave/LeaveResponseDto.cs.
@freezed
abstract class LeaveRequestModel with _$LeaveRequestModel {
  const factory LeaveRequestModel({
    required int id,
    required int employeeId,
    required String employeeName,
    @LeaveTypeConverter() required LeaveType leaveType,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,
    @LeaveStatusConverter() required LeaveStatus status,
    required DateTime appliedOn,
    String? reason,
    int? approvedById,
    String? approvedByName,
  }) = _LeaveRequestModel;

  const LeaveRequestModel._();

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);

  LeaveRequest toEntity() => LeaveRequest(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    leaveType: leaveType,
    startDate: startDate,
    endDate: endDate,
    status: status,
    appliedOn: appliedOn,
    reason: reason,
    approvedById: approvedById,
    approvedByName: approvedByName,
  );
}
