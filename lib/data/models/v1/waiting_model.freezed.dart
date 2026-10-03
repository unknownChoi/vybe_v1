// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waiting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaitingModel {

 String get waitingId;/// ENTRY PASS 번호 — 'WT-2607-0005'. 사용자·관리자 표시 · 티켓 조회 키.
 String get code; String get clubId; String get clubName; String get uid;/// 영업일 'YYYYMMDD'.
 String get businessDate;/// 대기 번호(영업일 내 1부터).
 int get seq; int get people; WaitingStatus get status;/// 순서 미루기를 쓴 적이 있는지.
 bool get postponed; int get postponeCount;/// 입장비 스냅샷. `total == 0` 이면 입장비 없는 웨이팅.
 WaitingFee get fee; String get paymentId; TicketPaymentSummary? get payment; TicketRefundSummary? get refund; DateTime? get calledAt;/// 호출 +10분. 넘기면 noShow.
 DateTime? get callDeadline; DateTime? get enteredAt; int get reentryCount; DateTime? get lastReentryAt; NoShowReason get noShowReason; DateTime? get cancelledAt; CancelledBy get cancelledBy; String get cancelReason; TicketShareSummary? get share;/// 유의사항 동의 · 반경 500m 검증 결과(서버가 판정해 기록).
 bool get noticeAgreed; bool get locationChecked;/// noShow 티켓 '제거하기' — 사용자 측 숨김.
 bool get hiddenByUser;/// `issueEntryQr` 가 갱신. 재발급 10초 제한 비교용.
 DateTime? get qrIssuedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaitingModelCopyWith<WaitingModel> get copyWith => _$WaitingModelCopyWithImpl<WaitingModel>(this as WaitingModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaitingModel&&(identical(other.waitingId, waitingId) || other.waitingId == waitingId)&&(identical(other.code, code) || other.code == code)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.people, people) || other.people == people)&&(identical(other.status, status) || other.status == status)&&(identical(other.postponed, postponed) || other.postponed == postponed)&&(identical(other.postponeCount, postponeCount) || other.postponeCount == postponeCount)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt)&&(identical(other.callDeadline, callDeadline) || other.callDeadline == callDeadline)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.lastReentryAt, lastReentryAt) || other.lastReentryAt == lastReentryAt)&&(identical(other.noShowReason, noShowReason) || other.noShowReason == noShowReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.share, share) || other.share == share)&&(identical(other.noticeAgreed, noticeAgreed) || other.noticeAgreed == noticeAgreed)&&(identical(other.locationChecked, locationChecked) || other.locationChecked == locationChecked)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser)&&(identical(other.qrIssuedAt, qrIssuedAt) || other.qrIssuedAt == qrIssuedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,waitingId,code,clubId,clubName,uid,businessDate,seq,people,status,postponed,postponeCount,fee,paymentId,payment,refund,calledAt,callDeadline,enteredAt,reentryCount,lastReentryAt,noShowReason,cancelledAt,cancelledBy,cancelReason,share,noticeAgreed,locationChecked,hiddenByUser,qrIssuedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'WaitingModel(waitingId: $waitingId, code: $code, clubId: $clubId, clubName: $clubName, uid: $uid, businessDate: $businessDate, seq: $seq, people: $people, status: $status, postponed: $postponed, postponeCount: $postponeCount, fee: $fee, paymentId: $paymentId, payment: $payment, refund: $refund, calledAt: $calledAt, callDeadline: $callDeadline, enteredAt: $enteredAt, reentryCount: $reentryCount, lastReentryAt: $lastReentryAt, noShowReason: $noShowReason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, share: $share, noticeAgreed: $noticeAgreed, locationChecked: $locationChecked, hiddenByUser: $hiddenByUser, qrIssuedAt: $qrIssuedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WaitingModelCopyWith<$Res>  {
  factory $WaitingModelCopyWith(WaitingModel value, $Res Function(WaitingModel) _then) = _$WaitingModelCopyWithImpl;
@useResult
$Res call({
 String waitingId, String code, String clubId, String clubName, String uid, String businessDate, int seq, int people, WaitingStatus status, bool postponed, int postponeCount, WaitingFee fee, String paymentId, TicketPaymentSummary? payment, TicketRefundSummary? refund, DateTime? calledAt, DateTime? callDeadline, DateTime? enteredAt, int reentryCount, DateTime? lastReentryAt, NoShowReason noShowReason, DateTime? cancelledAt, CancelledBy cancelledBy, String cancelReason, TicketShareSummary? share, bool noticeAgreed, bool locationChecked, bool hiddenByUser, DateTime? qrIssuedAt, DateTime createdAt, DateTime updatedAt
});


$WaitingFeeCopyWith<$Res> get fee;$TicketPaymentSummaryCopyWith<$Res>? get payment;$TicketRefundSummaryCopyWith<$Res>? get refund;$TicketShareSummaryCopyWith<$Res>? get share;

}
/// @nodoc
class _$WaitingModelCopyWithImpl<$Res>
    implements $WaitingModelCopyWith<$Res> {
  _$WaitingModelCopyWithImpl(this._self, this._then);

  final WaitingModel _self;
  final $Res Function(WaitingModel) _then;

/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? waitingId = null,Object? code = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? businessDate = null,Object? seq = null,Object? people = null,Object? status = null,Object? postponed = null,Object? postponeCount = null,Object? fee = null,Object? paymentId = null,Object? payment = freezed,Object? refund = freezed,Object? calledAt = freezed,Object? callDeadline = freezed,Object? enteredAt = freezed,Object? reentryCount = null,Object? lastReentryAt = freezed,Object? noShowReason = null,Object? cancelledAt = freezed,Object? cancelledBy = null,Object? cancelReason = null,Object? share = freezed,Object? noticeAgreed = null,Object? locationChecked = null,Object? hiddenByUser = null,Object? qrIssuedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
waitingId: null == waitingId ? _self.waitingId : waitingId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WaitingStatus,postponed: null == postponed ? _self.postponed : postponed // ignore: cast_nullable_to_non_nullable
as bool,postponeCount: null == postponeCount ? _self.postponeCount : postponeCount // ignore: cast_nullable_to_non_nullable
as int,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as WaitingFee,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callDeadline: freezed == callDeadline ? _self.callDeadline : callDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,lastReentryAt: freezed == lastReentryAt ? _self.lastReentryAt : lastReentryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,noShowReason: null == noShowReason ? _self.noShowReason : noShowReason // ignore: cast_nullable_to_non_nullable
as NoShowReason,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: null == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as CancelledBy,cancelReason: null == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as TicketShareSummary?,noticeAgreed: null == noticeAgreed ? _self.noticeAgreed : noticeAgreed // ignore: cast_nullable_to_non_nullable
as bool,locationChecked: null == locationChecked ? _self.locationChecked : locationChecked // ignore: cast_nullable_to_non_nullable
as bool,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,qrIssuedAt: freezed == qrIssuedAt ? _self.qrIssuedAt : qrIssuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaitingFeeCopyWith<$Res> get fee {
  
  return $WaitingFeeCopyWith<$Res>(_self.fee, (value) {
    return _then(_self.copyWith(fee: value));
  });
}/// Create a copy of WaitingModel
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
}/// Create a copy of WaitingModel
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
}/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketShareSummaryCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $TicketShareSummaryCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}


