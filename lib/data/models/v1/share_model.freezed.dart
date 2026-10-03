// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SharedTicketModel {

 String get sharedTicketId;/// 수령 당시 일련번호 — 'ARD-4F9K-2Q71'.
 String get serial;/// 원본 티켓 참조(소유자 uid 는 담지 않는다).
 EntryRef get source; String get recipientUid;/// 표시 번호 — 'WT-2607-0002-S2'.
 String get code; String get businessDate; String get clubId; String get clubName; String get tableName; int get people; SharedTicketStatus get status; DateTime? get enteredAt; int get reentryCount;/// 원본이 취소돼 사라진 경우 — 'sourceCancelled'(RSV-102).
 String get deletedReason; DateTime get createdAt;
/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedTicketModelCopyWith<SharedTicketModel> get copyWith => _$SharedTicketModelCopyWithImpl<SharedTicketModel>(this as SharedTicketModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedTicketModel&&(identical(other.sharedTicketId, sharedTicketId) || other.sharedTicketId == sharedTicketId)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.source, source) || other.source == source)&&(identical(other.recipientUid, recipientUid) || other.recipientUid == recipientUid)&&(identical(other.code, code) || other.code == code)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.people, people) || other.people == people)&&(identical(other.status, status) || other.status == status)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.deletedReason, deletedReason) || other.deletedReason == deletedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,sharedTicketId,serial,source,recipientUid,code,businessDate,clubId,clubName,tableName,people,status,enteredAt,reentryCount,deletedReason,createdAt);

