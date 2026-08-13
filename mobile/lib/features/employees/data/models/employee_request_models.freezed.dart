// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_request_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeCreateModel {

 String get employeeCode; String get firstName; String get lastName; String get email; String get password; int get departmentId;@RoleConverter() Role get role; String? get phoneNumber; int? get managerId;
/// Create a copy of EmployeeCreateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeCreateModelCopyWith<EmployeeCreateModel> get copyWith => _$EmployeeCreateModelCopyWithImpl<EmployeeCreateModel>(this as EmployeeCreateModel, _$identity);

  /// Serializes this EmployeeCreateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeCreateModel&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeCode,firstName,lastName,email,password,departmentId,role,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeCreateModel(employeeCode: $employeeCode, firstName: $firstName, lastName: $lastName, email: $email, password: $password, departmentId: $departmentId, role: $role, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class $EmployeeCreateModelCopyWith<$Res>  {
  factory $EmployeeCreateModelCopyWith(EmployeeCreateModel value, $Res Function(EmployeeCreateModel) _then) = _$EmployeeCreateModelCopyWithImpl;
@useResult
$Res call({
 String employeeCode, String firstName, String lastName, String email, String password, int departmentId,@RoleConverter() Role role, String? phoneNumber, int? managerId
});




}
/// @nodoc
class _$EmployeeCreateModelCopyWithImpl<$Res>
    implements $EmployeeCreateModelCopyWith<$Res> {
  _$EmployeeCreateModelCopyWithImpl(this._self, this._then);

  final EmployeeCreateModel _self;
  final $Res Function(EmployeeCreateModel) _then;

/// Create a copy of EmployeeCreateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeCode = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? password = null,Object? departmentId = null,Object? role = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_self.copyWith(
employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeCreateModel].
extension EmployeeCreateModelPatterns on EmployeeCreateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeCreateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeCreateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeCreateModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeCreateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeCreateModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeCreateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId, @RoleConverter()  Role role,  String? phoneNumber,  int? managerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeCreateModel() when $default != null:
return $default(_that.employeeCode,_that.firstName,_that.lastName,_that.email,_that.password,_that.departmentId,_that.role,_that.phoneNumber,_that.managerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId, @RoleConverter()  Role role,  String? phoneNumber,  int? managerId)  $default,) {final _that = this;
switch (_that) {
case _EmployeeCreateModel():
return $default(_that.employeeCode,_that.firstName,_that.lastName,_that.email,_that.password,_that.departmentId,_that.role,_that.phoneNumber,_that.managerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId, @RoleConverter()  Role role,  String? phoneNumber,  int? managerId)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeCreateModel() when $default != null:
return $default(_that.employeeCode,_that.firstName,_that.lastName,_that.email,_that.password,_that.departmentId,_that.role,_that.phoneNumber,_that.managerId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _EmployeeCreateModel extends EmployeeCreateModel {
  const _EmployeeCreateModel({required this.employeeCode, required this.firstName, required this.lastName, required this.email, required this.password, required this.departmentId, @RoleConverter() required this.role, this.phoneNumber, this.managerId}): super._();
  factory _EmployeeCreateModel.fromJson(Map<String, dynamic> json) => _$EmployeeCreateModelFromJson(json);

@override final  String employeeCode;
@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  String password;
@override final  int departmentId;
@override@RoleConverter() final  Role role;
@override final  String? phoneNumber;
@override final  int? managerId;

/// Create a copy of EmployeeCreateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeCreateModelCopyWith<_EmployeeCreateModel> get copyWith => __$EmployeeCreateModelCopyWithImpl<_EmployeeCreateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeCreateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeCreateModel&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeCode,firstName,lastName,email,password,departmentId,role,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeCreateModel(employeeCode: $employeeCode, firstName: $firstName, lastName: $lastName, email: $email, password: $password, departmentId: $departmentId, role: $role, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class _$EmployeeCreateModelCopyWith<$Res> implements $EmployeeCreateModelCopyWith<$Res> {
  factory _$EmployeeCreateModelCopyWith(_EmployeeCreateModel value, $Res Function(_EmployeeCreateModel) _then) = __$EmployeeCreateModelCopyWithImpl;
@override @useResult
$Res call({
 String employeeCode, String firstName, String lastName, String email, String password, int departmentId,@RoleConverter() Role role, String? phoneNumber, int? managerId
});




}
/// @nodoc
class __$EmployeeCreateModelCopyWithImpl<$Res>
    implements _$EmployeeCreateModelCopyWith<$Res> {
  __$EmployeeCreateModelCopyWithImpl(this._self, this._then);

  final _EmployeeCreateModel _self;
  final $Res Function(_EmployeeCreateModel) _then;

/// Create a copy of EmployeeCreateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeCode = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? password = null,Object? departmentId = null,Object? role = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_EmployeeCreateModel(
employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$EmployeeUpdateModel {

 String get firstName; String get lastName; String get email; int get departmentId;@RoleConverter() Role get role; bool get isActive; String? get phoneNumber; int? get managerId;
/// Create a copy of EmployeeUpdateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeUpdateModelCopyWith<EmployeeUpdateModel> get copyWith => _$EmployeeUpdateModelCopyWithImpl<EmployeeUpdateModel>(this as EmployeeUpdateModel, _$identity);

  /// Serializes this EmployeeUpdateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeUpdateModel&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,departmentId,role,isActive,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeUpdateModel(firstName: $firstName, lastName: $lastName, email: $email, departmentId: $departmentId, role: $role, isActive: $isActive, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class $EmployeeUpdateModelCopyWith<$Res>  {
  factory $EmployeeUpdateModelCopyWith(EmployeeUpdateModel value, $Res Function(EmployeeUpdateModel) _then) = _$EmployeeUpdateModelCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String email, int departmentId,@RoleConverter() Role role, bool isActive, String? phoneNumber, int? managerId
});




}
/// @nodoc
class _$EmployeeUpdateModelCopyWithImpl<$Res>
    implements $EmployeeUpdateModelCopyWith<$Res> {
  _$EmployeeUpdateModelCopyWithImpl(this._self, this._then);

  final EmployeeUpdateModel _self;
  final $Res Function(EmployeeUpdateModel) _then;

/// Create a copy of EmployeeUpdateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? departmentId = null,Object? role = null,Object? isActive = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeUpdateModel].
extension EmployeeUpdateModelPatterns on EmployeeUpdateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeUpdateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeUpdateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeUpdateModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeUpdateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeUpdateModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeUpdateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  int departmentId, @RoleConverter()  Role role,  bool isActive,  String? phoneNumber,  int? managerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeUpdateModel() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.departmentId,_that.role,_that.isActive,_that.phoneNumber,_that.managerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  int departmentId, @RoleConverter()  Role role,  bool isActive,  String? phoneNumber,  int? managerId)  $default,) {final _that = this;
switch (_that) {
case _EmployeeUpdateModel():
return $default(_that.firstName,_that.lastName,_that.email,_that.departmentId,_that.role,_that.isActive,_that.phoneNumber,_that.managerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String email,  int departmentId, @RoleConverter()  Role role,  bool isActive,  String? phoneNumber,  int? managerId)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeUpdateModel() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.departmentId,_that.role,_that.isActive,_that.phoneNumber,_that.managerId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _EmployeeUpdateModel extends EmployeeUpdateModel {
  const _EmployeeUpdateModel({required this.firstName, required this.lastName, required this.email, required this.departmentId, @RoleConverter() required this.role, required this.isActive, this.phoneNumber, this.managerId}): super._();
  factory _EmployeeUpdateModel.fromJson(Map<String, dynamic> json) => _$EmployeeUpdateModelFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  int departmentId;
@override@RoleConverter() final  Role role;
@override final  bool isActive;
@override final  String? phoneNumber;
@override final  int? managerId;

/// Create a copy of EmployeeUpdateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeUpdateModelCopyWith<_EmployeeUpdateModel> get copyWith => __$EmployeeUpdateModelCopyWithImpl<_EmployeeUpdateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeUpdateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeUpdateModel&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,departmentId,role,isActive,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeUpdateModel(firstName: $firstName, lastName: $lastName, email: $email, departmentId: $departmentId, role: $role, isActive: $isActive, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class _$EmployeeUpdateModelCopyWith<$Res> implements $EmployeeUpdateModelCopyWith<$Res> {
  factory _$EmployeeUpdateModelCopyWith(_EmployeeUpdateModel value, $Res Function(_EmployeeUpdateModel) _then) = __$EmployeeUpdateModelCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String email, int departmentId,@RoleConverter() Role role, bool isActive, String? phoneNumber, int? managerId
});




}
/// @nodoc
class __$EmployeeUpdateModelCopyWithImpl<$Res>
    implements _$EmployeeUpdateModelCopyWith<$Res> {
  __$EmployeeUpdateModelCopyWithImpl(this._self, this._then);

  final _EmployeeUpdateModel _self;
  final $Res Function(_EmployeeUpdateModel) _then;

/// Create a copy of EmployeeUpdateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? departmentId = null,Object? role = null,Object? isActive = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_EmployeeUpdateModel(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,managerId: freezed == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
