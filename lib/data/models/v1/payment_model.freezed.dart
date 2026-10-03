// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentModel {

 String get paymentId; String get uid; String get clubId; PaymentKind get kind; EntryRef get targetRef;/// 서버 확정 금액.
 int get amount; PaymentMethod get method; String get cardCompany;/// 0 = 일시불.
 int get installment; PaymentStatus get status;/// 앱이 보여 줘도 되는 PG 값만.
 String get approvalNo; String get cardMasked; String get receiptUrl;/// 실패 사유 — 'CARD_DECLINED(051)'.
 String get failReason;/// createdAt + 15분. 미결제 만료.
 DateTime? get expiresAt; int get refundedAmount; DateTime get createdAt; DateTime? get paidAt; DateTime? get updatedAt;
/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<PaymentModel> get copyWith => _$PaymentModelCopyWithImpl<PaymentModel>(this as PaymentModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentModel&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetRef, targetRef) || other.targetRef == targetRef)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.installment, installment) || other.installment == installment)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvalNo, approvalNo) || other.approvalNo == approvalNo)&&(identical(other.cardMasked, cardMasked) || other.cardMasked == cardMasked)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.failReason, failReason) || other.failReason == failReason)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.refundedAmount, refundedAmount) || other.refundedAmount == refundedAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,paymentId,uid,clubId,kind,targetRef,amount,method,cardCompany,installment,status,approvalNo,cardMasked,receiptUrl,failReason,expiresAt,refundedAmount,createdAt,paidAt,updatedAt]);

