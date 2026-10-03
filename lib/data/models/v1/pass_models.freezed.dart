// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pass_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryItemModel {

 String get itemId; HistoryType get type; String get clubId; String get clubName; String get clubThumbnailUrl;/// 원본 경로 — 남아 있을 때만 상세로 이동한다.
 String get refPath;/// 종료 상태 — entered · cancelled · noShow · done · rejected · storeCancelled.
 String get status;/// 방문 · 주문 시각(정렬 키).
 DateTime get visitedAt; int get people;/// 주문 요약 — 'HARD SET A 외 1건'.
 String get summary; TicketPaymentSummary? get payment; TicketRefundSummary? get refund; ReviewPrompt get reviewPrompt;/// visitedAt + 14일. [임시_차선책] 설계 6-0 리뷰 작성 기간.
 DateTime? get reviewDeadline; String get reviewId;/// 사용자 측 숨김(내역 삭제).
 bool get hiddenByUser;
/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryItemModelCopyWith<HistoryItemModel> get copyWith => _$HistoryItemModelCopyWithImpl<HistoryItemModel>(this as HistoryItemModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryItemModel&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.type, type) || other.type == type)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.clubThumbnailUrl, clubThumbnailUrl) || other.clubThumbnailUrl == clubThumbnailUrl)&&(identical(other.refPath, refPath) || other.refPath == refPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.reviewPrompt, reviewPrompt) || other.reviewPrompt == reviewPrompt)&&(identical(other.reviewDeadline, reviewDeadline) || other.reviewDeadline == reviewDeadline)&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,type,clubId,clubName,clubThumbnailUrl,refPath,status,visitedAt,people,summary,payment,refund,reviewPrompt,reviewDeadline,reviewId,hiddenByUser);

@override
String toString() {
  return 'HistoryItemModel(itemId: $itemId, type: $type, clubId: $clubId, clubName: $clubName, clubThumbnailUrl: $clubThumbnailUrl, refPath: $refPath, status: $status, visitedAt: $visitedAt, people: $people, summary: $summary, payment: $payment, refund: $refund, reviewPrompt: $reviewPrompt, reviewDeadline: $reviewDeadline, reviewId: $reviewId, hiddenByUser: $hiddenByUser)';
}


}

