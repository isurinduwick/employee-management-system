import 'package:freezed_annotation/freezed_annotation.dart';

import 'leave_status.dart';

part 'leave_request.freezed.dart';

/// One employee's request for time off. Mirrors
/// backend/DTOs/Leave/LeaveResponseDto.cs.
@freezed
abstract class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required int id,
    required int employeeId,
    required String employeeName,
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required LeaveStatus status,
    required DateTime appliedOn,
    String? reason,
    int? approvedById,
    String? approvedByName,
  }) = _LeaveRequest;

  const LeaveRequest._();

  /// Only a pending request can still be decided — the API answers 409 on a
  /// second decision.
  bool get isPending => status == LeaveStatus.pending;

  /// Inclusive of both ends, matching how the backend reads the date range.
  int get totalDays => endDate.difference(startDate).inDays + 1;
}
