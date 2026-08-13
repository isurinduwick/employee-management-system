// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckInRequestModel _$CheckInRequestModelFromJson(Map<String, dynamic> json) =>
    _CheckInRequestModel(
      deviceType: const DeviceTypeConverter().fromJson(
        json['deviceType'] as String,
      ),
    );

Map<String, dynamic> _$CheckInRequestModelToJson(
  _CheckInRequestModel instance,
) => <String, dynamic>{
  'deviceType': const DeviceTypeConverter().toJson(instance.deviceType),
};