/// @nodoc
abstract mixin class $HistoryItemModelCopyWith<$Res>  {
  factory $HistoryItemModelCopyWith(HistoryItemModel value, $Res Function(HistoryItemModel) _then) = _$HistoryItemModelCopyWithImpl;
@useResult
$Res call({
 String itemId, HistoryType type, String clubId, String clubName, String clubThumbnailUrl, String refPath, String status, DateTime visitedAt, int people, String summary, TicketPaymentSummary? payment, TicketRefundSummary? refund, ReviewPrompt reviewPrompt, DateTime? reviewDeadline, String reviewId, bool hiddenByUser
});


$TicketPaymentSummaryCopyWith<$Res>? get payment;$TicketRefundSummaryCopyWith<$Res>? get refund;

}
/// @nodoc
class _$HistoryItemModelCopyWithImpl<$Res>
    implements $HistoryItemModelCopyWith<$Res> {
  _$HistoryItemModelCopyWithImpl(this._self, this._then);

  final HistoryItemModel _self;
  final $Res Function(HistoryItemModel) _then;

/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? type = null,Object? clubId = null,Object? clubName = null,Object? clubThumbnailUrl = null,Object? refPath = null,Object? status = null,Object? visitedAt = null,Object? people = null,Object? summary = null,Object? payment = freezed,Object? refund = freezed,Object? reviewPrompt = null,Object? reviewDeadline = freezed,Object? reviewId = null,Object? hiddenByUser = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HistoryType,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,clubThumbnailUrl: null == clubThumbnailUrl ? _self.clubThumbnailUrl : clubThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,refPath: null == refPath ? _self.refPath : refPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,reviewPrompt: null == reviewPrompt ? _self.reviewPrompt : reviewPrompt // ignore: cast_nullable_to_non_nullable
as ReviewPrompt,reviewDeadline: freezed == reviewDeadline ? _self.reviewDeadline : reviewDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketPaymentSummaryCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $TicketPaymentSummaryCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketRefundSummaryCopyWith<$Res>? get refund {
    if (_self.refund == null) {
    return null;
  }

  return $TicketRefundSummaryCopyWith<$Res>(_self.refund!, (value) {
    return _then(_self.copyWith(refund: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryItemModel].
extension HistoryItemModelPatterns on HistoryItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryItemModel value)  $default,){
final _that = this;
switch (_that) {
case _HistoryItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  HistoryType type,  String clubId,  String clubName,  String clubThumbnailUrl,  String refPath,  String status,  DateTime visitedAt,  int people,  String summary,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  ReviewPrompt reviewPrompt,  DateTime? reviewDeadline,  String reviewId,  bool hiddenByUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryItemModel() when $default != null:
return $default(_that.itemId,_that.type,_that.clubId,_that.clubName,_that.clubThumbnailUrl,_that.refPath,_that.status,_that.visitedAt,_that.people,_that.summary,_that.payment,_that.refund,_that.reviewPrompt,_that.reviewDeadline,_that.reviewId,_that.hiddenByUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  HistoryType type,  String clubId,  String clubName,  String clubThumbnailUrl,  String refPath,  String status,  DateTime visitedAt,  int people,  String summary,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  ReviewPrompt reviewPrompt,  DateTime? reviewDeadline,  String reviewId,  bool hiddenByUser)  $default,) {final _that = this;
switch (_that) {
case _HistoryItemModel():
return $default(_that.itemId,_that.type,_that.clubId,_that.clubName,_that.clubThumbnailUrl,_that.refPath,_that.status,_that.visitedAt,_that.people,_that.summary,_that.payment,_that.refund,_that.reviewPrompt,_that.reviewDeadline,_that.reviewId,_that.hiddenByUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  HistoryType type,  String clubId,  String clubName,  String clubThumbnailUrl,  String refPath,  String status,  DateTime visitedAt,  int people,  String summary,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  ReviewPrompt reviewPrompt,  DateTime? reviewDeadline,  String reviewId,  bool hiddenByUser)?  $default,) {final _that = this;
switch (_that) {
case _HistoryItemModel() when $default != null:
return $default(_that.itemId,_that.type,_that.clubId,_that.clubName,_that.clubThumbnailUrl,_that.refPath,_that.status,_that.visitedAt,_that.people,_that.summary,_that.payment,_that.refund,_that.reviewPrompt,_that.reviewDeadline,_that.reviewId,_that.hiddenByUser);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryItemModel extends HistoryItemModel {
  const _HistoryItemModel({required this.itemId, this.type = HistoryType.unknown, required this.clubId, this.clubName = '', this.clubThumbnailUrl = '', this.refPath = '', this.status = '', required this.visitedAt, this.people = 0, this.summary = '', this.payment, this.refund, this.reviewPrompt = ReviewPrompt.unknown, this.reviewDeadline, this.reviewId = '', this.hiddenByUser = false}): super._();
  

@override final  String itemId;
@override@JsonKey() final  HistoryType type;
@override final  String clubId;
@override@JsonKey() final  String clubName;
@override@JsonKey() final  String clubThumbnailUrl;
/// 원본 경로 — 남아 있을 때만 상세로 이동한다.
@override@JsonKey() final  String refPath;
/// 종료 상태 — entered · cancelled · noShow · done · rejected · storeCancelled.
@override@JsonKey() final  String status;
/// 방문 · 주문 시각(정렬 키).
@override final  DateTime visitedAt;
@override@JsonKey() final  int people;
/// 주문 요약 — 'HARD SET A 외 1건'.
@override@JsonKey() final  String summary;
@override final  TicketPaymentSummary? payment;
@override final  TicketRefundSummary? refund;
@override@JsonKey() final  ReviewPrompt reviewPrompt;
/// visitedAt + 14일. [임시_차선책] 설계 6-0 리뷰 작성 기간.
@override final  DateTime? reviewDeadline;
@override@JsonKey() final  String reviewId;
/// 사용자 측 숨김(내역 삭제).
@override@JsonKey() final  bool hiddenByUser;

/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryItemModelCopyWith<_HistoryItemModel> get copyWith => __$HistoryItemModelCopyWithImpl<_HistoryItemModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryItemModel&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.type, type) || other.type == type)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.clubThumbnailUrl, clubThumbnailUrl) || other.clubThumbnailUrl == clubThumbnailUrl)&&(identical(other.refPath, refPath) || other.refPath == refPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.reviewPrompt, reviewPrompt) || other.reviewPrompt == reviewPrompt)&&(identical(other.reviewDeadline, reviewDeadline) || other.reviewDeadline == reviewDeadline)&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,type,clubId,clubName,clubThumbnailUrl,refPath,status,visitedAt,people,summary,payment,refund,reviewPrompt,reviewDeadline,reviewId,hiddenByUser);

@override
String toString() {
  return 'HistoryItemModel(itemId: $itemId, type: $type, clubId: $clubId, clubName: $clubName, clubThumbnailUrl: $clubThumbnailUrl, refPath: $refPath, status: $status, visitedAt: $visitedAt, people: $people, summary: $summary, payment: $payment, refund: $refund, reviewPrompt: $reviewPrompt, reviewDeadline: $reviewDeadline, reviewId: $reviewId, hiddenByUser: $hiddenByUser)';
}


}

/// @nodoc
abstract mixin class _$HistoryItemModelCopyWith<$Res> implements $HistoryItemModelCopyWith<$Res> {
  factory _$HistoryItemModelCopyWith(_HistoryItemModel value, $Res Function(_HistoryItemModel) _then) = __$HistoryItemModelCopyWithImpl;
@override @useResult
$Res call({
 String itemId, HistoryType type, String clubId, String clubName, String clubThumbnailUrl, String refPath, String status, DateTime visitedAt, int people, String summary, TicketPaymentSummary? payment, TicketRefundSummary? refund, ReviewPrompt reviewPrompt, DateTime? reviewDeadline, String reviewId, bool hiddenByUser
});


@override $TicketPaymentSummaryCopyWith<$Res>? get payment;@override $TicketRefundSummaryCopyWith<$Res>? get refund;

}
/// @nodoc
class __$HistoryItemModelCopyWithImpl<$Res>
    implements _$HistoryItemModelCopyWith<$Res> {
  __$HistoryItemModelCopyWithImpl(this._self, this._then);

  final _HistoryItemModel _self;
  final $Res Function(_HistoryItemModel) _then;

/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? type = null,Object? clubId = null,Object? clubName = null,Object? clubThumbnailUrl = null,Object? refPath = null,Object? status = null,Object? visitedAt = null,Object? people = null,Object? summary = null,Object? payment = freezed,Object? refund = freezed,Object? reviewPrompt = null,Object? reviewDeadline = freezed,Object? reviewId = null,Object? hiddenByUser = null,}) {
  return _then(_HistoryItemModel(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HistoryType,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,clubThumbnailUrl: null == clubThumbnailUrl ? _self.clubThumbnailUrl : clubThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,refPath: null == refPath ? _self.refPath : refPath // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,reviewPrompt: null == reviewPrompt ? _self.reviewPrompt : reviewPrompt // ignore: cast_nullable_to_non_nullable
as ReviewPrompt,reviewDeadline: freezed == reviewDeadline ? _self.reviewDeadline : reviewDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketPaymentSummaryCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $TicketPaymentSummaryCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}/// Create a copy of HistoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketRefundSummaryCopyWith<$Res>? get refund {
    if (_self.refund == null) {
    return null;
  }

  return $TicketRefundSummaryCopyWith<$Res>(_self.refund!, (value) {
    return _then(_self.copyWith(refund: value));
  });
}
}