@override
String toString() {
  return 'SharedTicketModel(sharedTicketId: $sharedTicketId, serial: $serial, source: $source, recipientUid: $recipientUid, code: $code, businessDate: $businessDate, clubId: $clubId, clubName: $clubName, tableName: $tableName, people: $people, status: $status, enteredAt: $enteredAt, reentryCount: $reentryCount, deletedReason: $deletedReason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SharedTicketModelCopyWith<$Res>  {
  factory $SharedTicketModelCopyWith(SharedTicketModel value, $Res Function(SharedTicketModel) _then) = _$SharedTicketModelCopyWithImpl;
@useResult
$Res call({
 String sharedTicketId, String serial, EntryRef source, String recipientUid, String code, String businessDate, String clubId, String clubName, String tableName, int people, SharedTicketStatus status, DateTime? enteredAt, int reentryCount, String deletedReason, DateTime createdAt
});


$EntryRefCopyWith<$Res> get source;

}
/// @nodoc
class _$SharedTicketModelCopyWithImpl<$Res>
    implements $SharedTicketModelCopyWith<$Res> {
  _$SharedTicketModelCopyWithImpl(this._self, this._then);

  final SharedTicketModel _self;
  final $Res Function(SharedTicketModel) _then;

/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sharedTicketId = null,Object? serial = null,Object? source = null,Object? recipientUid = null,Object? code = null,Object? businessDate = null,Object? clubId = null,Object? clubName = null,Object? tableName = null,Object? people = null,Object? status = null,Object? enteredAt = freezed,Object? reentryCount = null,Object? deletedReason = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
sharedTicketId: null == sharedTicketId ? _self.sharedTicketId : sharedTicketId // ignore: cast_nullable_to_non_nullable
as String,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as EntryRef,recipientUid: null == recipientUid ? _self.recipientUid : recipientUid // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SharedTicketStatus,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,deletedReason: null == deletedReason ? _self.deletedReason : deletedReason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get source {
  
  return $EntryRefCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [SharedTicketModel].
extension SharedTicketModelPatterns on SharedTicketModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedTicketModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedTicketModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedTicketModel value)  $default,){
final _that = this;
switch (_that) {
case _SharedTicketModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedTicketModel value)?  $default,){
final _that = this;
switch (_that) {
case _SharedTicketModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sharedTicketId,  String serial,  EntryRef source,  String recipientUid,  String code,  String businessDate,  String clubId,  String clubName,  String tableName,  int people,  SharedTicketStatus status,  DateTime? enteredAt,  int reentryCount,  String deletedReason,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedTicketModel() when $default != null:
return $default(_that.sharedTicketId,_that.serial,_that.source,_that.recipientUid,_that.code,_that.businessDate,_that.clubId,_that.clubName,_that.tableName,_that.people,_that.status,_that.enteredAt,_that.reentryCount,_that.deletedReason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sharedTicketId,  String serial,  EntryRef source,  String recipientUid,  String code,  String businessDate,  String clubId,  String clubName,  String tableName,  int people,  SharedTicketStatus status,  DateTime? enteredAt,  int reentryCount,  String deletedReason,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SharedTicketModel():
return $default(_that.sharedTicketId,_that.serial,_that.source,_that.recipientUid,_that.code,_that.businessDate,_that.clubId,_that.clubName,_that.tableName,_that.people,_that.status,_that.enteredAt,_that.reentryCount,_that.deletedReason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sharedTicketId,  String serial,  EntryRef source,  String recipientUid,  String code,  String businessDate,  String clubId,  String clubName,  String tableName,  int people,  SharedTicketStatus status,  DateTime? enteredAt,  int reentryCount,  String deletedReason,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SharedTicketModel() when $default != null:
return $default(_that.sharedTicketId,_that.serial,_that.source,_that.recipientUid,_that.code,_that.businessDate,_that.clubId,_that.clubName,_that.tableName,_that.people,_that.status,_that.enteredAt,_that.reentryCount,_that.deletedReason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _SharedTicketModel extends SharedTicketModel {
  const _SharedTicketModel({required this.sharedTicketId, required this.serial, this.source = const EntryRef(), required this.recipientUid, this.code = '', required this.businessDate, this.clubId = '', this.clubName = '', this.tableName = '', this.people = 0, this.status = SharedTicketStatus.unknown, this.enteredAt, this.reentryCount = 0, this.deletedReason = '', required this.createdAt}): super._();
  

@override final  String sharedTicketId;
/// 수령 당시 일련번호 — 'ARD-4F9K-2Q71'.
@override final  String serial;
/// 원본 티켓 참조(소유자 uid 는 담지 않는다).
@override@JsonKey() final  EntryRef source;
@override final  String recipientUid;
/// 표시 번호 — 'WT-2607-0002-S2'.
@override@JsonKey() final  String code;
@override final  String businessDate;
@override@JsonKey() final  String clubId;
@override@JsonKey() final  String clubName;
@override@JsonKey() final  String tableName;
@override@JsonKey() final  int people;
@override@JsonKey() final  SharedTicketStatus status;
@override final  DateTime? enteredAt;
@override@JsonKey() final  int reentryCount;
/// 원본이 취소돼 사라진 경우 — 'sourceCancelled'(RSV-102).
@override@JsonKey() final  String deletedReason;
@override final  DateTime createdAt;

/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedTicketModelCopyWith<_SharedTicketModel> get copyWith => __$SharedTicketModelCopyWithImpl<_SharedTicketModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedTicketModel&&(identical(other.sharedTicketId, sharedTicketId) || other.sharedTicketId == sharedTicketId)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.source, source) || other.source == source)&&(identical(other.recipientUid, recipientUid) || other.recipientUid == recipientUid)&&(identical(other.code, code) || other.code == code)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.people, people) || other.people == people)&&(identical(other.status, status) || other.status == status)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.deletedReason, deletedReason) || other.deletedReason == deletedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,sharedTicketId,serial,source,recipientUid,code,businessDate,clubId,clubName,tableName,people,status,enteredAt,reentryCount,deletedReason,createdAt);

