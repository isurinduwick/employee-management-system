import 'package:mobile/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:mobile/features/leave/data/models/leave_request_model.dart';
import 'package:mobile/features/leave/data/models/leave_request_models.dart';
import 'package:mobile/features/leave/domain/entities/leave_status.dart';
import 'package:mobile/features/leave/domain/repositories/leave_repository.dart';

/// In-memory stand-in for the /api/leave-requests endpoints. Set [error] to
/// make the next call throw, which is how the failure paths get exercised.
class FakeLeaveRemoteDataSource implements LeaveRemoteDataSource {
  FakeLeaveRemoteDataSource({List<LeaveRequestModel>? requests, this.error})
    : requests = [...?requests];

  List<LeaveRequestModel> requests;
  Object? error;

  /// Every filter combination this source was asked for. The approvals screen
  /// is a child route of the leave screen, so both fetch on the same
  /// navigation — assert against this rather than "the last call".
  final List<LeaveFilters> filtersLog = [];
  LeaveCreateModel? lastCreate;
  (int, LeaveStatus)? lastDecision;

  LeaveFilters? get lastFilters =>
      filtersLog.isEmpty ? null : filtersLog.last;

  int _nextId = 700;

  void _throwIfPrimed() {
    final pending = error;
    if (pending != null) throw pending;
  }

  @override
  Future<List<LeaveRequestModel>> getLeaveRequests(LeaveFilters filters) async {
    _throwIfPrimed();
    filtersLog.add(filters);

    return [
      for (final request in requests)
        if ((filters.employeeId == null ||
                request.employeeId == filters.employeeId) &&
            (filters.status == null || request.status == filters.status))
          request,
    ];
  }

  @override
  Future<LeaveRequestModel> createLeaveRequest(LeaveCreateModel body) async {
    _throwIfPrimed();
    lastCreate = body;

    final created = leaveModelFor(
      id: _nextId++,
      leaveType: body.leaveType,
      startDate: body.startDate,
      endDate: body.endDate,
      reason: body.reason,
    );
    requests = [created, ...requests];
    return created;
  }

  @override
  Future<LeaveRequestModel> decide(int id, LeaveDecisionModel body) async {
    _throwIfPrimed();
    lastDecision = (id, body.status);

    final existing = requests.firstWhere((r) => r.id == id);
    final decided = existing.copyWith(
      status: body.status,
      approvedById: 1,
      approvedByName: 'Alex Manager',
    );
    requests = [
      for (final r in requests)
        if (r.id == id) decided else r,
    ];
    return decided;
  }
}

LeaveRequestModel leaveModelFor({
  required int id,
  int employeeId = 1,
  String employeeName = 'Sam Employee',
  LeaveType leaveType = LeaveType.vacation,
  DateTime? startDate,
  DateTime? endDate,
  LeaveStatus status = LeaveStatus.pending,
  DateTime? appliedOn,
  String? reason,
  int? approvedById,
  String? approvedByName,
}) {
  final start = startDate ?? DateTime(2026, 4, 6);
  return LeaveRequestModel(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    leaveType: leaveType,
    startDate: start,
    endDate: endDate ?? start,
    status: status,
    appliedOn: appliedOn ?? DateTime(2026, 4, 1),
    reason: reason,
    approvedById: approvedById,
    approvedByName: approvedByName,
  );
}
