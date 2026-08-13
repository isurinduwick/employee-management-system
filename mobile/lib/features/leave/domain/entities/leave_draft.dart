import 'package:freezed_annotation/freezed_annotation.dart';

import 'leave_status.dart';

part 'leave_draft.freezed.dart';

/// What the request form collects, mirroring LeaveRequestCreateDto.
///
/// No employee id: the API takes that from the JWT, so an employee can only
/// ever request leave for themself.
@freezed
abstract class NewLeaveRequest with _$NewLeaveRequest {
  const factory NewLeaveRequest({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) = _NewLeaveRequest;

  const NewLeaveRequest._();
}
