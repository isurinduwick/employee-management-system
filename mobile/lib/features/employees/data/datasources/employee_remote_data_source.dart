import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/employee_model.dart';
import '../models/employee_request_models.dart';

/// The /api/employees endpoints. Throws [DioException] on any non-2xx; the
/// repository converts that into a [Failure].
abstract interface class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees({int? departmentId});
  Future<EmployeeModel> createEmployee(EmployeeCreateModel body);
  Future<EmployeeModel> updateEmployee(int id, EmployeeUpdateModel body);
  Future<void> deactivateEmployee(int id);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  const EmployeeRemoteDataSourceImpl(this._client);

  static const _path = '/employees';

  final ApiClient _client;

  @override
  Future<List<EmployeeModel>> getEmployees({int? departmentId}) async {
    final json = await _client.get(
      _path,
      query: departmentId == null ? null : {'departmentId': departmentId},
    );
    if (json is! List) {
      throw const ParseException('Expected a list of employees.');
    }
    return [
      for (final item in json)
        EmployeeModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeCreateModel body) async {
    final json = await _client.post(_path, body: body.toJson());
    return _asEmployee(json);
  }

  @override
  Future<EmployeeModel> updateEmployee(int id, EmployeeUpdateModel body) async {
    final json = await _client.put('$_path/$id', body: body.toJson());
    return _asEmployee(json);
  }

  @override
  Future<void> deactivateEmployee(int id) => _client.delete('$_path/$id');

  EmployeeModel _asEmployee(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const ParseException('Expected a single employee object.');
    }
    return EmployeeModel.fromJson(json);
  }
}
