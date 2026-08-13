// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckInRequestModel {

@DeviceTypeConverter() DeviceType get deviceType;
/// Create a copy of CheckInRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInRequestModelCopyWith<CheckInRequestModel> get copyWith => _$CheckInRequestModelCopyWithImpl<CheckInRequestModel>(this as CheckInRequestModel, _$identity);

  /// Serializes this CheckInRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInRequestModel&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceType);

@override
String toString() {
  return 'CheckInRequestModel(deviceType: $deviceType)';
}


}

/// @nodoc
abstract mixin class $CheckInRequestModelCopyWith<$Res>  {
  factory $CheckInRequestModelCopyWith(CheckInRequestModel value, $Res Function(CheckInRequestModel) _then) = _$CheckInRequestModelCopyWithImpl;
@useResult
$Res call({
@DeviceTypeConverter() DeviceType deviceType
});




}
/// @nodoc
class _$CheckInRequestModelCopyWithImpl<$Res>
    implements $CheckInRequestModelCopyWith<$Res> {
  _$CheckInRequestModelCopyWithImpl(this._self, this._then);

  final CheckInRequestModel _self;
  final $Res Function(CheckInRequestModel) _then;

/// Create a copy of CheckInRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceType = null,}) {
  return _then(_self.copyWith(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckInRequestModel].
extension CheckInRequestModelPatterns on CheckInRequestModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInRequestModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _CheckInRequestModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInRequestModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DeviceTypeConverter()  DeviceType deviceType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInRequestModel() when $default != null:
return $default(_that.deviceType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DeviceTypeConverter()  DeviceType deviceType)  $default,) {final _that = this;
switch (_that) {
case _CheckInRequestModel():
return $default(_that.deviceType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DeviceTypeConverter()  DeviceType deviceType)?  $default,) {final _that = this;
switch (_that) {
case _CheckInRequestModel() when $default != null:
return $default(_that.deviceType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckInRequestModel implements CheckInRequestModel {
  const _CheckInRequestModel({@DeviceTypeConverter() required this.deviceType});
  factory _CheckInRequestModel.fromJson(Map<String, dynamic> json) => _$CheckInRequestModelFromJson(json);

@override@DeviceTypeConverter() final  DeviceType deviceType;

/// Create a copy of CheckInRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInRequestModelCopyWith<_CheckInRequestModel> get copyWith => __$CheckInRequestModelCopyWithImpl<_CheckInRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckInRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInRequestModel&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceType);

@override
String toString() {
  return 'CheckInRequestModel(deviceType: $deviceType)';
}


}

/// @nodoc
abstract mixin class _$CheckInRequestModelCopyWith<$Res> implements $CheckInRequestModelCopyWith<$Res> {
  factory _$CheckInRequestModelCopyWith(_CheckInRequestModel value, $Res Function(_CheckInRequestModel) _then) = __$CheckInRequestModelCopyWithImpl;
@override @useResult
$Res call({
@DeviceTypeConverter() DeviceType deviceType
});




}
/// @nodoc
class __$CheckInRequestModelCopyWithImpl<$Res>
    implements _$CheckInRequestModelCopyWith<$Res> {
  __$CheckInRequestModelCopyWithImpl(this._self, this._then);

  final _CheckInRequestModel _self;
  final $Res Function(_CheckInRequestModel) _then;

/// Create a copy of CheckInRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceType = null,}) {
  return _then(_CheckInRequestModel(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,
  ));
}


}

// dart format on
