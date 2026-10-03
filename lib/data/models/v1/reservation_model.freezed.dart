// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReservationModel {

 String get reservationId;/// TABLE RESERVATION 번호 — 'RS-2607-1182'.
 String get code; String get clubId; String get clubName; String get uid;/// 예약자 정보. ⚠ 관리자 화면은 **마스킹 없이** 표시한다(확정 정책).
 ReservationGuest get guest;/// 이용 날짜 'YYYYMMDD'(= businessDate).
 String get date;/// 도착 시간 슬롯 — '20:00'.
 String get arrivalSlot; DateTime? get arrivalAt; int get people; String get tableId;/// 표시용 좌석 이름 — '테이블-4'.
 String get tableName; SeatTier get tier;/// 테이블 금액 스냅샷.
 int get seatPrice;/// 최소 주문금액 스냅샷.
 int get minSpend;/// 사전 주문.
 List<OrderLine> get menuLines; int get menuSubtotal;/// 결제 총액(변경 누적 반영).
 int get totalPaid; String get paymentId; TicketPaymentSummary? get payment; ReservationStatus get status;/// 결제 +10분. 이 안에 취소하면 전액 환불(RSV-091).
 DateTime? get freeCancelUntil;/// 도착 3시간 전 — 입장권으로 자동 전환(RSV-087).
 DateTime? get convertAt; DateTime? get convertedAt; DateTime? get enteredAt; int get reentryCount;/// 변경 횟수. 2회차부터 변경 수수료 3,000원.
 int get changeCount; ReservationCancel? get cancel; ReservationNoShow? get noShow; TicketShareSummary? get share;/// 동의한 규정 판본.
 String get policyVersion; DateTime? get policyAgreedAt; bool get hiddenByUser; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationModelCopyWith<ReservationModel> get copyWith => _$ReservationModelCopyWithImpl<ReservationModel>(this as ReservationModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationModel&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.code, code) || other.code == code)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.guest, guest) || other.guest == guest)&&(identical(other.date, date) || other.date == date)&&(identical(other.arrivalSlot, arrivalSlot) || other.arrivalSlot == arrivalSlot)&&(identical(other.arrivalAt, arrivalAt) || other.arrivalAt == arrivalAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.seatPrice, seatPrice) || other.seatPrice == seatPrice)&&(identical(other.minSpend, minSpend) || other.minSpend == minSpend)&&const DeepCollectionEquality().equals(other.menuLines, menuLines)&&(identical(other.menuSubtotal, menuSubtotal) || other.menuSubtotal == menuSubtotal)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.status, status) || other.status == status)&&(identical(other.freeCancelUntil, freeCancelUntil) || other.freeCancelUntil == freeCancelUntil)&&(identical(other.convertAt, convertAt) || other.convertAt == convertAt)&&(identical(other.convertedAt, convertedAt) || other.convertedAt == convertedAt)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.changeCount, changeCount) || other.changeCount == changeCount)&&(identical(other.cancel, cancel) || other.cancel == cancel)&&(identical(other.noShow, noShow) || other.noShow == noShow)&&(identical(other.share, share) || other.share == share)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.policyAgreedAt, policyAgreedAt) || other.policyAgreedAt == policyAgreedAt)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,reservationId,code,clubId,clubName,uid,guest,date,arrivalSlot,arrivalAt,people,tableId,tableName,tier,seatPrice,minSpend,const DeepCollectionEquality().hash(menuLines),menuSubtotal,totalPaid,paymentId,payment,status,freeCancelUntil,convertAt,convertedAt,enteredAt,reentryCount,changeCount,cancel,noShow,share,policyVersion,policyAgreedAt,hiddenByUser,createdAt,updatedAt]);

