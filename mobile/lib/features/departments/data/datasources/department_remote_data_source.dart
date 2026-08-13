import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/department_model.dart';
import '../models/department_request_model.dart';

abstract interface class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartments();
  Future<DepartmentModel> createDepartment(DepartmentRequestModel body);
  Future<DepartmentModel> updateDepartment(
    int id,
    DepartmentRequestModel body,
  );
  Future<void> deleteDepartment(int id);
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  const DepartmentRemoteDataSourceImpl(this._client);

  static const _path = '/departments';

  final ApiClient _client;

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    final json = await _client.get(_path);
    if (json is! List) {
      throw const ParseException('Expected a list of departments.');
    }
    return [
      for (final item in json)
        DepartmentModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<DepartmentModel> createDepartment(
    DepartmentRequestModel body,
  ) async {
    final json = await _client.post(_path, body: body.toJson());
    return _asDepartment(json);
  }

  @override
  Future<DepartmentModel> updateDepartment(
    int id,
    DepartmentRequestModel body,
  ) async {
    final json = await _client.put('$_path/$id', body: body.toJson());
    return _asDepartment(json);
  }

  @override
  Future<void> deleteDepartment(int id) => _client.delete('$_path/$id');

  DepartmentModel _asDepartment(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const ParseException('Expected a single department object.');
    }
    return DepartmentModel.fromJson(json);
  }
}