/// Adds pattern-matching-related methods to [WaitingModel].
extension WaitingModelPatterns on WaitingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaitingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaitingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaitingModel value)  $default,){
final _that = this;
switch (_that) {
case _WaitingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaitingModel value)?  $default,){
final _that = this;
switch (_that) {
case _WaitingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String waitingId,  String code,  String clubId,  String clubName,  String uid,  String businessDate,  int seq,  int people,  WaitingStatus status,  bool postponed,  int postponeCount,  WaitingFee fee,  String paymentId,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  DateTime? calledAt,  DateTime? callDeadline,  DateTime? enteredAt,  int reentryCount,  DateTime? lastReentryAt,  NoShowReason noShowReason,  DateTime? cancelledAt,  CancelledBy cancelledBy,  String cancelReason,  TicketShareSummary? share,  bool noticeAgreed,  bool locationChecked,  bool hiddenByUser,  DateTime? qrIssuedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaitingModel() when $default != null:
return $default(_that.waitingId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.seq,_that.people,_that.status,_that.postponed,_that.postponeCount,_that.fee,_that.paymentId,_that.payment,_that.refund,_that.calledAt,_that.callDeadline,_that.enteredAt,_that.reentryCount,_that.lastReentryAt,_that.noShowReason,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.share,_that.noticeAgreed,_that.locationChecked,_that.hiddenByUser,_that.qrIssuedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String waitingId,  String code,  String clubId,  String clubName,  String uid,  String businessDate,  int seq,  int people,  WaitingStatus status,  bool postponed,  int postponeCount,  WaitingFee fee,  String paymentId,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  DateTime? calledAt,  DateTime? callDeadline,  DateTime? enteredAt,  int reentryCount,  DateTime? lastReentryAt,  NoShowReason noShowReason,  DateTime? cancelledAt,  CancelledBy cancelledBy,  String cancelReason,  TicketShareSummary? share,  bool noticeAgreed,  bool locationChecked,  bool hiddenByUser,  DateTime? qrIssuedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WaitingModel():
return $default(_that.waitingId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.seq,_that.people,_that.status,_that.postponed,_that.postponeCount,_that.fee,_that.paymentId,_that.payment,_that.refund,_that.calledAt,_that.callDeadline,_that.enteredAt,_that.reentryCount,_that.lastReentryAt,_that.noShowReason,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.share,_that.noticeAgreed,_that.locationChecked,_that.hiddenByUser,_that.qrIssuedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String waitingId,  String code,  String clubId,  String clubName,  String uid,  String businessDate,  int seq,  int people,  WaitingStatus status,  bool postponed,  int postponeCount,  WaitingFee fee,  String paymentId,  TicketPaymentSummary? payment,  TicketRefundSummary? refund,  DateTime? calledAt,  DateTime? callDeadline,  DateTime? enteredAt,  int reentryCount,  DateTime? lastReentryAt,  NoShowReason noShowReason,  DateTime? cancelledAt,  CancelledBy cancelledBy,  String cancelReason,  TicketShareSummary? share,  bool noticeAgreed,  bool locationChecked,  bool hiddenByUser,  DateTime? qrIssuedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WaitingModel() when $default != null:
return $default(_that.waitingId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.seq,_that.people,_that.status,_that.postponed,_that.postponeCount,_that.fee,_that.paymentId,_that.payment,_that.refund,_that.calledAt,_that.callDeadline,_that.enteredAt,_that.reentryCount,_that.lastReentryAt,_that.noShowReason,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.share,_that.noticeAgreed,_that.locationChecked,_that.hiddenByUser,_that.qrIssuedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WaitingModel extends WaitingModel {
  const _WaitingModel({required this.waitingId, required this.code, required this.clubId, this.clubName = '', required this.uid, required this.businessDate, this.seq = 0, this.people = 1, this.status = WaitingStatus.unknown, this.postponed = false, this.postponeCount = 0, this.fee = const WaitingFee(), this.paymentId = '', this.payment, this.refund, this.calledAt, this.callDeadline, this.enteredAt, this.reentryCount = 0, this.lastReentryAt, this.noShowReason = NoShowReason.unknown, this.cancelledAt, this.cancelledBy = CancelledBy.unknown, this.cancelReason = '', this.share, this.noticeAgreed = false, this.locationChecked = false, this.hiddenByUser = false, this.qrIssuedAt, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String waitingId;
/// ENTRY PASS 번호 — 'WT-2607-0005'. 사용자·관리자 표시 · 티켓 조회 키.
@override final  String code;
@override final  String clubId;
@override@JsonKey() final  String clubName;
@override final  String uid;
/// 영업일 'YYYYMMDD'.
@override final  String businessDate;
/// 대기 번호(영업일 내 1부터).
@override@JsonKey() final  int seq;
@override@JsonKey() final  int people;
@override@JsonKey() final  WaitingStatus status;
/// 순서 미루기를 쓴 적이 있는지.
@override@JsonKey() final  bool postponed;
@override@JsonKey() final  int postponeCount;
/// 입장비 스냅샷. `total == 0` 이면 입장비 없는 웨이팅.
@override@JsonKey() final  WaitingFee fee;
@override@JsonKey() final  String paymentId;
@override final  TicketPaymentSummary? payment;
@override final  TicketRefundSummary? refund;
@override final  DateTime? calledAt;
/// 호출 +10분. 넘기면 noShow.
@override final  DateTime? callDeadline;
@override final  DateTime? enteredAt;
@override@JsonKey() final  int reentryCount;
@override final  DateTime? lastReentryAt;
@override@JsonKey() final  NoShowReason noShowReason;
@override final  DateTime? cancelledAt;
@override@JsonKey() final  CancelledBy cancelledBy;
@override@JsonKey() final  String cancelReason;
@override final  TicketShareSummary? share;
/// 유의사항 동의 · 반경 500m 검증 결과(서버가 판정해 기록).
@override@JsonKey() final  bool noticeAgreed;
@override@JsonKey() final  bool locationChecked;
/// noShow 티켓 '제거하기' — 사용자 측 숨김.
@override@JsonKey() final  bool hiddenByUser;
/// `issueEntryQr` 가 갱신. 재발급 10초 제한 비교용.
@override final  DateTime? qrIssuedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaitingModelCopyWith<_WaitingModel> get copyWith => __$WaitingModelCopyWithImpl<_WaitingModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaitingModel&&(identical(other.waitingId, waitingId) || other.waitingId == waitingId)&&(identical(other.code, code) || other.code == code)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.people, people) || other.people == people)&&(identical(other.status, status) || other.status == status)&&(identical(other.postponed, postponed) || other.postponed == postponed)&&(identical(other.postponeCount, postponeCount) || other.postponeCount == postponeCount)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt)&&(identical(other.callDeadline, callDeadline) || other.callDeadline == callDeadline)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.lastReentryAt, lastReentryAt) || other.lastReentryAt == lastReentryAt)&&(identical(other.noShowReason, noShowReason) || other.noShowReason == noShowReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.share, share) || other.share == share)&&(identical(other.noticeAgreed, noticeAgreed) || other.noticeAgreed == noticeAgreed)&&(identical(other.locationChecked, locationChecked) || other.locationChecked == locationChecked)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser)&&(identical(other.qrIssuedAt, qrIssuedAt) || other.qrIssuedAt == qrIssuedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,waitingId,code,clubId,clubName,uid,businessDate,seq,people,status,postponed,postponeCount,fee,paymentId,payment,refund,calledAt,callDeadline,enteredAt,reentryCount,lastReentryAt,noShowReason,cancelledAt,cancelledBy,cancelReason,share,noticeAgreed,locationChecked,hiddenByUser,qrIssuedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'WaitingModel(waitingId: $waitingId, code: $code, clubId: $clubId, clubName: $clubName, uid: $uid, businessDate: $businessDate, seq: $seq, people: $people, status: $status, postponed: $postponed, postponeCount: $postponeCount, fee: $fee, paymentId: $paymentId, payment: $payment, refund: $refund, calledAt: $calledAt, callDeadline: $callDeadline, enteredAt: $enteredAt, reentryCount: $reentryCount, lastReentryAt: $lastReentryAt, noShowReason: $noShowReason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, share: $share, noticeAgreed: $noticeAgreed, locationChecked: $locationChecked, hiddenByUser: $hiddenByUser, qrIssuedAt: $qrIssuedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WaitingModelCopyWith<$Res> implements $WaitingModelCopyWith<$Res> {
  factory _$WaitingModelCopyWith(_WaitingModel value, $Res Function(_WaitingModel) _then) = __$WaitingModelCopyWithImpl;
@override @useResult
$Res call({
 String waitingId, String code, String clubId, String clubName, String uid, String businessDate, int seq, int people, WaitingStatus status, bool postponed, int postponeCount, WaitingFee fee, String paymentId, TicketPaymentSummary? payment, TicketRefundSummary? refund, DateTime? calledAt, DateTime? callDeadline, DateTime? enteredAt, int reentryCount, DateTime? lastReentryAt, NoShowReason noShowReason, DateTime? cancelledAt, CancelledBy cancelledBy, String cancelReason, TicketShareSummary? share, bool noticeAgreed, bool locationChecked, bool hiddenByUser, DateTime? qrIssuedAt, DateTime createdAt, DateTime updatedAt
});


@override $WaitingFeeCopyWith<$Res> get fee;@override $TicketPaymentSummaryCopyWith<$Res>? get payment;@override $TicketRefundSummaryCopyWith<$Res>? get refund;@override $TicketShareSummaryCopyWith<$Res>? get share;

}
/// @nodoc
class __$WaitingModelCopyWithImpl<$Res>
    implements _$WaitingModelCopyWith<$Res> {
  __$WaitingModelCopyWithImpl(this._self, this._then);

  final _WaitingModel _self;
  final $Res Function(_WaitingModel) _then;

/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? waitingId = null,Object? code = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? businessDate = null,Object? seq = null,Object? people = null,Object? status = null,Object? postponed = null,Object? postponeCount = null,Object? fee = null,Object? paymentId = null,Object? payment = freezed,Object? refund = freezed,Object? calledAt = freezed,Object? callDeadline = freezed,Object? enteredAt = freezed,Object? reentryCount = null,Object? lastReentryAt = freezed,Object? noShowReason = null,Object? cancelledAt = freezed,Object? cancelledBy = null,Object? cancelReason = null,Object? share = freezed,Object? noticeAgreed = null,Object? locationChecked = null,Object? hiddenByUser = null,Object? qrIssuedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WaitingModel(
waitingId: null == waitingId ? _self.waitingId : waitingId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WaitingStatus,postponed: null == postponed ? _self.postponed : postponed // ignore: cast_nullable_to_non_nullable
as bool,postponeCount: null == postponeCount ? _self.postponeCount : postponeCount // ignore: cast_nullable_to_non_nullable
as int,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as WaitingFee,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callDeadline: freezed == callDeadline ? _self.callDeadline : callDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,lastReentryAt: freezed == lastReentryAt ? _self.lastReentryAt : lastReentryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,noShowReason: null == noShowReason ? _self.noShowReason : noShowReason // ignore: cast_nullable_to_non_nullable
as NoShowReason,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: null == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as CancelledBy,cancelReason: null == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as TicketShareSummary?,noticeAgreed: null == noticeAgreed ? _self.noticeAgreed : noticeAgreed // ignore: cast_nullable_to_non_nullable
as bool,locationChecked: null == locationChecked ? _self.locationChecked : locationChecked // ignore: cast_nullable_to_non_nullable
as bool,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,qrIssuedAt: freezed == qrIssuedAt ? _self.qrIssuedAt : qrIssuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaitingFeeCopyWith<$Res> get fee {
  
  return $WaitingFeeCopyWith<$Res>(_self.fee, (value) {
    return _then(_self.copyWith(fee: value));
  });
}/// Create a copy of WaitingModel
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
}/// Create a copy of WaitingModel
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
}/// Create a copy of WaitingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketShareSummaryCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $TicketShareSummaryCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}

// dart format on
