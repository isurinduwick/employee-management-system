import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/date_only_converter.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_record_model.dart';
import '../models/check_in_request_model.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<List<AttendanceRecordModel>> getAttendance(AttendanceFilters filters);
  Future<AttendanceRecordModel> checkIn(DeviceType deviceType);
  Future<AttendanceRecordModel> checkOut();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  const AttendanceRemoteDataSourceImpl(this._client);

  static const _path = '/attendance';

  final ApiClient _client;

  @override
  Future<List<AttendanceRecordModel>> getAttendance(
    AttendanceFilters filters,
  ) async {
    final json = await _client.get(_path, query: _queryFor(filters));
    if (json is! List) {
      throw const ParseException('Expected a list of attendance records.');
    }
    return [
      for (final item in json)
        AttendanceRecordModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<AttendanceRecordModel> checkIn(DeviceType deviceType) async {
    final json = await _client.post(
      '$_path/check-in',
      body: CheckInRequestModel(deviceType: deviceType).toJson(),
    );
    return _asRecord(json);
  }

  @override
  Future<AttendanceRecordModel> checkOut() async {
    final json = await _client.post('$_path/check-out');
    return _asRecord(json);
  }

  Map<String, dynamic>? _queryFor(AttendanceFilters filters) {
    // startDate/endDate are query-string parameters, not a JSON body, so they
    // need the same yyyy-MM-dd shape the converter already produces for models.
    const dateFormat = DateOnlyConverter();
    final query = <String, dynamic>{
      if (filters.employeeId != null) 'employeeId': filters.employeeId,
      if (filters.departmentId != null) 'departmentId': filters.departmentId,
      if (filters.startDate != null)
        'startDate': dateFormat.toJson(filters.startDate!),
      if (filters.endDate != null)
        'endDate': dateFormat.toJson(filters.endDate!),
    };
    return query.isEmpty ? null : query;
  }

  AttendanceRecordModel _asRecord(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const ParseException('Expected a single attendance record.');
    }
    return AttendanceRecordModel.fromJson(json);
  }
}
