// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewEmployee {

 String get employeeCode; String get firstName; String get lastName; String get email; String get password; int get departmentId; Role get role; String? get phoneNumber; int? get managerId;
/// Create a copy of NewEmployee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewEmployeeCopyWith<NewEmployee> get copyWith => _$NewEmployeeCopyWithImpl<NewEmployee>(this as NewEmployee, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewEmployee&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}


@override
int get hashCode => Object.hash(runtimeType,employeeCode,firstName,lastName,email,password,departmentId,role,phoneNumber,managerId);

@override
String toString() {
  return 'NewEmployee(employeeCode: $employeeCode, firstName: $firstName, lastName: $lastName, email: $email, password: $password, departmentId: $departmentId, role: $role, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class $NewEmployeeCopyWith<$Res>  {
  factory $NewEmployeeCopyWith(NewEmployee value, $Res Function(NewEmployee) _then) = _$NewEmployeeCopyWithImpl;
@useResult
$Res call({
 String employeeCode, String firstName, String lastName, String email, String password, int departmentId, Role role, String? phoneNumber, int? managerId
});




}
/// @nodoc
class _$NewEmployeeCopyWithImpl<$Res>
    implements $NewEmployeeCopyWith<$Res> {
  _$NewEmployeeCopyWithImpl(this._self, this._then);

  final NewEmployee _self;
  final $Res Function(NewEmployee) _then;

/// Create a copy of NewEmployee
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


/// Adds pattern-matching-related methods to [NewEmployee].
extension NewEmployeePatterns on NewEmployee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewEmployee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewEmployee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewEmployee value)  $default,){
final _that = this;
switch (_that) {
case _NewEmployee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewEmployee value)?  $default,){
final _that = this;
switch (_that) {
case _NewEmployee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId,  Role role,  String? phoneNumber,  int? managerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewEmployee() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId,  Role role,  String? phoneNumber,  int? managerId)  $default,) {final _that = this;
switch (_that) {
case _NewEmployee():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String employeeCode,  String firstName,  String lastName,  String email,  String password,  int departmentId,  Role role,  String? phoneNumber,  int? managerId)?  $default,) {final _that = this;
switch (_that) {
case _NewEmployee() when $default != null:
return $default(_that.employeeCode,_that.firstName,_that.lastName,_that.email,_that.password,_that.departmentId,_that.role,_that.phoneNumber,_that.managerId);case _:
  return null;

}
}

}

/// @nodoc