@override
String toString() {
  return 'ReservationModel(reservationId: $reservationId, code: $code, clubId: $clubId, clubName: $clubName, uid: $uid, guest: $guest, date: $date, arrivalSlot: $arrivalSlot, arrivalAt: $arrivalAt, people: $people, tableId: $tableId, tableName: $tableName, tier: $tier, seatPrice: $seatPrice, minSpend: $minSpend, menuLines: $menuLines, menuSubtotal: $menuSubtotal, totalPaid: $totalPaid, paymentId: $paymentId, payment: $payment, status: $status, freeCancelUntil: $freeCancelUntil, convertAt: $convertAt, convertedAt: $convertedAt, enteredAt: $enteredAt, reentryCount: $reentryCount, changeCount: $changeCount, cancel: $cancel, noShow: $noShow, share: $share, policyVersion: $policyVersion, policyAgreedAt: $policyAgreedAt, hiddenByUser: $hiddenByUser, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReservationModelCopyWith<$Res>  {
  factory $ReservationModelCopyWith(ReservationModel value, $Res Function(ReservationModel) _then) = _$ReservationModelCopyWithImpl;
@useResult
$Res call({
 String reservationId, String code, String clubId, String clubName, String uid, ReservationGuest guest, String date, String arrivalSlot, DateTime? arrivalAt, int people, String tableId, String tableName, SeatTier tier, int seatPrice, int minSpend, List<OrderLine> menuLines, int menuSubtotal, int totalPaid, String paymentId, TicketPaymentSummary? payment, ReservationStatus status, DateTime? freeCancelUntil, DateTime? convertAt, DateTime? convertedAt, DateTime? enteredAt, int reentryCount, int changeCount, ReservationCancel? cancel, ReservationNoShow? noShow, TicketShareSummary? share, String policyVersion, DateTime? policyAgreedAt, bool hiddenByUser, DateTime createdAt, DateTime updatedAt
});


$ReservationGuestCopyWith<$Res> get guest;$TicketPaymentSummaryCopyWith<$Res>? get payment;$ReservationCancelCopyWith<$Res>? get cancel;$ReservationNoShowCopyWith<$Res>? get noShow;$TicketShareSummaryCopyWith<$Res>? get share;

}
/// @nodoc
class _$ReservationModelCopyWithImpl<$Res>
    implements $ReservationModelCopyWith<$Res> {
  _$ReservationModelCopyWithImpl(this._self, this._then);

  final ReservationModel _self;
  final $Res Function(ReservationModel) _then;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reservationId = null,Object? code = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? guest = null,Object? date = null,Object? arrivalSlot = null,Object? arrivalAt = freezed,Object? people = null,Object? tableId = null,Object? tableName = null,Object? tier = null,Object? seatPrice = null,Object? minSpend = null,Object? menuLines = null,Object? menuSubtotal = null,Object? totalPaid = null,Object? paymentId = null,Object? payment = freezed,Object? status = null,Object? freeCancelUntil = freezed,Object? convertAt = freezed,Object? convertedAt = freezed,Object? enteredAt = freezed,Object? reentryCount = null,Object? changeCount = null,Object? cancel = freezed,Object? noShow = freezed,Object? share = freezed,Object? policyVersion = null,Object? policyAgreedAt = freezed,Object? hiddenByUser = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as ReservationGuest,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,arrivalSlot: null == arrivalSlot ? _self.arrivalSlot : arrivalSlot // ignore: cast_nullable_to_non_nullable
as String,arrivalAt: freezed == arrivalAt ? _self.arrivalAt : arrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as SeatTier,seatPrice: null == seatPrice ? _self.seatPrice : seatPrice // ignore: cast_nullable_to_non_nullable
as int,minSpend: null == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as int,menuLines: null == menuLines ? _self.menuLines : menuLines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,menuSubtotal: null == menuSubtotal ? _self.menuSubtotal : menuSubtotal // ignore: cast_nullable_to_non_nullable
as int,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as int,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,freeCancelUntil: freezed == freeCancelUntil ? _self.freeCancelUntil : freeCancelUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,convertAt: freezed == convertAt ? _self.convertAt : convertAt // ignore: cast_nullable_to_non_nullable
as DateTime?,convertedAt: freezed == convertedAt ? _self.convertedAt : convertedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,changeCount: null == changeCount ? _self.changeCount : changeCount // ignore: cast_nullable_to_non_nullable
as int,cancel: freezed == cancel ? _self.cancel : cancel // ignore: cast_nullable_to_non_nullable
as ReservationCancel?,noShow: freezed == noShow ? _self.noShow : noShow // ignore: cast_nullable_to_non_nullable
as ReservationNoShow?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as TicketShareSummary?,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,policyAgreedAt: freezed == policyAgreedAt ? _self.policyAgreedAt : policyAgreedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationGuestCopyWith<$Res> get guest {
  
  return $ReservationGuestCopyWith<$Res>(_self.guest, (value) {
    return _then(_self.copyWith(guest: value));
  });
}/// Create a copy of ReservationModel
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
}/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationCancelCopyWith<$Res>? get cancel {
    if (_self.cancel == null) {
    return null;
  }

  return $ReservationCancelCopyWith<$Res>(_self.cancel!, (value) {
    return _then(_self.copyWith(cancel: value));
  });
}/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationNoShowCopyWith<$Res>? get noShow {
    if (_self.noShow == null) {
    return null;
  }

  return $ReservationNoShowCopyWith<$Res>(_self.noShow!, (value) {
    return _then(_self.copyWith(noShow: value));
  });
}/// Create a copy of ReservationModel
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