@override
String toString() {
  return 'PaymentModel(paymentId: $paymentId, uid: $uid, clubId: $clubId, kind: $kind, targetRef: $targetRef, amount: $amount, method: $method, cardCompany: $cardCompany, installment: $installment, status: $status, approvalNo: $approvalNo, cardMasked: $cardMasked, receiptUrl: $receiptUrl, failReason: $failReason, expiresAt: $expiresAt, refundedAmount: $refundedAmount, createdAt: $createdAt, paidAt: $paidAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PaymentModelCopyWith<$Res>  {
  factory $PaymentModelCopyWith(PaymentModel value, $Res Function(PaymentModel) _then) = _$PaymentModelCopyWithImpl;
@useResult
$Res call({
 String paymentId, String uid, String clubId, PaymentKind kind, EntryRef targetRef, int amount, PaymentMethod method, String cardCompany, int installment, PaymentStatus status, String approvalNo, String cardMasked, String receiptUrl, String failReason, DateTime? expiresAt, int refundedAmount, DateTime createdAt, DateTime? paidAt, DateTime? updatedAt
});


$EntryRefCopyWith<$Res> get targetRef;

}
/// @nodoc
class _$PaymentModelCopyWithImpl<$Res>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._self, this._then);

  final PaymentModel _self;
  final $Res Function(PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentId = null,Object? uid = null,Object? clubId = null,Object? kind = null,Object? targetRef = null,Object? amount = null,Object? method = null,Object? cardCompany = null,Object? installment = null,Object? status = null,Object? approvalNo = null,Object? cardMasked = null,Object? receiptUrl = null,Object? failReason = null,Object? expiresAt = freezed,Object? refundedAmount = null,Object? createdAt = null,Object? paidAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaymentKind,targetRef: null == targetRef ? _self.targetRef : targetRef // ignore: cast_nullable_to_non_nullable
as EntryRef,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,cardCompany: null == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,approvalNo: null == approvalNo ? _self.approvalNo : approvalNo // ignore: cast_nullable_to_non_nullable
as String,cardMasked: null == cardMasked ? _self.cardMasked : cardMasked // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,failReason: null == failReason ? _self.failReason : failReason // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAmount: null == refundedAmount ? _self.refundedAmount : refundedAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get targetRef {
  
  return $EntryRefCopyWith<$Res>(_self.targetRef, (value) {
    return _then(_self.copyWith(targetRef: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentModel].
extension PaymentModelPatterns on PaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String paymentId,  String uid,  String clubId,  PaymentKind kind,  EntryRef targetRef,  int amount,  PaymentMethod method,  String cardCompany,  int installment,  PaymentStatus status,  String approvalNo,  String cardMasked,  String receiptUrl,  String failReason,  DateTime? expiresAt,  int refundedAmount,  DateTime createdAt,  DateTime? paidAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.paymentId,_that.uid,_that.clubId,_that.kind,_that.targetRef,_that.amount,_that.method,_that.cardCompany,_that.installment,_that.status,_that.approvalNo,_that.cardMasked,_that.receiptUrl,_that.failReason,_that.expiresAt,_that.refundedAmount,_that.createdAt,_that.paidAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String paymentId,  String uid,  String clubId,  PaymentKind kind,  EntryRef targetRef,  int amount,  PaymentMethod method,  String cardCompany,  int installment,  PaymentStatus status,  String approvalNo,  String cardMasked,  String receiptUrl,  String failReason,  DateTime? expiresAt,  int refundedAmount,  DateTime createdAt,  DateTime? paidAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentModel():
return $default(_that.paymentId,_that.uid,_that.clubId,_that.kind,_that.targetRef,_that.amount,_that.method,_that.cardCompany,_that.installment,_that.status,_that.approvalNo,_that.cardMasked,_that.receiptUrl,_that.failReason,_that.expiresAt,_that.refundedAmount,_that.createdAt,_that.paidAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String paymentId,  String uid,  String clubId,  PaymentKind kind,  EntryRef targetRef,  int amount,  PaymentMethod method,  String cardCompany,  int installment,  PaymentStatus status,  String approvalNo,  String cardMasked,  String receiptUrl,  String failReason,  DateTime? expiresAt,  int refundedAmount,  DateTime createdAt,  DateTime? paidAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.paymentId,_that.uid,_that.clubId,_that.kind,_that.targetRef,_that.amount,_that.method,_that.cardCompany,_that.installment,_that.status,_that.approvalNo,_that.cardMasked,_that.receiptUrl,_that.failReason,_that.expiresAt,_that.refundedAmount,_that.createdAt,_that.paidAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentModel extends PaymentModel {
  const _PaymentModel({required this.paymentId, required this.uid, required this.clubId, this.kind = PaymentKind.unknown, this.targetRef = const EntryRef(), this.amount = 0, this.method = PaymentMethod.unknown, this.cardCompany = '', this.installment = 0, this.status = PaymentStatus.unknown, this.approvalNo = '', this.cardMasked = '', this.receiptUrl = '', this.failReason = '', this.expiresAt, this.refundedAmount = 0, required this.createdAt, this.paidAt, this.updatedAt}): super._();
  

@override final  String paymentId;
@override final  String uid;
@override final  String clubId;
@override@JsonKey() final  PaymentKind kind;
@override@JsonKey() final  EntryRef targetRef;
/// 서버 확정 금액.
@override@JsonKey() final  int amount;
@override@JsonKey() final  PaymentMethod method;
@override@JsonKey() final  String cardCompany;
/// 0 = 일시불.
@override@JsonKey() final  int installment;
@override@JsonKey() final  PaymentStatus status;
/// 앱이 보여 줘도 되는 PG 값만.
@override@JsonKey() final  String approvalNo;
@override@JsonKey() final  String cardMasked;
@override@JsonKey() final  String receiptUrl;
/// 실패 사유 — 'CARD_DECLINED(051)'.
@override@JsonKey() final  String failReason;
/// createdAt + 15분. 미결제 만료.
@override final  DateTime? expiresAt;
@override@JsonKey() final  int refundedAmount;
@override final  DateTime createdAt;
@override final  DateTime? paidAt;
@override final  DateTime? updatedAt;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentModelCopyWith<_PaymentModel> get copyWith => __$PaymentModelCopyWithImpl<_PaymentModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentModel&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetRef, targetRef) || other.targetRef == targetRef)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.installment, installment) || other.installment == installment)&&(identical(other.status, status) || other.status == status)&&(identical(other.approvalNo, approvalNo) || other.approvalNo == approvalNo)&&(identical(other.cardMasked, cardMasked) || other.cardMasked == cardMasked)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.failReason, failReason) || other.failReason == failReason)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.refundedAmount, refundedAmount) || other.refundedAmount == refundedAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,paymentId,uid,clubId,kind,targetRef,amount,method,cardCompany,installment,status,approvalNo,cardMasked,receiptUrl,failReason,expiresAt,refundedAmount,createdAt,paidAt,updatedAt]);