@override
String toString() {
  return 'SharedTicketModel(sharedTicketId: $sharedTicketId, serial: $serial, source: $source, recipientUid: $recipientUid, code: $code, businessDate: $businessDate, clubId: $clubId, clubName: $clubName, tableName: $tableName, people: $people, status: $status, enteredAt: $enteredAt, reentryCount: $reentryCount, deletedReason: $deletedReason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SharedTicketModelCopyWith<$Res> implements $SharedTicketModelCopyWith<$Res> {
  factory _$SharedTicketModelCopyWith(_SharedTicketModel value, $Res Function(_SharedTicketModel) _then) = __$SharedTicketModelCopyWithImpl;
@override @useResult
$Res call({
 String sharedTicketId, String serial, EntryRef source, String recipientUid, String code, String businessDate, String clubId, String clubName, String tableName, int people, SharedTicketStatus status, DateTime? enteredAt, int reentryCount, String deletedReason, DateTime createdAt
});


@override $EntryRefCopyWith<$Res> get source;

}
/// @nodoc
class __$SharedTicketModelCopyWithImpl<$Res>
    implements _$SharedTicketModelCopyWith<$Res> {
  __$SharedTicketModelCopyWithImpl(this._self, this._then);

  final _SharedTicketModel _self;
  final $Res Function(_SharedTicketModel) _then;

/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sharedTicketId = null,Object? serial = null,Object? source = null,Object? recipientUid = null,Object? code = null,Object? businessDate = null,Object? clubId = null,Object? clubName = null,Object? tableName = null,Object? people = null,Object? status = null,Object? enteredAt = freezed,Object? reentryCount = null,Object? deletedReason = null,Object? createdAt = null,}) {
  return _then(_SharedTicketModel(
sharedTicketId: null == sharedTicketId ? _self.sharedTicketId : sharedTicketId // ignore: cast_nullable_to_non_nullable
as String,serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as EntryRef,recipientUid: null == recipientUid ? _self.recipientUid : recipientUid // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SharedTicketStatus,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,deletedReason: null == deletedReason ? _self.deletedReason : deletedReason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SharedTicketModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get source {
  
  return $EntryRefCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

/// @nodoc
mixin _$SharePreviewModel {

 String get serial; String get clubName;/// 'YYYYMMDD'.
 String get date; DateTime? get enteredAt; int get people; String get tableName; ShareLinkStatus get status; EntryRefType get ticketType;/// 남은 시도 횟수. 0 이면 잠김.
 int get remainAttempts;/// 5회 실패 시 30분 잠금이 풀리는 시각.
 DateTime? get lockedUntil;
/// Create a copy of SharePreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharePreviewModelCopyWith<SharePreviewModel> get copyWith => _$SharePreviewModelCopyWithImpl<SharePreviewModel>(this as SharePreviewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharePreviewModel&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.date, date) || other.date == date)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.status, status) || other.status == status)&&(identical(other.ticketType, ticketType) || other.ticketType == ticketType)&&(identical(other.remainAttempts, remainAttempts) || other.remainAttempts == remainAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,serial,clubName,date,enteredAt,people,tableName,status,ticketType,remainAttempts,lockedUntil);

@override
String toString() {
  return 'SharePreviewModel(serial: $serial, clubName: $clubName, date: $date, enteredAt: $enteredAt, people: $people, tableName: $tableName, status: $status, ticketType: $ticketType, remainAttempts: $remainAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class $SharePreviewModelCopyWith<$Res>  {
  factory $SharePreviewModelCopyWith(SharePreviewModel value, $Res Function(SharePreviewModel) _then) = _$SharePreviewModelCopyWithImpl;
@useResult
$Res call({
 String serial, String clubName, String date, DateTime? enteredAt, int people, String tableName, ShareLinkStatus status, EntryRefType ticketType, int remainAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class _$SharePreviewModelCopyWithImpl<$Res>
    implements $SharePreviewModelCopyWith<$Res> {
  _$SharePreviewModelCopyWithImpl(this._self, this._then);

  final SharePreviewModel _self;
  final $Res Function(SharePreviewModel) _then;

/// Create a copy of SharePreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serial = null,Object? clubName = null,Object? date = null,Object? enteredAt = freezed,Object? people = null,Object? tableName = null,Object? status = null,Object? ticketType = null,Object? remainAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_self.copyWith(
serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShareLinkStatus,ticketType: null == ticketType ? _self.ticketType : ticketType // ignore: cast_nullable_to_non_nullable
as EntryRefType,remainAttempts: null == remainAttempts ? _self.remainAttempts : remainAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharePreviewModel].
extension SharePreviewModelPatterns on SharePreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharePreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharePreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharePreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _SharePreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharePreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _SharePreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serial,  String clubName,  String date,  DateTime? enteredAt,  int people,  String tableName,  ShareLinkStatus status,  EntryRefType ticketType,  int remainAttempts,  DateTime? lockedUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharePreviewModel() when $default != null:
return $default(_that.serial,_that.clubName,_that.date,_that.enteredAt,_that.people,_that.tableName,_that.status,_that.ticketType,_that.remainAttempts,_that.lockedUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serial,  String clubName,  String date,  DateTime? enteredAt,  int people,  String tableName,  ShareLinkStatus status,  EntryRefType ticketType,  int remainAttempts,  DateTime? lockedUntil)  $default,) {final _that = this;
switch (_that) {
case _SharePreviewModel():
return $default(_that.serial,_that.clubName,_that.date,_that.enteredAt,_that.people,_that.tableName,_that.status,_that.ticketType,_that.remainAttempts,_that.lockedUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serial,  String clubName,  String date,  DateTime? enteredAt,  int people,  String tableName,  ShareLinkStatus status,  EntryRefType ticketType,  int remainAttempts,  DateTime? lockedUntil)?  $default,) {final _that = this;
switch (_that) {
case _SharePreviewModel() when $default != null:
return $default(_that.serial,_that.clubName,_that.date,_that.enteredAt,_that.people,_that.tableName,_that.status,_that.ticketType,_that.remainAttempts,_that.lockedUntil);case _:
  return null;

}
}

}

/// @nodoc


class _SharePreviewModel extends SharePreviewModel {
  const _SharePreviewModel({required this.serial, this.clubName = '', this.date = '', this.enteredAt, this.people = 0, this.tableName = '', this.status = ShareLinkStatus.unknown, this.ticketType = EntryRefType.unknown, this.remainAttempts = 5, this.lockedUntil}): super._();
  

@override final  String serial;
@override@JsonKey() final  String clubName;
/// 'YYYYMMDD'.
@override@JsonKey() final  String date;
@override final  DateTime? enteredAt;
@override@JsonKey() final  int people;
@override@JsonKey() final  String tableName;
@override@JsonKey() final  ShareLinkStatus status;
@override@JsonKey() final  EntryRefType ticketType;
/// 남은 시도 횟수. 0 이면 잠김.
@override@JsonKey() final  int remainAttempts;
/// 5회 실패 시 30분 잠금이 풀리는 시각.
@override final  DateTime? lockedUntil;

/// Create a copy of SharePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharePreviewModelCopyWith<_SharePreviewModel> get copyWith => __$SharePreviewModelCopyWithImpl<_SharePreviewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharePreviewModel&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.date, date) || other.date == date)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.status, status) || other.status == status)&&(identical(other.ticketType, ticketType) || other.ticketType == ticketType)&&(identical(other.remainAttempts, remainAttempts) || other.remainAttempts == remainAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,serial,clubName,date,enteredAt,people,tableName,status,ticketType,remainAttempts,lockedUntil);

@override
String toString() {
  return 'SharePreviewModel(serial: $serial, clubName: $clubName, date: $date, enteredAt: $enteredAt, people: $people, tableName: $tableName, status: $status, ticketType: $ticketType, remainAttempts: $remainAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class _$SharePreviewModelCopyWith<$Res> implements $SharePreviewModelCopyWith<$Res> {
  factory _$SharePreviewModelCopyWith(_SharePreviewModel value, $Res Function(_SharePreviewModel) _then) = __$SharePreviewModelCopyWithImpl;
@override @useResult
$Res call({
 String serial, String clubName, String date, DateTime? enteredAt, int people, String tableName, ShareLinkStatus status, EntryRefType ticketType, int remainAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class __$SharePreviewModelCopyWithImpl<$Res>
    implements _$SharePreviewModelCopyWith<$Res> {
  __$SharePreviewModelCopyWithImpl(this._self, this._then);

  final _SharePreviewModel _self;
  final $Res Function(_SharePreviewModel) _then;

/// Create a copy of SharePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serial = null,Object? clubName = null,Object? date = null,Object? enteredAt = freezed,Object? people = null,Object? tableName = null,Object? status = null,Object? ticketType = null,Object? remainAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_SharePreviewModel(
serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShareLinkStatus,ticketType: null == ticketType ? _self.ticketType : ticketType // ignore: cast_nullable_to_non_nullable
as EntryRefType,remainAttempts: null == remainAttempts ? _self.remainAttempts : remainAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