/// Adds pattern-matching-related methods to [ReservationModel].
extension ReservationModelPatterns on ReservationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationModel value)  $default,){
final _that = this;
switch (_that) {
case _ReservationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reservationId,  String code,  String clubId,  String clubName,  String uid,  ReservationGuest guest,  String date,  String arrivalSlot,  DateTime? arrivalAt,  int people,  String tableId,  String tableName,  SeatTier tier,  int seatPrice,  int minSpend,  List<OrderLine> menuLines,  int menuSubtotal,  int totalPaid,  String paymentId,  TicketPaymentSummary? payment,  ReservationStatus status,  DateTime? freeCancelUntil,  DateTime? convertAt,  DateTime? convertedAt,  DateTime? enteredAt,  int reentryCount,  int changeCount,  ReservationCancel? cancel,  ReservationNoShow? noShow,  TicketShareSummary? share,  String policyVersion,  DateTime? policyAgreedAt,  bool hiddenByUser,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
return $default(_that.reservationId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.guest,_that.date,_that.arrivalSlot,_that.arrivalAt,_that.people,_that.tableId,_that.tableName,_that.tier,_that.seatPrice,_that.minSpend,_that.menuLines,_that.menuSubtotal,_that.totalPaid,_that.paymentId,_that.payment,_that.status,_that.freeCancelUntil,_that.convertAt,_that.convertedAt,_that.enteredAt,_that.reentryCount,_that.changeCount,_that.cancel,_that.noShow,_that.share,_that.policyVersion,_that.policyAgreedAt,_that.hiddenByUser,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reservationId,  String code,  String clubId,  String clubName,  String uid,  ReservationGuest guest,  String date,  String arrivalSlot,  DateTime? arrivalAt,  int people,  String tableId,  String tableName,  SeatTier tier,  int seatPrice,  int minSpend,  List<OrderLine> menuLines,  int menuSubtotal,  int totalPaid,  String paymentId,  TicketPaymentSummary? payment,  ReservationStatus status,  DateTime? freeCancelUntil,  DateTime? convertAt,  DateTime? convertedAt,  DateTime? enteredAt,  int reentryCount,  int changeCount,  ReservationCancel? cancel,  ReservationNoShow? noShow,  TicketShareSummary? share,  String policyVersion,  DateTime? policyAgreedAt,  bool hiddenByUser,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReservationModel():
return $default(_that.reservationId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.guest,_that.date,_that.arrivalSlot,_that.arrivalAt,_that.people,_that.tableId,_that.tableName,_that.tier,_that.seatPrice,_that.minSpend,_that.menuLines,_that.menuSubtotal,_that.totalPaid,_that.paymentId,_that.payment,_that.status,_that.freeCancelUntil,_that.convertAt,_that.convertedAt,_that.enteredAt,_that.reentryCount,_that.changeCount,_that.cancel,_that.noShow,_that.share,_that.policyVersion,_that.policyAgreedAt,_that.hiddenByUser,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reservationId,  String code,  String clubId,  String clubName,  String uid,  ReservationGuest guest,  String date,  String arrivalSlot,  DateTime? arrivalAt,  int people,  String tableId,  String tableName,  SeatTier tier,  int seatPrice,  int minSpend,  List<OrderLine> menuLines,  int menuSubtotal,  int totalPaid,  String paymentId,  TicketPaymentSummary? payment,  ReservationStatus status,  DateTime? freeCancelUntil,  DateTime? convertAt,  DateTime? convertedAt,  DateTime? enteredAt,  int reentryCount,  int changeCount,  ReservationCancel? cancel,  ReservationNoShow? noShow,  TicketShareSummary? share,  String policyVersion,  DateTime? policyAgreedAt,  bool hiddenByUser,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReservationModel() when $default != null:
return $default(_that.reservationId,_that.code,_that.clubId,_that.clubName,_that.uid,_that.guest,_that.date,_that.arrivalSlot,_that.arrivalAt,_that.people,_that.tableId,_that.tableName,_that.tier,_that.seatPrice,_that.minSpend,_that.menuLines,_that.menuSubtotal,_that.totalPaid,_that.paymentId,_that.payment,_that.status,_that.freeCancelUntil,_that.convertAt,_that.convertedAt,_that.enteredAt,_that.reentryCount,_that.changeCount,_that.cancel,_that.noShow,_that.share,_that.policyVersion,_that.policyAgreedAt,_that.hiddenByUser,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationModel extends ReservationModel {
  const _ReservationModel({required this.reservationId, required this.code, required this.clubId, this.clubName = '', required this.uid, this.guest = const ReservationGuest(), required this.date, this.arrivalSlot = '', this.arrivalAt, this.people = 1, this.tableId = '', this.tableName = '', this.tier = SeatTier.unknown, this.seatPrice = 0, this.minSpend = 0, final  List<OrderLine> menuLines = const <OrderLine>[], this.menuSubtotal = 0, this.totalPaid = 0, this.paymentId = '', this.payment, this.status = ReservationStatus.unknown, this.freeCancelUntil, this.convertAt, this.convertedAt, this.enteredAt, this.reentryCount = 0, this.changeCount = 0, this.cancel, this.noShow, this.share, this.policyVersion = '', this.policyAgreedAt, this.hiddenByUser = false, required this.createdAt, required this.updatedAt}): _menuLines = menuLines,super._();
  

@override final  String reservationId;
/// TABLE RESERVATION 번호 — 'RS-2607-1182'.
@override final  String code;
@override final  String clubId;
@override@JsonKey() final  String clubName;
@override final  String uid;
/// 예약자 정보. ⚠ 관리자 화면은 **마스킹 없이** 표시한다(확정 정책).
@override@JsonKey() final  ReservationGuest guest;
/// 이용 날짜 'YYYYMMDD'(= businessDate).
@override final  String date;
/// 도착 시간 슬롯 — '20:00'.
@override@JsonKey() final  String arrivalSlot;
@override final  DateTime? arrivalAt;
@override@JsonKey() final  int people;
@override@JsonKey() final  String tableId;
/// 표시용 좌석 이름 — '테이블-4'.
@override@JsonKey() final  String tableName;
@override@JsonKey() final  SeatTier tier;
/// 테이블 금액 스냅샷.
@override@JsonKey() final  int seatPrice;
/// 최소 주문금액 스냅샷.
@override@JsonKey() final  int minSpend;
/// 사전 주문.
 final  List<OrderLine> _menuLines;
/// 사전 주문.
@override@JsonKey() List<OrderLine> get menuLines {
  if (_menuLines is EqualUnmodifiableListView) return _menuLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_menuLines);
}

@override@JsonKey() final  int menuSubtotal;
/// 결제 총액(변경 누적 반영).
@override@JsonKey() final  int totalPaid;
@override@JsonKey() final  String paymentId;
@override final  TicketPaymentSummary? payment;
@override@JsonKey() final  ReservationStatus status;
/// 결제 +10분. 이 안에 취소하면 전액 환불(RSV-091).
@override final  DateTime? freeCancelUntil;
/// 도착 3시간 전 — 입장권으로 자동 전환(RSV-087).
@override final  DateTime? convertAt;
@override final  DateTime? convertedAt;
@override final  DateTime? enteredAt;
@override@JsonKey() final  int reentryCount;
/// 변경 횟수. 2회차부터 변경 수수료 3,000원.
@override@JsonKey() final  int changeCount;
@override final  ReservationCancel? cancel;
@override final  ReservationNoShow? noShow;
@override final  TicketShareSummary? share;
/// 동의한 규정 판본.
@override@JsonKey() final  String policyVersion;
@override final  DateTime? policyAgreedAt;
@override@JsonKey() final  bool hiddenByUser;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationModelCopyWith<_ReservationModel> get copyWith => __$ReservationModelCopyWithImpl<_ReservationModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationModel&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.code, code) || other.code == code)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.guest, guest) || other.guest == guest)&&(identical(other.date, date) || other.date == date)&&(identical(other.arrivalSlot, arrivalSlot) || other.arrivalSlot == arrivalSlot)&&(identical(other.arrivalAt, arrivalAt) || other.arrivalAt == arrivalAt)&&(identical(other.people, people) || other.people == people)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.seatPrice, seatPrice) || other.seatPrice == seatPrice)&&(identical(other.minSpend, minSpend) || other.minSpend == minSpend)&&const DeepCollectionEquality().equals(other._menuLines, _menuLines)&&(identical(other.menuSubtotal, menuSubtotal) || other.menuSubtotal == menuSubtotal)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.status, status) || other.status == status)&&(identical(other.freeCancelUntil, freeCancelUntil) || other.freeCancelUntil == freeCancelUntil)&&(identical(other.convertAt, convertAt) || other.convertAt == convertAt)&&(identical(other.convertedAt, convertedAt) || other.convertedAt == convertedAt)&&(identical(other.enteredAt, enteredAt) || other.enteredAt == enteredAt)&&(identical(other.reentryCount, reentryCount) || other.reentryCount == reentryCount)&&(identical(other.changeCount, changeCount) || other.changeCount == changeCount)&&(identical(other.cancel, cancel) || other.cancel == cancel)&&(identical(other.noShow, noShow) || other.noShow == noShow)&&(identical(other.share, share) || other.share == share)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.policyAgreedAt, policyAgreedAt) || other.policyAgreedAt == policyAgreedAt)&&(identical(other.hiddenByUser, hiddenByUser) || other.hiddenByUser == hiddenByUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,reservationId,code,clubId,clubName,uid,guest,date,arrivalSlot,arrivalAt,people,tableId,tableName,tier,seatPrice,minSpend,const DeepCollectionEquality().hash(_menuLines),menuSubtotal,totalPaid,paymentId,payment,status,freeCancelUntil,convertAt,convertedAt,enteredAt,reentryCount,changeCount,cancel,noShow,share,policyVersion,policyAgreedAt,hiddenByUser,createdAt,updatedAt]);