class _NewEmployee extends NewEmployee {
  const _NewEmployee({required this.employeeCode, required this.firstName, required this.lastName, required this.email, required this.password, required this.departmentId, required this.role, this.phoneNumber, this.managerId}): super._();
  

@override final  String employeeCode;
@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  String password;
@override final  int departmentId;
@override final  Role role;
@override final  String? phoneNumber;
@override final  int? managerId;

/// Create a copy of NewEmployee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewEmployeeCopyWith<_NewEmployee> get copyWith => __$NewEmployeeCopyWithImpl<_NewEmployee>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewEmployee&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}


@override
int get hashCode => Object.hash(runtimeType,employeeCode,firstName,lastName,email,password,departmentId,role,phoneNumber,managerId);

@override
String toString() {
  return 'NewEmployee(employeeCode: $employeeCode, firstName: $firstName, lastName: $lastName, email: $email, password: $password, departmentId: $departmentId, role: $role, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class _$NewEmployeeCopyWith<$Res> implements $NewEmployeeCopyWith<$Res> {
  factory _$NewEmployeeCopyWith(_NewEmployee value, $Res Function(_NewEmployee) _then) = __$NewEmployeeCopyWithImpl;
@override @useResult
$Res call({
 String employeeCode, String firstName, String lastName, String email, String password, int departmentId, Role role, String? phoneNumber, int? managerId
});




}
/// @nodoc
class __$NewEmployeeCopyWithImpl<$Res>
    implements _$NewEmployeeCopyWith<$Res> {
  __$NewEmployeeCopyWithImpl(this._self, this._then);

  final _NewEmployee _self;
  final $Res Function(_NewEmployee) _then;

/// Create a copy of NewEmployee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeCode = null,Object? firstName = null,Object? lastName = null,Object? email = null,Object? password = null,Object? departmentId = null,Object? role = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_NewEmployee(
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
mixin _$EmployeeEdit {

 String get firstName; String get lastName; String get email; int get departmentId; Role get role; bool get isActive; String? get phoneNumber; int? get managerId;
/// Create a copy of EmployeeEdit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeEditCopyWith<EmployeeEdit> get copyWith => _$EmployeeEditCopyWithImpl<EmployeeEdit>(this as EmployeeEdit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeEdit&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,departmentId,role,isActive,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeEdit(firstName: $firstName, lastName: $lastName, email: $email, departmentId: $departmentId, role: $role, isActive: $isActive, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class $EmployeeEditCopyWith<$Res>  {
  factory $EmployeeEditCopyWith(EmployeeEdit value, $Res Function(EmployeeEdit) _then) = _$EmployeeEditCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String email, int departmentId, Role role, bool isActive, String? phoneNumber, int? managerId
});




}
/// @nodoc
class _$EmployeeEditCopyWithImpl<$Res>
    implements $EmployeeEditCopyWith<$Res> {
  _$EmployeeEditCopyWithImpl(this._self, this._then);

  final EmployeeEdit _self;
  final $Res Function(EmployeeEdit) _then;

/// Create a copy of EmployeeEdit
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


/// Adds pattern-matching-related methods to [EmployeeEdit].
extension EmployeeEditPatterns on EmployeeEdit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeEdit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeEdit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeEdit value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeEdit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeEdit value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeEdit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  int departmentId,  Role role,  bool isActive,  String? phoneNumber,  int? managerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeEdit() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String email,  int departmentId,  Role role,  bool isActive,  String? phoneNumber,  int? managerId)  $default,) {final _that = this;
switch (_that) {
case _EmployeeEdit():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String email,  int departmentId,  Role role,  bool isActive,  String? phoneNumber,  int? managerId)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeEdit() when $default != null:
return $default(_that.firstName,_that.lastName,_that.email,_that.departmentId,_that.role,_that.isActive,_that.phoneNumber,_that.managerId);case _:
  return null;

}
}

}

/// @nodoc


class _EmployeeEdit extends EmployeeEdit {
  const _EmployeeEdit({required this.firstName, required this.lastName, required this.email, required this.departmentId, required this.role, required this.isActive, this.phoneNumber, this.managerId}): super._();
  

@override final  String firstName;
@override final  String lastName;
@override final  String email;
@override final  int departmentId;
@override final  Role role;
@override final  bool isActive;
@override final  String? phoneNumber;
@override final  int? managerId;

/// Create a copy of EmployeeEdit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeEditCopyWith<_EmployeeEdit> get copyWith => __$EmployeeEditCopyWithImpl<_EmployeeEdit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeEdit&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.managerId, managerId) || other.managerId == managerId));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,email,departmentId,role,isActive,phoneNumber,managerId);

@override
String toString() {
  return 'EmployeeEdit(firstName: $firstName, lastName: $lastName, email: $email, departmentId: $departmentId, role: $role, isActive: $isActive, phoneNumber: $phoneNumber, managerId: $managerId)';
}


}

/// @nodoc
abstract mixin class _$EmployeeEditCopyWith<$Res> implements $EmployeeEditCopyWith<$Res> {
  factory _$EmployeeEditCopyWith(_EmployeeEdit value, $Res Function(_EmployeeEdit) _then) = __$EmployeeEditCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String email, int departmentId, Role role, bool isActive, String? phoneNumber, int? managerId
});




}
/// @nodoc
class __$EmployeeEditCopyWithImpl<$Res>
    implements _$EmployeeEditCopyWith<$Res> {
  __$EmployeeEditCopyWithImpl(this._self, this._then);

  final _EmployeeEdit _self;
  final $Res Function(_EmployeeEdit) _then;

/// Create a copy of EmployeeEdit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? email = null,Object? departmentId = null,Object? role = null,Object? isActive = null,Object? phoneNumber = freezed,Object? managerId = freezed,}) {
  return _then(_EmployeeEdit(
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
