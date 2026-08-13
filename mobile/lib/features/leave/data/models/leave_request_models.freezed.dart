// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveCreateModel {

@LeaveTypeConverter() LeaveType get leaveType;@DateOnlyConverter() DateTime get startDate;@DateOnlyConverter() DateTime get endDate; String? get reason;
/// Create a copy of LeaveCreateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveCreateModelCopyWith<LeaveCreateModel> get copyWith => _$LeaveCreateModelCopyWithImpl<LeaveCreateModel>(this as LeaveCreateModel, _$identity);

  /// Serializes this LeaveCreateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveCreateModel&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaveType,startDate,endDate,reason);

@override
String toString() {
  return 'LeaveCreateModel(leaveType: $leaveType, startDate: $startDate, endDate: $endDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $LeaveCreateModelCopyWith<$Res>  {
  factory $LeaveCreateModelCopyWith(LeaveCreateModel value, $Res Function(LeaveCreateModel) _then) = _$LeaveCreateModelCopyWithImpl;
@useResult
$Res call({
@LeaveTypeConverter() LeaveType leaveType,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, String? reason
});




}
/// @nodoc
class _$LeaveCreateModelCopyWithImpl<$Res>
    implements $LeaveCreateModelCopyWith<$Res> {
  _$LeaveCreateModelCopyWithImpl(this._self, this._then);

  final LeaveCreateModel _self;
  final $Res Function(LeaveCreateModel) _then;

/// Create a copy of LeaveCreateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveCreateModel].
extension LeaveCreateModelPatterns on LeaveCreateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveCreateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveCreateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveCreateModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveCreateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveCreateModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveCreateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@LeaveTypeConverter()  LeaveType leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveCreateModel() when $default != null:
return $default(_that.leaveType,_that.startDate,_that.endDate,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@LeaveTypeConverter()  LeaveType leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _LeaveCreateModel():
return $default(_that.leaveType,_that.startDate,_that.endDate,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@LeaveTypeConverter()  LeaveType leaveType, @DateOnlyConverter()  DateTime startDate, @DateOnlyConverter()  DateTime endDate,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _LeaveCreateModel() when $default != null:
return $default(_that.leaveType,_that.startDate,_that.endDate,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveCreateModel extends LeaveCreateModel {
  const _LeaveCreateModel({@LeaveTypeConverter() required this.leaveType, @DateOnlyConverter() required this.startDate, @DateOnlyConverter() required this.endDate, this.reason}): super._();
  factory _LeaveCreateModel.fromJson(Map<String, dynamic> json) => _$LeaveCreateModelFromJson(json);

@override@LeaveTypeConverter() final  LeaveType leaveType;
@override@DateOnlyConverter() final  DateTime startDate;
@override@DateOnlyConverter() final  DateTime endDate;
@override final  String? reason;

/// Create a copy of LeaveCreateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveCreateModelCopyWith<_LeaveCreateModel> get copyWith => __$LeaveCreateModelCopyWithImpl<_LeaveCreateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveCreateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveCreateModel&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leaveType,startDate,endDate,reason);

@override
String toString() {
  return 'LeaveCreateModel(leaveType: $leaveType, startDate: $startDate, endDate: $endDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$LeaveCreateModelCopyWith<$Res> implements $LeaveCreateModelCopyWith<$Res> {
  factory _$LeaveCreateModelCopyWith(_LeaveCreateModel value, $Res Function(_LeaveCreateModel) _then) = __$LeaveCreateModelCopyWithImpl;
@override @useResult
$Res call({
@LeaveTypeConverter() LeaveType leaveType,@DateOnlyConverter() DateTime startDate,@DateOnlyConverter() DateTime endDate, String? reason
});




}
/// @nodoc
class __$LeaveCreateModelCopyWithImpl<$Res>
    implements _$LeaveCreateModelCopyWith<$Res> {
  __$LeaveCreateModelCopyWithImpl(this._self, this._then);

  final _LeaveCreateModel _self;
  final $Res Function(_LeaveCreateModel) _then;

/// Create a copy of LeaveCreateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? reason = freezed,}) {
  return _then(_LeaveCreateModel(
leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeaveDecisionModel {

@LeaveStatusConverter() LeaveStatus get status;
/// Create a copy of LeaveDecisionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveDecisionModelCopyWith<LeaveDecisionModel> get copyWith => _$LeaveDecisionModelCopyWithImpl<LeaveDecisionModel>(this as LeaveDecisionModel, _$identity);

  /// Serializes this LeaveDecisionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveDecisionModel&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'LeaveDecisionModel(status: $status)';
}


}

/// @nodoc
abstract mixin class $LeaveDecisionModelCopyWith<$Res>  {
  factory $LeaveDecisionModelCopyWith(LeaveDecisionModel value, $Res Function(LeaveDecisionModel) _then) = _$LeaveDecisionModelCopyWithImpl;
@useResult
$Res call({
@LeaveStatusConverter() LeaveStatus status
});




}
/// @nodoc
class _$LeaveDecisionModelCopyWithImpl<$Res>
    implements $LeaveDecisionModelCopyWith<$Res> {
  _$LeaveDecisionModelCopyWithImpl(this._self, this._then);

  final LeaveDecisionModel _self;
  final $Res Function(LeaveDecisionModel) _then;

/// Create a copy of LeaveDecisionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveDecisionModel].
extension LeaveDecisionModelPatterns on LeaveDecisionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveDecisionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveDecisionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveDecisionModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveDecisionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveDecisionModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveDecisionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@LeaveStatusConverter()  LeaveStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveDecisionModel() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@LeaveStatusConverter()  LeaveStatus status)  $default,) {final _that = this;
switch (_that) {
case _LeaveDecisionModel():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@LeaveStatusConverter()  LeaveStatus status)?  $default,) {final _that = this;
switch (_that) {
case _LeaveDecisionModel() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveDecisionModel extends LeaveDecisionModel {
  const _LeaveDecisionModel({@LeaveStatusConverter() required this.status}): super._();
  factory _LeaveDecisionModel.fromJson(Map<String, dynamic> json) => _$LeaveDecisionModelFromJson(json);

@override@LeaveStatusConverter() final  LeaveStatus status;

/// Create a copy of LeaveDecisionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveDecisionModelCopyWith<_LeaveDecisionModel> get copyWith => __$LeaveDecisionModelCopyWithImpl<_LeaveDecisionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveDecisionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveDecisionModel&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'LeaveDecisionModel(status: $status)';
}


}

/// @nodoc
abstract mixin class _$LeaveDecisionModelCopyWith<$Res> implements $LeaveDecisionModelCopyWith<$Res> {
  factory _$LeaveDecisionModelCopyWith(_LeaveDecisionModel value, $Res Function(_LeaveDecisionModel) _then) = __$LeaveDecisionModelCopyWithImpl;
@override @useResult
$Res call({
@LeaveStatusConverter() LeaveStatus status
});




}
/// @nodoc
class __$LeaveDecisionModelCopyWithImpl<$Res>
    implements _$LeaveDecisionModelCopyWith<$Res> {
  __$LeaveDecisionModelCopyWithImpl(this._self, this._then);

  final _LeaveDecisionModel _self;
  final $Res Function(_LeaveDecisionModel) _then;

/// Create a copy of LeaveDecisionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_LeaveDecisionModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,
  ));
}


}

// dart format on