@override
String toString() {
  return 'ReservationModel(reservationId: $reservationId, code: $code, clubId: $clubId, clubName: $clubName, uid: $uid, guest: $guest, date: $date, arrivalSlot: $arrivalSlot, arrivalAt: $arrivalAt, people: $people, tableId: $tableId, tableName: $tableName, tier: $tier, seatPrice: $seatPrice, minSpend: $minSpend, menuLines: $menuLines, menuSubtotal: $menuSubtotal, totalPaid: $totalPaid, paymentId: $paymentId, payment: $payment, status: $status, freeCancelUntil: $freeCancelUntil, convertAt: $convertAt, convertedAt: $convertedAt, enteredAt: $enteredAt, reentryCount: $reentryCount, changeCount: $changeCount, cancel: $cancel, noShow: $noShow, share: $share, policyVersion: $policyVersion, policyAgreedAt: $policyAgreedAt, hiddenByUser: $hiddenByUser, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReservationModelCopyWith<$Res> implements $ReservationModelCopyWith<$Res> {
  factory _$ReservationModelCopyWith(_ReservationModel value, $Res Function(_ReservationModel) _then) = __$ReservationModelCopyWithImpl;
@override @useResult
$Res call({
 String reservationId, String code, String clubId, String clubName, String uid, ReservationGuest guest, String date, String arrivalSlot, DateTime? arrivalAt, int people, String tableId, String tableName, SeatTier tier, int seatPrice, int minSpend, List<OrderLine> menuLines, int menuSubtotal, int totalPaid, String paymentId, TicketPaymentSummary? payment, ReservationStatus status, DateTime? freeCancelUntil, DateTime? convertAt, DateTime? convertedAt, DateTime? enteredAt, int reentryCount, int changeCount, ReservationCancel? cancel, ReservationNoShow? noShow, TicketShareSummary? share, String policyVersion, DateTime? policyAgreedAt, bool hiddenByUser, DateTime createdAt, DateTime updatedAt
});


@override $ReservationGuestCopyWith<$Res> get guest;@override $TicketPaymentSummaryCopyWith<$Res>? get payment;@override $ReservationCancelCopyWith<$Res>? get cancel;@override $ReservationNoShowCopyWith<$Res>? get noShow;@override $TicketShareSummaryCopyWith<$Res>? get share;

}
/// @nodoc
class __$ReservationModelCopyWithImpl<$Res>
    implements _$ReservationModelCopyWith<$Res> {
  __$ReservationModelCopyWithImpl(this._self, this._then);

  final _ReservationModel _self;
  final $Res Function(_ReservationModel) _then;

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reservationId = null,Object? code = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? guest = null,Object? date = null,Object? arrivalSlot = null,Object? arrivalAt = freezed,Object? people = null,Object? tableId = null,Object? tableName = null,Object? tier = null,Object? seatPrice = null,Object? minSpend = null,Object? menuLines = null,Object? menuSubtotal = null,Object? totalPaid = null,Object? paymentId = null,Object? payment = freezed,Object? status = null,Object? freeCancelUntil = freezed,Object? convertAt = freezed,Object? convertedAt = freezed,Object? enteredAt = freezed,Object? reentryCount = null,Object? changeCount = null,Object? cancel = freezed,Object? noShow = freezed,Object? share = freezed,Object? policyVersion = null,Object? policyAgreedAt = freezed,Object? hiddenByUser = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReservationModel(
reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as ReservationGuest,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,arrivalSlot: null == arrivalSlot ? _self.arrivalSlot : arrivalSlot // ignore: cast_nullable_to_non_nullable
as String,arrivalAt: freezed == arrivalAt ? _self.arrivalAt : arrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as SeatTier,seatPrice: null == seatPrice ? _self.seatPrice : seatPrice // ignore: cast_nullable_to_non_nullable
as int,minSpend: null == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as int,menuLines: null == menuLines ? _self._menuLines : menuLines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,menuSubtotal: null == menuSubtotal ? _self.menuSubtotal : menuSubtotal // ignore: cast_nullable_to_non_nullable
as int,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as int,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,freeCancelUntil: freezed == freeCancelUntil ? _self.freeCancelUntil : freeCancelUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,convertAt: freezed == convertAt ? _self.convertAt : convertAt // ignore: cast_nullable_to_non_nullable
as DateTime?,convertedAt: freezed == convertedAt ? _self.convertedAt : convertedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredAt: freezed == enteredAt ? _self.enteredAt : enteredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reentryCount: null == reentryCount ? _self.reentryCount : reentryCount // ignore: cast_nullable_to_non_nullable
as int,changeCount: null == changeCount ? _self.changeCount : changeCount // ignore: cast_nullable_to_non_nullable
as int,cancel: freezed == cancel ? _self.cancel : cancel // ignore: cast_nullable_to_non_nullable
as ReservationCancel?,noShow: freezed == noShow ? _self.noShow : noShow // ignore: cast_nullable_to_non_nullable
as ReservationNoShow?,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as TicketShareSummary?,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,policyAgreedAt: freezed == policyAgreedAt ? _self.policyAgreedAt : policyAgreedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hiddenByUser: null == hiddenByUser ? _self.hiddenByUser : hiddenByUser // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationGuestCopyWith<$Res> get guest {
  
  return $ReservationGuestCopyWith<$Res>(_self.guest, (value) {
    return _then(_self.copyWith(guest: value));
  });
}/// Create a copy of ReservationModel
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
}/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationCancelCopyWith<$Res>? get cancel {
    if (_self.cancel == null) {
    return null;
  }

  return $ReservationCancelCopyWith<$Res>(_self.cancel!, (value) {
    return _then(_self.copyWith(cancel: value));
  });
}/// Create a copy of ReservationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationNoShowCopyWith<$Res>? get noShow {
    if (_self.noShow == null) {
    return null;
  }

  return $ReservationNoShowCopyWith<$Res>(_self.noShow!, (value) {
    return _then(_self.copyWith(noShow: value));
  });
}/// Create a copy of ReservationModel
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