@override
String toString() {
  return 'PaymentModel(paymentId: $paymentId, uid: $uid, clubId: $clubId, kind: $kind, targetRef: $targetRef, amount: $amount, method: $method, cardCompany: $cardCompany, installment: $installment, status: $status, approvalNo: $approvalNo, cardMasked: $cardMasked, receiptUrl: $receiptUrl, failReason: $failReason, expiresAt: $expiresAt, refundedAmount: $refundedAmount, createdAt: $createdAt, paidAt: $paidAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentModelCopyWith<$Res> implements $PaymentModelCopyWith<$Res> {
  factory _$PaymentModelCopyWith(_PaymentModel value, $Res Function(_PaymentModel) _then) = __$PaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String paymentId, String uid, String clubId, PaymentKind kind, EntryRef targetRef, int amount, PaymentMethod method, String cardCompany, int installment, PaymentStatus status, String approvalNo, String cardMasked, String receiptUrl, String failReason, DateTime? expiresAt, int refundedAmount, DateTime createdAt, DateTime? paidAt, DateTime? updatedAt
});


@override $EntryRefCopyWith<$Res> get targetRef;

}
/// @nodoc
class __$PaymentModelCopyWithImpl<$Res>
    implements _$PaymentModelCopyWith<$Res> {
  __$PaymentModelCopyWithImpl(this._self, this._then);

  final _PaymentModel _self;
  final $Res Function(_PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentId = null,Object? uid = null,Object? clubId = null,Object? kind = null,Object? targetRef = null,Object? amount = null,Object? method = null,Object? cardCompany = null,Object? installment = null,Object? status = null,Object? approvalNo = null,Object? cardMasked = null,Object? receiptUrl = null,Object? failReason = null,Object? expiresAt = freezed,Object? refundedAmount = null,Object? createdAt = null,Object? paidAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PaymentModel(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaymentKind,targetRef: null == targetRef ? _self.targetRef : targetRef // ignore: cast_nullable_to_non_nullable
as EntryRef,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,cardCompany: null == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,approvalNo: null == approvalNo ? _self.approvalNo : approvalNo // ignore: cast_nullable_to_non_nullable
as String,cardMasked: null == cardMasked ? _self.cardMasked : cardMasked // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,failReason: null == failReason ? _self.failReason : failReason // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,refundedAmount: null == refundedAmount ? _self.refundedAmount : refundedAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get targetRef {
  
  return $EntryRefCopyWith<$Res>(_self.targetRef, (value) {
    return _then(_self.copyWith(targetRef: value));
  });
}
}

/// @nodoc
mixin _$RefundModel {

 String get refundId; String get paymentId; String get uid; String get clubId; EntryRef get targetRef; RefundReason get reason;/// 패널티를 뺀 환불액.
 int get amount; List<PenaltyLine> get penalties; RefundStatus get status;/// Cloud Tasks 재시도 횟수(1m · 5m · 30m · 2h · 12h).
 int get attempts; String get lastError; DateTime? get nextRetryAt; DateTime get createdAt; DateTime? get completedAt;
/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefundModelCopyWith<RefundModel> get copyWith => _$RefundModelCopyWithImpl<RefundModel>(this as RefundModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefundModel&&(identical(other.refundId, refundId) || other.refundId == refundId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.targetRef, targetRef) || other.targetRef == targetRef)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other.penalties, penalties)&&(identical(other.status, status) || other.status == status)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.nextRetryAt, nextRetryAt) || other.nextRetryAt == nextRetryAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,refundId,paymentId,uid,clubId,targetRef,reason,amount,const DeepCollectionEquality().hash(penalties),status,attempts,lastError,nextRetryAt,createdAt,completedAt);

