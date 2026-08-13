import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/leave_repository.dart';
import '../models/leave_request_model.dart';
import '../models/leave_request_models.dart';

abstract interface class LeaveRemoteDataSource {
  Future<List<LeaveRequestModel>> getLeaveRequests(LeaveFilters filters);
  Future<LeaveRequestModel> createLeaveRequest(LeaveCreateModel body);
  Future<LeaveRequestModel> decide(int id, LeaveDecisionModel body);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  const LeaveRemoteDataSourceImpl(this._client);

  static const _path = '/leave-requests';

  final ApiClient _client;

  @override
  Future<List<LeaveRequestModel>> getLeaveRequests(
    LeaveFilters filters,
  ) async {
    final query = <String, dynamic>{
      if (filters.employeeId != null) 'employeeId': filters.employeeId,
      if (filters.status != null) 'status': filters.status!.label,
    };

    final json = await _client.get(
      _path,
      query: query.isEmpty ? null : query,
    );
    if (json is! List) {
      throw const ParseException('Expected a list of leave requests.');
    }
    return [
      for (final item in json)
        LeaveRequestModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<LeaveRequestModel> createLeaveRequest(LeaveCreateModel body) async {
    final json = await _client.post(_path, body: body.toJson());
    return _asRequest(json);
  }

  @override
  Future<LeaveRequestModel> decide(int id, LeaveDecisionModel body) async {
    final json = await _client.put('$_path/$id/decision', body: body.toJson());
    return _asRequest(json);
  }

  LeaveRequestModel _asRequest(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const ParseException('Expected a single leave request.');
    }
    return LeaveRequestModel.fromJson(json);
  }
}
