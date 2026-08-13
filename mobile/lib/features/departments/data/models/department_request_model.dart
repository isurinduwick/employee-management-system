import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_request_model.freezed.dart';
part 'department_request_model.g.dart';

/// Wire shape of both DepartmentCreateDto and DepartmentUpdateDto — they're
/// identical, so one model serves both requests.
@freezed
abstract class DepartmentRequestModel with _$DepartmentRequestModel {
  const factory DepartmentRequestModel({required String name}) =
      _DepartmentRequestModel;

  factory DepartmentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentRequestModelFromJson(json);
}