@override
String toString() {
  return 'RefundModel(refundId: $refundId, paymentId: $paymentId, uid: $uid, clubId: $clubId, targetRef: $targetRef, reason: $reason, amount: $amount, penalties: $penalties, status: $status, attempts: $attempts, lastError: $lastError, nextRetryAt: $nextRetryAt, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $RefundModelCopyWith<$Res>  {
  factory $RefundModelCopyWith(RefundModel value, $Res Function(RefundModel) _then) = _$RefundModelCopyWithImpl;
@useResult
$Res call({
 String refundId, String paymentId, String uid, String clubId, EntryRef targetRef, RefundReason reason, int amount, List<PenaltyLine> penalties, RefundStatus status, int attempts, String lastError, DateTime? nextRetryAt, DateTime createdAt, DateTime? completedAt
});


$EntryRefCopyWith<$Res> get targetRef;

}
/// @nodoc
class _$RefundModelCopyWithImpl<$Res>
    implements $RefundModelCopyWith<$Res> {
  _$RefundModelCopyWithImpl(this._self, this._then);

  final RefundModel _self;
  final $Res Function(RefundModel) _then;

/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refundId = null,Object? paymentId = null,Object? uid = null,Object? clubId = null,Object? targetRef = null,Object? reason = null,Object? amount = null,Object? penalties = null,Object? status = null,Object? attempts = null,Object? lastError = null,Object? nextRetryAt = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
refundId: null == refundId ? _self.refundId : refundId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,targetRef: null == targetRef ? _self.targetRef : targetRef // ignore: cast_nullable_to_non_nullable
as EntryRef,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RefundReason,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,penalties: null == penalties ? _self.penalties : penalties // ignore: cast_nullable_to_non_nullable
as List<PenaltyLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lastError: null == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String,nextRetryAt: freezed == nextRetryAt ? _self.nextRetryAt : nextRetryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get targetRef {
  
  return $EntryRefCopyWith<$Res>(_self.targetRef, (value) {
    return _then(_self.copyWith(targetRef: value));
  });
}
}


