// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewLeaveRequest {

 LeaveType get leaveType; DateTime get startDate; DateTime get endDate; String? get reason;
/// Create a copy of NewLeaveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewLeaveRequestCopyWith<NewLeaveRequest> get copyWith => _$NewLeaveRequestCopyWithImpl<NewLeaveRequest>(this as NewLeaveRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewLeaveRequest&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,leaveType,startDate,endDate,reason);

@override
String toString() {
  return 'NewLeaveRequest(leaveType: $leaveType, startDate: $startDate, endDate: $endDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $NewLeaveRequestCopyWith<$Res>  {
  factory $NewLeaveRequestCopyWith(NewLeaveRequest value, $Res Function(NewLeaveRequest) _then) = _$NewLeaveRequestCopyWithImpl;
@useResult
$Res call({
 LeaveType leaveType, DateTime startDate, DateTime endDate, String? reason
});




}
/// @nodoc
class _$NewLeaveRequestCopyWithImpl<$Res>
    implements $NewLeaveRequestCopyWith<$Res> {
  _$NewLeaveRequestCopyWithImpl(this._self, this._then);

  final NewLeaveRequest _self;
  final $Res Function(NewLeaveRequest) _then;

/// Create a copy of NewLeaveRequest
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


/// Adds pattern-matching-related methods to [NewLeaveRequest].
extension NewLeaveRequestPatterns on NewLeaveRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewLeaveRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewLeaveRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewLeaveRequest value)  $default,){
final _that = this;
switch (_that) {
case _NewLeaveRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewLeaveRequest value)?  $default,){
final _that = this;
switch (_that) {
case _NewLeaveRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeaveType leaveType,  DateTime startDate,  DateTime endDate,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewLeaveRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeaveType leaveType,  DateTime startDate,  DateTime endDate,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _NewLeaveRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeaveType leaveType,  DateTime startDate,  DateTime endDate,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _NewLeaveRequest() when $default != null:
return $default(_that.leaveType,_that.startDate,_that.endDate,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _NewLeaveRequest extends NewLeaveRequest {
  const _NewLeaveRequest({required this.leaveType, required this.startDate, required this.endDate, this.reason}): super._();
  

@override final  LeaveType leaveType;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  String? reason;

/// Create a copy of NewLeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewLeaveRequestCopyWith<_NewLeaveRequest> get copyWith => __$NewLeaveRequestCopyWithImpl<_NewLeaveRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewLeaveRequest&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,leaveType,startDate,endDate,reason);

@override
String toString() {
  return 'NewLeaveRequest(leaveType: $leaveType, startDate: $startDate, endDate: $endDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$NewLeaveRequestCopyWith<$Res> implements $NewLeaveRequestCopyWith<$Res> {
  factory _$NewLeaveRequestCopyWith(_NewLeaveRequest value, $Res Function(_NewLeaveRequest) _then) = __$NewLeaveRequestCopyWithImpl;
@override @useResult
$Res call({
 LeaveType leaveType, DateTime startDate, DateTime endDate, String? reason
});




}
/// @nodoc
class __$NewLeaveRequestCopyWithImpl<$Res>
    implements _$NewLeaveRequestCopyWith<$Res> {
  __$NewLeaveRequestCopyWithImpl(this._self, this._then);

  final _NewLeaveRequest _self;
  final $Res Function(_NewLeaveRequest) _then;

/// Create a copy of NewLeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? reason = freezed,}) {
  return _then(_NewLeaveRequest(
leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
