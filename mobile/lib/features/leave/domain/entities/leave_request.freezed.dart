// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeaveRequest {

 int get id; int get employeeId; String get employeeName; LeaveType get leaveType; DateTime get startDate; DateTime get endDate; LeaveStatus get status; DateTime get appliedOn; String? get reason; int? get approvedById; String? get approvedByName;
/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveRequestCopyWith<LeaveRequest> get copyWith => _$LeaveRequestCopyWithImpl<LeaveRequest>(this as LeaveRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedOn, appliedOn) || other.appliedOn == appliedOn)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedById, approvedById) || other.approvedById == approvedById)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName));
}


@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,leaveType,startDate,endDate,status,appliedOn,reason,approvedById,approvedByName);

@override
String toString() {
  return 'LeaveRequest(id: $id, employeeId: $employeeId, employeeName: $employeeName, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, status: $status, appliedOn: $appliedOn, reason: $reason, approvedById: $approvedById, approvedByName: $approvedByName)';
}


}

/// @nodoc
abstract mixin class $LeaveRequestCopyWith<$Res>  {
  factory $LeaveRequestCopyWith(LeaveRequest value, $Res Function(LeaveRequest) _then) = _$LeaveRequestCopyWithImpl;
@useResult
$Res call({
 int id, int employeeId, String employeeName, LeaveType leaveType, DateTime startDate, DateTime endDate, LeaveStatus status, DateTime appliedOn, String? reason, int? approvedById, String? approvedByName
});




}
/// @nodoc
class _$LeaveRequestCopyWithImpl<$Res>
    implements $LeaveRequestCopyWith<$Res> {
  _$LeaveRequestCopyWithImpl(this._self, this._then);

  final LeaveRequest _self;
  final $Res Function(LeaveRequest) _then;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? appliedOn = null,Object? reason = freezed,Object? approvedById = freezed,Object? approvedByName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,appliedOn: null == appliedOn ? _self.appliedOn : appliedOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedById: freezed == approvedById ? _self.approvedById : approvedById // ignore: cast_nullable_to_non_nullable
as int?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveRequest].
extension LeaveRequestPatterns on LeaveRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveRequest value)  $default,){
final _that = this;
switch (_that) {
case _LeaveRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int employeeId,  String employeeName,  LeaveType leaveType,  DateTime startDate,  DateTime endDate,  LeaveStatus status,  DateTime appliedOn,  String? reason,  int? approvedById,  String? approvedByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.status,_that.appliedOn,_that.reason,_that.approvedById,_that.approvedByName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int employeeId,  String employeeName,  LeaveType leaveType,  DateTime startDate,  DateTime endDate,  LeaveStatus status,  DateTime appliedOn,  String? reason,  int? approvedById,  String? approvedByName)  $default,) {final _that = this;
switch (_that) {
case _LeaveRequest():
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.status,_that.appliedOn,_that.reason,_that.approvedById,_that.approvedByName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int employeeId,  String employeeName,  LeaveType leaveType,  DateTime startDate,  DateTime endDate,  LeaveStatus status,  DateTime appliedOn,  String? reason,  int? approvedById,  String? approvedByName)?  $default,) {final _that = this;
switch (_that) {
case _LeaveRequest() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.leaveType,_that.startDate,_that.endDate,_that.status,_that.appliedOn,_that.reason,_that.approvedById,_that.approvedByName);case _:
  return null;

}
}

}

/// @nodoc


class _LeaveRequest extends LeaveRequest {
  const _LeaveRequest({required this.id, required this.employeeId, required this.employeeName, required this.leaveType, required this.startDate, required this.endDate, required this.status, required this.appliedOn, this.reason, this.approvedById, this.approvedByName}): super._();
  

@override final  int id;
@override final  int employeeId;
@override final  String employeeName;
@override final  LeaveType leaveType;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  LeaveStatus status;
@override final  DateTime appliedOn;
@override final  String? reason;
@override final  int? approvedById;
@override final  String? approvedByName;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveRequestCopyWith<_LeaveRequest> get copyWith => __$LeaveRequestCopyWithImpl<_LeaveRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.leaveType, leaveType) || other.leaveType == leaveType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedOn, appliedOn) || other.appliedOn == appliedOn)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approvedById, approvedById) || other.approvedById == approvedById)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName));
}


@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,leaveType,startDate,endDate,status,appliedOn,reason,approvedById,approvedByName);

@override
String toString() {
  return 'LeaveRequest(id: $id, employeeId: $employeeId, employeeName: $employeeName, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, status: $status, appliedOn: $appliedOn, reason: $reason, approvedById: $approvedById, approvedByName: $approvedByName)';
}


}

/// @nodoc
abstract mixin class _$LeaveRequestCopyWith<$Res> implements $LeaveRequestCopyWith<$Res> {
  factory _$LeaveRequestCopyWith(_LeaveRequest value, $Res Function(_LeaveRequest) _then) = __$LeaveRequestCopyWithImpl;
@override @useResult
$Res call({
 int id, int employeeId, String employeeName, LeaveType leaveType, DateTime startDate, DateTime endDate, LeaveStatus status, DateTime appliedOn, String? reason, int? approvedById, String? approvedByName
});




}
/// @nodoc
class __$LeaveRequestCopyWithImpl<$Res>
    implements _$LeaveRequestCopyWith<$Res> {
  __$LeaveRequestCopyWithImpl(this._self, this._then);

  final _LeaveRequest _self;
  final $Res Function(_LeaveRequest) _then;

/// Create a copy of LeaveRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? leaveType = null,Object? startDate = null,Object? endDate = null,Object? status = null,Object? appliedOn = null,Object? reason = freezed,Object? approvedById = freezed,Object? approvedByName = freezed,}) {
  return _then(_LeaveRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,leaveType: null == leaveType ? _self.leaveType : leaveType // ignore: cast_nullable_to_non_nullable
as LeaveType,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeaveStatus,appliedOn: null == appliedOn ? _self.appliedOn : appliedOn // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,approvedById: freezed == approvedById ? _self.approvedById : approvedById // ignore: cast_nullable_to_non_nullable
as int?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