/// @nodoc
mixin _$AppNotificationModel {

 String get notificationId;/// 10장 알림 유형 — 'waiting_called' 등.
 String get type; NotificationCategory get category; String get title; String get body;/// 탭 시 이동 — `{ route, clubId, ticketId }`.
 Map<String, String> get data; bool get read;/// 중복 발송 방지 키 — `type:targetId:occurrence`(문서 ID 와 같다).
 String get dedupeKey; DateTime get createdAt;
/// Create a copy of AppNotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationModelCopyWith<AppNotificationModel> get copyWith => _$AppNotificationModelCopyWithImpl<AppNotificationModel>(this as AppNotificationModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotificationModel&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.read, read) || other.read == read)&&(identical(other.dedupeKey, dedupeKey) || other.dedupeKey == dedupeKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,notificationId,type,category,title,body,const DeepCollectionEquality().hash(data),read,dedupeKey,createdAt);

@override
String toString() {
  return 'AppNotificationModel(notificationId: $notificationId, type: $type, category: $category, title: $title, body: $body, data: $data, read: $read, dedupeKey: $dedupeKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationModelCopyWith<$Res>  {
  factory $AppNotificationModelCopyWith(AppNotificationModel value, $Res Function(AppNotificationModel) _then) = _$AppNotificationModelCopyWithImpl;
@useResult
$Res call({
 String notificationId, String type, NotificationCategory category, String title, String body, Map<String, String> data, bool read, String dedupeKey, DateTime createdAt
});




}
/// @nodoc
class _$AppNotificationModelCopyWithImpl<$Res>
    implements $AppNotificationModelCopyWith<$Res> {
  _$AppNotificationModelCopyWithImpl(this._self, this._then);

  final AppNotificationModel _self;
  final $Res Function(AppNotificationModel) _then;

/// Create a copy of AppNotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = null,Object? type = null,Object? category = null,Object? title = null,Object? body = null,Object? data = null,Object? read = null,Object? dedupeKey = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NotificationCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,dedupeKey: null == dedupeKey ? _self.dedupeKey : dedupeKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotificationModel].
extension AppNotificationModelPatterns on AppNotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _AppNotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notificationId,  String type,  NotificationCategory category,  String title,  String body,  Map<String, String> data,  bool read,  String dedupeKey,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotificationModel() when $default != null:
return $default(_that.notificationId,_that.type,_that.category,_that.title,_that.body,_that.data,_that.read,_that.dedupeKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notificationId,  String type,  NotificationCategory category,  String title,  String body,  Map<String, String> data,  bool read,  String dedupeKey,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotificationModel():
return $default(_that.notificationId,_that.type,_that.category,_that.title,_that.body,_that.data,_that.read,_that.dedupeKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notificationId,  String type,  NotificationCategory category,  String title,  String body,  Map<String, String> data,  bool read,  String dedupeKey,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotificationModel() when $default != null:
return $default(_that.notificationId,_that.type,_that.category,_that.title,_that.body,_that.data,_that.read,_that.dedupeKey,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AppNotificationModel extends AppNotificationModel {
  const _AppNotificationModel({required this.notificationId, required this.type, this.category = NotificationCategory.unknown, required this.title, this.body = '', final  Map<String, String> data = const <String, String>{}, this.read = false, this.dedupeKey = '', required this.createdAt}): _data = data,super._();
  

@override final  String notificationId;
/// 10장 알림 유형 — 'waiting_called' 등.
@override final  String type;
@override@JsonKey() final  NotificationCategory category;
@override final  String title;
@override@JsonKey() final  String body;
/// 탭 시 이동 — `{ route, clubId, ticketId }`.
 final  Map<String, String> _data;
/// 탭 시 이동 — `{ route, clubId, ticketId }`.
@override@JsonKey() Map<String, String> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override@JsonKey() final  bool read;
/// 중복 발송 방지 키 — `type:targetId:occurrence`(문서 ID 와 같다).
@override@JsonKey() final  String dedupeKey;
@override final  DateTime createdAt;

/// Create a copy of AppNotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationModelCopyWith<_AppNotificationModel> get copyWith => __$AppNotificationModelCopyWithImpl<_AppNotificationModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotificationModel&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.read, read) || other.read == read)&&(identical(other.dedupeKey, dedupeKey) || other.dedupeKey == dedupeKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,notificationId,type,category,title,body,const DeepCollectionEquality().hash(_data),read,dedupeKey,createdAt);

@override
String toString() {
  return 'AppNotificationModel(notificationId: $notificationId, type: $type, category: $category, title: $title, body: $body, data: $data, read: $read, dedupeKey: $dedupeKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationModelCopyWith<$Res> implements $AppNotificationModelCopyWith<$Res> {
  factory _$AppNotificationModelCopyWith(_AppNotificationModel value, $Res Function(_AppNotificationModel) _then) = __$AppNotificationModelCopyWithImpl;
@override @useResult
$Res call({
 String notificationId, String type, NotificationCategory category, String title, String body, Map<String, String> data, bool read, String dedupeKey, DateTime createdAt
});




}
/// @nodoc
class __$AppNotificationModelCopyWithImpl<$Res>
    implements _$AppNotificationModelCopyWith<$Res> {
  __$AppNotificationModelCopyWithImpl(this._self, this._then);

  final _AppNotificationModel _self;
  final $Res Function(_AppNotificationModel) _then;

/// Create a copy of AppNotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = null,Object? type = null,Object? category = null,Object? title = null,Object? body = null,Object? data = null,Object? read = null,Object? dedupeKey = null,Object? createdAt = null,}) {
  return _then(_AppNotificationModel(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NotificationCategory,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,dedupeKey: null == dedupeKey ? _self.dedupeKey : dedupeKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$EntryQrToken {

 String get token;/// iat + 600초(10분). PASS-041 타이머가 이 값으로 센다.
 DateTime get expiresAt; DateTime get issuedAt;
/// Create a copy of EntryQrToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryQrTokenCopyWith<EntryQrToken> get copyWith => _$EntryQrTokenCopyWithImpl<EntryQrToken>(this as EntryQrToken, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryQrToken&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,expiresAt,issuedAt);

@override
String toString() {
  return 'EntryQrToken(token: $token, expiresAt: $expiresAt, issuedAt: $issuedAt)';
}


}

/// @nodoc
abstract mixin class $EntryQrTokenCopyWith<$Res>  {
  factory $EntryQrTokenCopyWith(EntryQrToken value, $Res Function(EntryQrToken) _then) = _$EntryQrTokenCopyWithImpl;
@useResult
$Res call({
 String token, DateTime expiresAt, DateTime issuedAt
});




}
/// @nodoc
class _$EntryQrTokenCopyWithImpl<$Res>
    implements $EntryQrTokenCopyWith<$Res> {
  _$EntryQrTokenCopyWithImpl(this._self, this._then);

  final EntryQrToken _self;
  final $Res Function(EntryQrToken) _then;

/// Create a copy of EntryQrToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? expiresAt = null,Object? issuedAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EntryQrToken].
extension EntryQrTokenPatterns on EntryQrToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntryQrToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntryQrToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntryQrToken value)  $default,){
final _that = this;
switch (_that) {
case _EntryQrToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntryQrToken value)?  $default,){
final _that = this;
switch (_that) {
case _EntryQrToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  DateTime expiresAt,  DateTime issuedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntryQrToken() when $default != null:
return $default(_that.token,_that.expiresAt,_that.issuedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  DateTime expiresAt,  DateTime issuedAt)  $default,) {final _that = this;
switch (_that) {
case _EntryQrToken():
return $default(_that.token,_that.expiresAt,_that.issuedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  DateTime expiresAt,  DateTime issuedAt)?  $default,) {final _that = this;
switch (_that) {
case _EntryQrToken() when $default != null:
return $default(_that.token,_that.expiresAt,_that.issuedAt);case _:
  return null;

}
}

}

/// @nodoc


class _EntryQrToken extends EntryQrToken {
  const _EntryQrToken({required this.token, required this.expiresAt, required this.issuedAt}): super._();
  

@override final  String token;
/// iat + 600초(10분). PASS-041 타이머가 이 값으로 센다.
@override final  DateTime expiresAt;
@override final  DateTime issuedAt;

/// Create a copy of EntryQrToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryQrTokenCopyWith<_EntryQrToken> get copyWith => __$EntryQrTokenCopyWithImpl<_EntryQrToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntryQrToken&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt));
}


@override
int get hashCode => Object.hash(runtimeType,token,expiresAt,issuedAt);

@override
String toString() {
  return 'EntryQrToken(token: $token, expiresAt: $expiresAt, issuedAt: $issuedAt)';
}


}

/// @nodoc
abstract mixin class _$EntryQrTokenCopyWith<$Res> implements $EntryQrTokenCopyWith<$Res> {
  factory _$EntryQrTokenCopyWith(_EntryQrToken value, $Res Function(_EntryQrToken) _then) = __$EntryQrTokenCopyWithImpl;
@override @useResult
$Res call({
 String token, DateTime expiresAt, DateTime issuedAt
});




}
/// @nodoc
class __$EntryQrTokenCopyWithImpl<$Res>
    implements _$EntryQrTokenCopyWith<$Res> {
  __$EntryQrTokenCopyWithImpl(this._self, this._then);

  final _EntryQrToken _self;
  final $Res Function(_EntryQrToken) _then;

/// Create a copy of EntryQrToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? expiresAt = null,Object? issuedAt = null,}) {
  return _then(_EntryQrToken(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$PolicyModel {

/// reservationRules · waitingRules · orderRules · privacyTerms · paymentTerms.
 String get policyId;/// 'YYYY-MM-DD'.
 String get version; String get title; String get body;
/// Create a copy of PolicyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PolicyModelCopyWith<PolicyModel> get copyWith => _$PolicyModelCopyWithImpl<PolicyModel>(this as PolicyModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PolicyModel&&(identical(other.policyId, policyId) || other.policyId == policyId)&&(identical(other.version, version) || other.version == version)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,policyId,version,title,body);

@override
String toString() {
  return 'PolicyModel(policyId: $policyId, version: $version, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $PolicyModelCopyWith<$Res>  {
  factory $PolicyModelCopyWith(PolicyModel value, $Res Function(PolicyModel) _then) = _$PolicyModelCopyWithImpl;
@useResult
$Res call({
 String policyId, String version, String title, String body
});




}
/// @nodoc
class _$PolicyModelCopyWithImpl<$Res>
    implements $PolicyModelCopyWith<$Res> {
  _$PolicyModelCopyWithImpl(this._self, this._then);

  final PolicyModel _self;
  final $Res Function(PolicyModel) _then;

/// Create a copy of PolicyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? policyId = null,Object? version = null,Object? title = null,Object? body = null,}) {
  return _then(_self.copyWith(
policyId: null == policyId ? _self.policyId : policyId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PolicyModel].
extension PolicyModelPatterns on PolicyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PolicyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PolicyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PolicyModel value)  $default,){
final _that = this;
switch (_that) {
case _PolicyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PolicyModel value)?  $default,){
final _that = this;
switch (_that) {
case _PolicyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String policyId,  String version,  String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PolicyModel() when $default != null:
return $default(_that.policyId,_that.version,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String policyId,  String version,  String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _PolicyModel():
return $default(_that.policyId,_that.version,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String policyId,  String version,  String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _PolicyModel() when $default != null:
return $default(_that.policyId,_that.version,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc


class _PolicyModel implements PolicyModel {
  const _PolicyModel({required this.policyId, this.version = '', this.title = '', this.body = ''});
  

/// reservationRules · waitingRules · orderRules · privacyTerms · paymentTerms.
@override final  String policyId;
/// 'YYYY-MM-DD'.
@override@JsonKey() final  String version;
@override@JsonKey() final  String title;
@override@JsonKey() final  String body;

/// Create a copy of PolicyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PolicyModelCopyWith<_PolicyModel> get copyWith => __$PolicyModelCopyWithImpl<_PolicyModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PolicyModel&&(identical(other.policyId, policyId) || other.policyId == policyId)&&(identical(other.version, version) || other.version == version)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,policyId,version,title,body);

@override
String toString() {
  return 'PolicyModel(policyId: $policyId, version: $version, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$PolicyModelCopyWith<$Res> implements $PolicyModelCopyWith<$Res> {
  factory _$PolicyModelCopyWith(_PolicyModel value, $Res Function(_PolicyModel) _then) = __$PolicyModelCopyWithImpl;
@override @useResult
$Res call({
 String policyId, String version, String title, String body
});




}
/// @nodoc
class __$PolicyModelCopyWithImpl<$Res>
    implements _$PolicyModelCopyWith<$Res> {
  __$PolicyModelCopyWithImpl(this._self, this._then);

  final _PolicyModel _self;
  final $Res Function(_PolicyModel) _then;

/// Create a copy of PolicyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? policyId = null,Object? version = null,Object? title = null,Object? body = null,}) {
  return _then(_PolicyModel(
policyId: null == policyId ? _self.policyId : policyId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