/// @nodoc
mixin _$ReservationGuest {

 String get name; String get phone;
/// Create a copy of ReservationGuest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationGuestCopyWith<ReservationGuest> get copyWith => _$ReservationGuestCopyWithImpl<ReservationGuest>(this as ReservationGuest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationGuest&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,name,phone);

@override
String toString() {
  return 'ReservationGuest(name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ReservationGuestCopyWith<$Res>  {
  factory $ReservationGuestCopyWith(ReservationGuest value, $Res Function(ReservationGuest) _then) = _$ReservationGuestCopyWithImpl;
@useResult
$Res call({
 String name, String phone
});




}
/// @nodoc
class _$ReservationGuestCopyWithImpl<$Res>
    implements $ReservationGuestCopyWith<$Res> {
  _$ReservationGuestCopyWithImpl(this._self, this._then);

  final ReservationGuest _self;
  final $Res Function(ReservationGuest) _then;

/// Create a copy of ReservationGuest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationGuest].
extension ReservationGuestPatterns on ReservationGuest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationGuest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationGuest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationGuest value)  $default,){
final _that = this;
switch (_that) {
case _ReservationGuest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationGuest value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationGuest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationGuest() when $default != null:
return $default(_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone)  $default,) {final _that = this;
switch (_that) {
case _ReservationGuest():
return $default(_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _ReservationGuest() when $default != null:
return $default(_that.name,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationGuest implements ReservationGuest {
  const _ReservationGuest({this.name = '', this.phone = ''});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String phone;

/// Create a copy of ReservationGuest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationGuestCopyWith<_ReservationGuest> get copyWith => __$ReservationGuestCopyWithImpl<_ReservationGuest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationGuest&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,name,phone);

@override
String toString() {
  return 'ReservationGuest(name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ReservationGuestCopyWith<$Res> implements $ReservationGuestCopyWith<$Res> {
  factory _$ReservationGuestCopyWith(_ReservationGuest value, $Res Function(_ReservationGuest) _then) = __$ReservationGuestCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone
});




}
/// @nodoc
class __$ReservationGuestCopyWithImpl<$Res>
    implements _$ReservationGuestCopyWith<$Res> {
  __$ReservationGuestCopyWithImpl(this._self, this._then);

  final _ReservationGuest _self;
  final $Res Function(_ReservationGuest) _then;

/// Create a copy of ReservationGuest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,}) {
  return _then(_ReservationGuest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ReservationCancel {

 DateTime? get at; CancelledBy get by; CancelBucket get bucket; String get reason; List<PenaltyLine> get penalties; int get penaltyTotal; int get refundAmount;
/// Create a copy of ReservationCancel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCancelCopyWith<ReservationCancel> get copyWith => _$ReservationCancelCopyWithImpl<ReservationCancel>(this as ReservationCancel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationCancel&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.penalties, penalties)&&(identical(other.penaltyTotal, penaltyTotal) || other.penaltyTotal == penaltyTotal)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,at,by,bucket,reason,const DeepCollectionEquality().hash(penalties),penaltyTotal,refundAmount);

@override
String toString() {
  return 'ReservationCancel(at: $at, by: $by, bucket: $bucket, reason: $reason, penalties: $penalties, penaltyTotal: $penaltyTotal, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $ReservationCancelCopyWith<$Res>  {
  factory $ReservationCancelCopyWith(ReservationCancel value, $Res Function(ReservationCancel) _then) = _$ReservationCancelCopyWithImpl;
@useResult
$Res call({
 DateTime? at, CancelledBy by, CancelBucket bucket, String reason, List<PenaltyLine> penalties, int penaltyTotal, int refundAmount
});




}
/// @nodoc
class _$ReservationCancelCopyWithImpl<$Res>
    implements $ReservationCancelCopyWith<$Res> {
  _$ReservationCancelCopyWithImpl(this._self, this._then);

  final ReservationCancel _self;
  final $Res Function(ReservationCancel) _then;

/// Create a copy of ReservationCancel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = freezed,Object? by = null,Object? bucket = null,Object? reason = null,Object? penalties = null,Object? penaltyTotal = null,Object? refundAmount = null,}) {
  return _then(_self.copyWith(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as CancelledBy,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as CancelBucket,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,penalties: null == penalties ? _self.penalties : penalties // ignore: cast_nullable_to_non_nullable
as List<PenaltyLine>,penaltyTotal: null == penaltyTotal ? _self.penaltyTotal : penaltyTotal // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationCancel].
extension ReservationCancelPatterns on ReservationCancel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationCancel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationCancel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationCancel value)  $default,){
final _that = this;
switch (_that) {
case _ReservationCancel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationCancel value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationCancel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? at,  CancelledBy by,  CancelBucket bucket,  String reason,  List<PenaltyLine> penalties,  int penaltyTotal,  int refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationCancel() when $default != null:
return $default(_that.at,_that.by,_that.bucket,_that.reason,_that.penalties,_that.penaltyTotal,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? at,  CancelledBy by,  CancelBucket bucket,  String reason,  List<PenaltyLine> penalties,  int penaltyTotal,  int refundAmount)  $default,) {final _that = this;
switch (_that) {
case _ReservationCancel():
return $default(_that.at,_that.by,_that.bucket,_that.reason,_that.penalties,_that.penaltyTotal,_that.refundAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? at,  CancelledBy by,  CancelBucket bucket,  String reason,  List<PenaltyLine> penalties,  int penaltyTotal,  int refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _ReservationCancel() when $default != null:
return $default(_that.at,_that.by,_that.bucket,_that.reason,_that.penalties,_that.penaltyTotal,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationCancel extends ReservationCancel {
  const _ReservationCancel({this.at, this.by = CancelledBy.unknown, this.bucket = CancelBucket.unknown, this.reason = '', final  List<PenaltyLine> penalties = const <PenaltyLine>[], this.penaltyTotal = 0, this.refundAmount = 0}): _penalties = penalties,super._();
  

@override final  DateTime? at;
@override@JsonKey() final  CancelledBy by;
@override@JsonKey() final  CancelBucket bucket;
@override@JsonKey() final  String reason;
 final  List<PenaltyLine> _penalties;
@override@JsonKey() List<PenaltyLine> get penalties {
  if (_penalties is EqualUnmodifiableListView) return _penalties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_penalties);
}

@override@JsonKey() final  int penaltyTotal;
@override@JsonKey() final  int refundAmount;

/// Create a copy of ReservationCancel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCancelCopyWith<_ReservationCancel> get copyWith => __$ReservationCancelCopyWithImpl<_ReservationCancel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationCancel&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._penalties, _penalties)&&(identical(other.penaltyTotal, penaltyTotal) || other.penaltyTotal == penaltyTotal)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,at,by,bucket,reason,const DeepCollectionEquality().hash(_penalties),penaltyTotal,refundAmount);

@override
String toString() {
  return 'ReservationCancel(at: $at, by: $by, bucket: $bucket, reason: $reason, penalties: $penalties, penaltyTotal: $penaltyTotal, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$ReservationCancelCopyWith<$Res> implements $ReservationCancelCopyWith<$Res> {
  factory _$ReservationCancelCopyWith(_ReservationCancel value, $Res Function(_ReservationCancel) _then) = __$ReservationCancelCopyWithImpl;
@override @useResult
$Res call({
 DateTime? at, CancelledBy by, CancelBucket bucket, String reason, List<PenaltyLine> penalties, int penaltyTotal, int refundAmount
});




}
/// @nodoc
class __$ReservationCancelCopyWithImpl<$Res>
    implements _$ReservationCancelCopyWith<$Res> {
  __$ReservationCancelCopyWithImpl(this._self, this._then);

  final _ReservationCancel _self;
  final $Res Function(_ReservationCancel) _then;

/// Create a copy of ReservationCancel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = freezed,Object? by = null,Object? bucket = null,Object? reason = null,Object? penalties = null,Object? penaltyTotal = null,Object? refundAmount = null,}) {
  return _then(_ReservationCancel(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as CancelledBy,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as CancelBucket,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,penalties: null == penalties ? _self._penalties : penalties // ignore: cast_nullable_to_non_nullable
as List<PenaltyLine>,penaltyTotal: null == penaltyTotal ? _self.penaltyTotal : penaltyTotal // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReservationNoShow {

 DateTime? get at; CancelledBy get by;/// 노쇼 패널티 비율(설계 7장: 100).
 int get penaltyRate; int get refundAmount;
/// Create a copy of ReservationNoShow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationNoShowCopyWith<ReservationNoShow> get copyWith => _$ReservationNoShowCopyWithImpl<ReservationNoShow>(this as ReservationNoShow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationNoShow&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.penaltyRate, penaltyRate) || other.penaltyRate == penaltyRate)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,at,by,penaltyRate,refundAmount);

@override
String toString() {
  return 'ReservationNoShow(at: $at, by: $by, penaltyRate: $penaltyRate, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class $ReservationNoShowCopyWith<$Res>  {
  factory $ReservationNoShowCopyWith(ReservationNoShow value, $Res Function(ReservationNoShow) _then) = _$ReservationNoShowCopyWithImpl;
@useResult
$Res call({
 DateTime? at, CancelledBy by, int penaltyRate, int refundAmount
});




}
/// @nodoc
class _$ReservationNoShowCopyWithImpl<$Res>
    implements $ReservationNoShowCopyWith<$Res> {
  _$ReservationNoShowCopyWithImpl(this._self, this._then);

  final ReservationNoShow _self;
  final $Res Function(ReservationNoShow) _then;

/// Create a copy of ReservationNoShow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = freezed,Object? by = null,Object? penaltyRate = null,Object? refundAmount = null,}) {
  return _then(_self.copyWith(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as CancelledBy,penaltyRate: null == penaltyRate ? _self.penaltyRate : penaltyRate // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationNoShow].
extension ReservationNoShowPatterns on ReservationNoShow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationNoShow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationNoShow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationNoShow value)  $default,){
final _that = this;
switch (_that) {
case _ReservationNoShow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationNoShow value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationNoShow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? at,  CancelledBy by,  int penaltyRate,  int refundAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationNoShow() when $default != null:
return $default(_that.at,_that.by,_that.penaltyRate,_that.refundAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? at,  CancelledBy by,  int penaltyRate,  int refundAmount)  $default,) {final _that = this;
switch (_that) {
case _ReservationNoShow():
return $default(_that.at,_that.by,_that.penaltyRate,_that.refundAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? at,  CancelledBy by,  int penaltyRate,  int refundAmount)?  $default,) {final _that = this;
switch (_that) {
case _ReservationNoShow() when $default != null:
return $default(_that.at,_that.by,_that.penaltyRate,_that.refundAmount);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationNoShow implements ReservationNoShow {
  const _ReservationNoShow({this.at, this.by = CancelledBy.unknown, this.penaltyRate = 100, this.refundAmount = 0});
  

@override final  DateTime? at;
@override@JsonKey() final  CancelledBy by;
/// 노쇼 패널티 비율(설계 7장: 100).
@override@JsonKey() final  int penaltyRate;
@override@JsonKey() final  int refundAmount;

/// Create a copy of ReservationNoShow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationNoShowCopyWith<_ReservationNoShow> get copyWith => __$ReservationNoShowCopyWithImpl<_ReservationNoShow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationNoShow&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.penaltyRate, penaltyRate) || other.penaltyRate == penaltyRate)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount));
}


@override
int get hashCode => Object.hash(runtimeType,at,by,penaltyRate,refundAmount);

@override
String toString() {
  return 'ReservationNoShow(at: $at, by: $by, penaltyRate: $penaltyRate, refundAmount: $refundAmount)';
}


}

/// @nodoc
abstract mixin class _$ReservationNoShowCopyWith<$Res> implements $ReservationNoShowCopyWith<$Res> {
  factory _$ReservationNoShowCopyWith(_ReservationNoShow value, $Res Function(_ReservationNoShow) _then) = __$ReservationNoShowCopyWithImpl;
@override @useResult
$Res call({
 DateTime? at, CancelledBy by, int penaltyRate, int refundAmount
});




}
/// @nodoc
class __$ReservationNoShowCopyWithImpl<$Res>
    implements _$ReservationNoShowCopyWith<$Res> {
  __$ReservationNoShowCopyWithImpl(this._self, this._then);

  final _ReservationNoShow _self;
  final $Res Function(_ReservationNoShow) _then;

/// Create a copy of ReservationNoShow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = freezed,Object? by = null,Object? penaltyRate = null,Object? refundAmount = null,}) {
  return _then(_ReservationNoShow(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as CancelledBy,penaltyRate: null == penaltyRate ? _self.penaltyRate : penaltyRate // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReservationDayModel {

 String get date;/// 날짜 자체 마감.
 bool get closed;/// 수동 마감 테이블.
 List<String> get closedTables;/// `{ tableId: 상태 }`.
 Map<String, ReservationDayTable> get tables; int get bookedCount; int get holdCount; DateTime? get updatedAt;
/// Create a copy of ReservationDayModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationDayModelCopyWith<ReservationDayModel> get copyWith => _$ReservationDayModelCopyWithImpl<ReservationDayModel>(this as ReservationDayModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.closed, closed) || other.closed == closed)&&const DeepCollectionEquality().equals(other.closedTables, closedTables)&&const DeepCollectionEquality().equals(other.tables, tables)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.holdCount, holdCount) || other.holdCount == holdCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,date,closed,const DeepCollectionEquality().hash(closedTables),const DeepCollectionEquality().hash(tables),bookedCount,holdCount,updatedAt);

@override
String toString() {
  return 'ReservationDayModel(date: $date, closed: $closed, closedTables: $closedTables, tables: $tables, bookedCount: $bookedCount, holdCount: $holdCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReservationDayModelCopyWith<$Res>  {
  factory $ReservationDayModelCopyWith(ReservationDayModel value, $Res Function(ReservationDayModel) _then) = _$ReservationDayModelCopyWithImpl;
@useResult
$Res call({
 String date, bool closed, List<String> closedTables, Map<String, ReservationDayTable> tables, int bookedCount, int holdCount, DateTime? updatedAt
});




}
/// @nodoc
class _$ReservationDayModelCopyWithImpl<$Res>
    implements $ReservationDayModelCopyWith<$Res> {
  _$ReservationDayModelCopyWithImpl(this._self, this._then);

  final ReservationDayModel _self;
  final $Res Function(ReservationDayModel) _then;

/// Create a copy of ReservationDayModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? closed = null,Object? closedTables = null,Object? tables = null,Object? bookedCount = null,Object? holdCount = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,closedTables: null == closedTables ? _self.closedTables : closedTables // ignore: cast_nullable_to_non_nullable
as List<String>,tables: null == tables ? _self.tables : tables // ignore: cast_nullable_to_non_nullable
as Map<String, ReservationDayTable>,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,holdCount: null == holdCount ? _self.holdCount : holdCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationDayModel].
extension ReservationDayModelPatterns on ReservationDayModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationDayModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationDayModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationDayModel value)  $default,){
final _that = this;
switch (_that) {
case _ReservationDayModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationDayModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationDayModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  bool closed,  List<String> closedTables,  Map<String, ReservationDayTable> tables,  int bookedCount,  int holdCount,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationDayModel() when $default != null:
return $default(_that.date,_that.closed,_that.closedTables,_that.tables,_that.bookedCount,_that.holdCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  bool closed,  List<String> closedTables,  Map<String, ReservationDayTable> tables,  int bookedCount,  int holdCount,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReservationDayModel():
return $default(_that.date,_that.closed,_that.closedTables,_that.tables,_that.bookedCount,_that.holdCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  bool closed,  List<String> closedTables,  Map<String, ReservationDayTable> tables,  int bookedCount,  int holdCount,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReservationDayModel() when $default != null:
return $default(_that.date,_that.closed,_that.closedTables,_that.tables,_that.bookedCount,_that.holdCount,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationDayModel extends ReservationDayModel {
  const _ReservationDayModel({required this.date, this.closed = false, final  List<String> closedTables = const <String>[], final  Map<String, ReservationDayTable> tables = const <String, ReservationDayTable>{}, this.bookedCount = 0, this.holdCount = 0, this.updatedAt}): _closedTables = closedTables,_tables = tables,super._();
  

@override final  String date;
/// 날짜 자체 마감.
@override@JsonKey() final  bool closed;
/// 수동 마감 테이블.
 final  List<String> _closedTables;
/// 수동 마감 테이블.
@override@JsonKey() List<String> get closedTables {
  if (_closedTables is EqualUnmodifiableListView) return _closedTables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_closedTables);
}

/// `{ tableId: 상태 }`.
 final  Map<String, ReservationDayTable> _tables;
/// `{ tableId: 상태 }`.
@override@JsonKey() Map<String, ReservationDayTable> get tables {
  if (_tables is EqualUnmodifiableMapView) return _tables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tables);
}

@override@JsonKey() final  int bookedCount;
@override@JsonKey() final  int holdCount;
@override final  DateTime? updatedAt;

/// Create a copy of ReservationDayModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationDayModelCopyWith<_ReservationDayModel> get copyWith => __$ReservationDayModelCopyWithImpl<_ReservationDayModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationDayModel&&(identical(other.date, date) || other.date == date)&&(identical(other.closed, closed) || other.closed == closed)&&const DeepCollectionEquality().equals(other._closedTables, _closedTables)&&const DeepCollectionEquality().equals(other._tables, _tables)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.holdCount, holdCount) || other.holdCount == holdCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,date,closed,const DeepCollectionEquality().hash(_closedTables),const DeepCollectionEquality().hash(_tables),bookedCount,holdCount,updatedAt);

@override
String toString() {
  return 'ReservationDayModel(date: $date, closed: $closed, closedTables: $closedTables, tables: $tables, bookedCount: $bookedCount, holdCount: $holdCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReservationDayModelCopyWith<$Res> implements $ReservationDayModelCopyWith<$Res> {
  factory _$ReservationDayModelCopyWith(_ReservationDayModel value, $Res Function(_ReservationDayModel) _then) = __$ReservationDayModelCopyWithImpl;
@override @useResult
$Res call({
 String date, bool closed, List<String> closedTables, Map<String, ReservationDayTable> tables, int bookedCount, int holdCount, DateTime? updatedAt
});




}
/// @nodoc
class __$ReservationDayModelCopyWithImpl<$Res>
    implements _$ReservationDayModelCopyWith<$Res> {
  __$ReservationDayModelCopyWithImpl(this._self, this._then);

  final _ReservationDayModel _self;
  final $Res Function(_ReservationDayModel) _then;

/// Create a copy of ReservationDayModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? closed = null,Object? closedTables = null,Object? tables = null,Object? bookedCount = null,Object? holdCount = null,Object? updatedAt = freezed,}) {
  return _then(_ReservationDayModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,closedTables: null == closedTables ? _self._closedTables : closedTables // ignore: cast_nullable_to_non_nullable
as List<String>,tables: null == tables ? _self._tables : tables // ignore: cast_nullable_to_non_nullable
as Map<String, ReservationDayTable>,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,holdCount: null == holdCount ? _self.holdCount : holdCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ReservationDayTable {

 TableHoldStatus get status; String get reservationId; int get people; String get slot; DateTime? get holdUntil;
/// Create a copy of ReservationDayTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationDayTableCopyWith<ReservationDayTable> get copyWith => _$ReservationDayTableCopyWithImpl<ReservationDayTable>(this as ReservationDayTable, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationDayTable&&(identical(other.status, status) || other.status == status)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.people, people) || other.people == people)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.holdUntil, holdUntil) || other.holdUntil == holdUntil));
}


@override
int get hashCode => Object.hash(runtimeType,status,reservationId,people,slot,holdUntil);

@override
String toString() {
  return 'ReservationDayTable(status: $status, reservationId: $reservationId, people: $people, slot: $slot, holdUntil: $holdUntil)';
}


}

/// @nodoc
abstract mixin class $ReservationDayTableCopyWith<$Res>  {
  factory $ReservationDayTableCopyWith(ReservationDayTable value, $Res Function(ReservationDayTable) _then) = _$ReservationDayTableCopyWithImpl;
@useResult
$Res call({
 TableHoldStatus status, String reservationId, int people, String slot, DateTime? holdUntil
});




}
/// @nodoc
class _$ReservationDayTableCopyWithImpl<$Res>
    implements $ReservationDayTableCopyWith<$Res> {
  _$ReservationDayTableCopyWithImpl(this._self, this._then);

  final ReservationDayTable _self;
  final $Res Function(ReservationDayTable) _then;

/// Create a copy of ReservationDayTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reservationId = null,Object? people = null,Object? slot = null,Object? holdUntil = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableHoldStatus,reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,holdUntil: freezed == holdUntil ? _self.holdUntil : holdUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationDayTable].
extension ReservationDayTablePatterns on ReservationDayTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationDayTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationDayTable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationDayTable value)  $default,){
final _that = this;
switch (_that) {
case _ReservationDayTable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationDayTable value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationDayTable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TableHoldStatus status,  String reservationId,  int people,  String slot,  DateTime? holdUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationDayTable() when $default != null:
return $default(_that.status,_that.reservationId,_that.people,_that.slot,_that.holdUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TableHoldStatus status,  String reservationId,  int people,  String slot,  DateTime? holdUntil)  $default,) {final _that = this;
switch (_that) {
case _ReservationDayTable():
return $default(_that.status,_that.reservationId,_that.people,_that.slot,_that.holdUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TableHoldStatus status,  String reservationId,  int people,  String slot,  DateTime? holdUntil)?  $default,) {final _that = this;
switch (_that) {
case _ReservationDayTable() when $default != null:
return $default(_that.status,_that.reservationId,_that.people,_that.slot,_that.holdUntil);case _:
  return null;

}
}

}

/// @nodoc


class _ReservationDayTable implements ReservationDayTable {
  const _ReservationDayTable({this.status = TableHoldStatus.unknown, this.reservationId = '', this.people = 0, this.slot = '', this.holdUntil});
  

@override@JsonKey() final  TableHoldStatus status;
@override@JsonKey() final  String reservationId;
@override@JsonKey() final  int people;
@override@JsonKey() final  String slot;
@override final  DateTime? holdUntil;

/// Create a copy of ReservationDayTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationDayTableCopyWith<_ReservationDayTable> get copyWith => __$ReservationDayTableCopyWithImpl<_ReservationDayTable>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationDayTable&&(identical(other.status, status) || other.status == status)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.people, people) || other.people == people)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.holdUntil, holdUntil) || other.holdUntil == holdUntil));
}


@override
int get hashCode => Object.hash(runtimeType,status,reservationId,people,slot,holdUntil);

@override
String toString() {
  return 'ReservationDayTable(status: $status, reservationId: $reservationId, people: $people, slot: $slot, holdUntil: $holdUntil)';
}


}

/// @nodoc
abstract mixin class _$ReservationDayTableCopyWith<$Res> implements $ReservationDayTableCopyWith<$Res> {
  factory _$ReservationDayTableCopyWith(_ReservationDayTable value, $Res Function(_ReservationDayTable) _then) = __$ReservationDayTableCopyWithImpl;
@override @useResult
$Res call({
 TableHoldStatus status, String reservationId, int people, String slot, DateTime? holdUntil
});




}
/// @nodoc
class __$ReservationDayTableCopyWithImpl<$Res>
    implements _$ReservationDayTableCopyWith<$Res> {
  __$ReservationDayTableCopyWithImpl(this._self, this._then);

  final _ReservationDayTable _self;
  final $Res Function(_ReservationDayTable) _then;

/// Create a copy of ReservationDayTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reservationId = null,Object? people = null,Object? slot = null,Object? holdUntil = freezed,}) {
  return _then(_ReservationDayTable(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableHoldStatus,reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,holdUntil: freezed == holdUntil ? _self.holdUntil : holdUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