/// Adds pattern-matching-related methods to [RefundModel].
extension RefundModelPatterns on RefundModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefundModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefundModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefundModel value)  $default,){
final _that = this;
switch (_that) {
case _RefundModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefundModel value)?  $default,){
final _that = this;
switch (_that) {
case _RefundModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String refundId,  String paymentId,  String uid,  String clubId,  EntryRef targetRef,  RefundReason reason,  int amount,  List<PenaltyLine> penalties,  RefundStatus status,  int attempts,  String lastError,  DateTime? nextRetryAt,  DateTime createdAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefundModel() when $default != null:
return $default(_that.refundId,_that.paymentId,_that.uid,_that.clubId,_that.targetRef,_that.reason,_that.amount,_that.penalties,_that.status,_that.attempts,_that.lastError,_that.nextRetryAt,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String refundId,  String paymentId,  String uid,  String clubId,  EntryRef targetRef,  RefundReason reason,  int amount,  List<PenaltyLine> penalties,  RefundStatus status,  int attempts,  String lastError,  DateTime? nextRetryAt,  DateTime createdAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _RefundModel():
return $default(_that.refundId,_that.paymentId,_that.uid,_that.clubId,_that.targetRef,_that.reason,_that.amount,_that.penalties,_that.status,_that.attempts,_that.lastError,_that.nextRetryAt,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String refundId,  String paymentId,  String uid,  String clubId,  EntryRef targetRef,  RefundReason reason,  int amount,  List<PenaltyLine> penalties,  RefundStatus status,  int attempts,  String lastError,  DateTime? nextRetryAt,  DateTime createdAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _RefundModel() when $default != null:
return $default(_that.refundId,_that.paymentId,_that.uid,_that.clubId,_that.targetRef,_that.reason,_that.amount,_that.penalties,_that.status,_that.attempts,_that.lastError,_that.nextRetryAt,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RefundModel extends RefundModel {
  const _RefundModel({required this.refundId, required this.paymentId, required this.uid, required this.clubId, this.targetRef = const EntryRef(), this.reason = RefundReason.unknown, this.amount = 0, final  List<PenaltyLine> penalties = const <PenaltyLine>[], this.status = RefundStatus.unknown, this.attempts = 0, this.lastError = '', this.nextRetryAt, required this.createdAt, this.completedAt}): _penalties = penalties,super._();
  

@override final  String refundId;
@override final  String paymentId;
@override final  String uid;
@override final  String clubId;
@override@JsonKey() final  EntryRef targetRef;
@override@JsonKey() final  RefundReason reason;
/// 패널티를 뺀 환불액.
@override@JsonKey() final  int amount;
 final  List<PenaltyLine> _penalties;
@override@JsonKey() List<PenaltyLine> get penalties {
  if (_penalties is EqualUnmodifiableListView) return _penalties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_penalties);
}

@override@JsonKey() final  RefundStatus status;
/// Cloud Tasks 재시도 횟수(1m · 5m · 30m · 2h · 12h).
@override@JsonKey() final  int attempts;
@override@JsonKey() final  String lastError;
@override final  DateTime? nextRetryAt;
@override final  DateTime createdAt;
@override final  DateTime? completedAt;

/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefundModelCopyWith<_RefundModel> get copyWith => __$RefundModelCopyWithImpl<_RefundModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefundModel&&(identical(other.refundId, refundId) || other.refundId == refundId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.targetRef, targetRef) || other.targetRef == targetRef)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other._penalties, _penalties)&&(identical(other.status, status) || other.status == status)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.nextRetryAt, nextRetryAt) || other.nextRetryAt == nextRetryAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,refundId,paymentId,uid,clubId,targetRef,reason,amount,const DeepCollectionEquality().hash(_penalties),status,attempts,lastError,nextRetryAt,createdAt,completedAt);

@override
String toString() {
  return 'RefundModel(refundId: $refundId, paymentId: $paymentId, uid: $uid, clubId: $clubId, targetRef: $targetRef, reason: $reason, amount: $amount, penalties: $penalties, status: $status, attempts: $attempts, lastError: $lastError, nextRetryAt: $nextRetryAt, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$RefundModelCopyWith<$Res> implements $RefundModelCopyWith<$Res> {
  factory _$RefundModelCopyWith(_RefundModel value, $Res Function(_RefundModel) _then) = __$RefundModelCopyWithImpl;
@override @useResult
$Res call({
 String refundId, String paymentId, String uid, String clubId, EntryRef targetRef, RefundReason reason, int amount, List<PenaltyLine> penalties, RefundStatus status, int attempts, String lastError, DateTime? nextRetryAt, DateTime createdAt, DateTime? completedAt
});


@override $EntryRefCopyWith<$Res> get targetRef;

}
/// @nodoc
class __$RefundModelCopyWithImpl<$Res>
    implements _$RefundModelCopyWith<$Res> {
  __$RefundModelCopyWithImpl(this._self, this._then);

  final _RefundModel _self;
  final $Res Function(_RefundModel) _then;

/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refundId = null,Object? paymentId = null,Object? uid = null,Object? clubId = null,Object? targetRef = null,Object? reason = null,Object? amount = null,Object? penalties = null,Object? status = null,Object? attempts = null,Object? lastError = null,Object? nextRetryAt = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_RefundModel(
refundId: null == refundId ? _self.refundId : refundId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,targetRef: null == targetRef ? _self.targetRef : targetRef // ignore: cast_nullable_to_non_nullable
as EntryRef,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RefundReason,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,penalties: null == penalties ? _self._penalties : penalties // ignore: cast_nullable_to_non_nullable
as List<PenaltyLine>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lastError: null == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String,nextRetryAt: freezed == nextRetryAt ? _self.nextRetryAt : nextRetryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of RefundModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get targetRef {
  
  return $EntryRefCopyWith<$Res>(_self.targetRef, (value) {
    return _then(_self.copyWith(targetRef: value));
  });
}
}

// dart format on
