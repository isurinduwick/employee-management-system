import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/department_model.dart';

abstract interface class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartments();
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  const DepartmentRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    final json = await _client.get('/departments');
    if (json is! List) {
      throw const ParseException('Expected a list of departments.');
    }
    return [
      for (final item in json)
        DepartmentModel.fromJson(item as Map<String, dynamic>),
    ];
  }
}
