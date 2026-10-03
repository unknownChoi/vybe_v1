// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'v1_shared.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketPaymentSummary {

 PaymentStatus get status; PaymentMethod get method;/// 카드사(예: '신한').
 String get cardCompany;/// 할부 개월. 0 = 일시불.
 int get installment; DateTime? get paidAt;/// 승인번호.
 String get approvalNo;/// 마스킹된 카드번호.
 String get cardMasked; DateTime? get approvedAt;/// `history.payment` 에만 있는 금액.
 int get amount;
/// Create a copy of TicketPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketPaymentSummaryCopyWith<TicketPaymentSummary> get copyWith => _$TicketPaymentSummaryCopyWithImpl<TicketPaymentSummary>(this as TicketPaymentSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketPaymentSummary&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.installment, installment) || other.installment == installment)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.approvalNo, approvalNo) || other.approvalNo == approvalNo)&&(identical(other.cardMasked, cardMasked) || other.cardMasked == cardMasked)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,status,method,cardCompany,installment,paidAt,approvalNo,cardMasked,approvedAt,amount);

@override
String toString() {
  return 'TicketPaymentSummary(status: $status, method: $method, cardCompany: $cardCompany, installment: $installment, paidAt: $paidAt, approvalNo: $approvalNo, cardMasked: $cardMasked, approvedAt: $approvedAt, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $TicketPaymentSummaryCopyWith<$Res>  {
  factory $TicketPaymentSummaryCopyWith(TicketPaymentSummary value, $Res Function(TicketPaymentSummary) _then) = _$TicketPaymentSummaryCopyWithImpl;
@useResult
$Res call({
 PaymentStatus status, PaymentMethod method, String cardCompany, int installment, DateTime? paidAt, String approvalNo, String cardMasked, DateTime? approvedAt, int amount
});




}
/// @nodoc
class _$TicketPaymentSummaryCopyWithImpl<$Res>
    implements $TicketPaymentSummaryCopyWith<$Res> {
  _$TicketPaymentSummaryCopyWithImpl(this._self, this._then);

  final TicketPaymentSummary _self;
  final $Res Function(TicketPaymentSummary) _then;

/// Create a copy of TicketPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? method = null,Object? cardCompany = null,Object? installment = null,Object? paidAt = freezed,Object? approvalNo = null,Object? cardMasked = null,Object? approvedAt = freezed,Object? amount = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,cardCompany: null == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalNo: null == approvalNo ? _self.approvalNo : approvalNo // ignore: cast_nullable_to_non_nullable
as String,cardMasked: null == cardMasked ? _self.cardMasked : cardMasked // ignore: cast_nullable_to_non_nullable
as String,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketPaymentSummary].
extension TicketPaymentSummaryPatterns on TicketPaymentSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketPaymentSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketPaymentSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketPaymentSummary value)  $default,){
final _that = this;
switch (_that) {
case _TicketPaymentSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketPaymentSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TicketPaymentSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaymentStatus status,  PaymentMethod method,  String cardCompany,  int installment,  DateTime? paidAt,  String approvalNo,  String cardMasked,  DateTime? approvedAt,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketPaymentSummary() when $default != null:
return $default(_that.status,_that.method,_that.cardCompany,_that.installment,_that.paidAt,_that.approvalNo,_that.cardMasked,_that.approvedAt,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaymentStatus status,  PaymentMethod method,  String cardCompany,  int installment,  DateTime? paidAt,  String approvalNo,  String cardMasked,  DateTime? approvedAt,  int amount)  $default,) {final _that = this;
switch (_that) {
case _TicketPaymentSummary():
return $default(_that.status,_that.method,_that.cardCompany,_that.installment,_that.paidAt,_that.approvalNo,_that.cardMasked,_that.approvedAt,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaymentStatus status,  PaymentMethod method,  String cardCompany,  int installment,  DateTime? paidAt,  String approvalNo,  String cardMasked,  DateTime? approvedAt,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _TicketPaymentSummary() when $default != null:
return $default(_that.status,_that.method,_that.cardCompany,_that.installment,_that.paidAt,_that.approvalNo,_that.cardMasked,_that.approvedAt,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _TicketPaymentSummary extends TicketPaymentSummary {
  const _TicketPaymentSummary({this.status = PaymentStatus.unknown, this.method = PaymentMethod.unknown, this.cardCompany = '', this.installment = 0, this.paidAt, this.approvalNo = '', this.cardMasked = '', this.approvedAt, this.amount = 0}): super._();
  

@override@JsonKey() final  PaymentStatus status;
@override@JsonKey() final  PaymentMethod method;
/// 카드사(예: '신한').
@override@JsonKey() final  String cardCompany;
/// 할부 개월. 0 = 일시불.
@override@JsonKey() final  int installment;
@override final  DateTime? paidAt;
/// 승인번호.
@override@JsonKey() final  String approvalNo;
/// 마스킹된 카드번호.
@override@JsonKey() final  String cardMasked;
@override final  DateTime? approvedAt;
/// `history.payment` 에만 있는 금액.
@override@JsonKey() final  int amount;

/// Create a copy of TicketPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketPaymentSummaryCopyWith<_TicketPaymentSummary> get copyWith => __$TicketPaymentSummaryCopyWithImpl<_TicketPaymentSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketPaymentSummary&&(identical(other.status, status) || other.status == status)&&(identical(other.method, method) || other.method == method)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.installment, installment) || other.installment == installment)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.approvalNo, approvalNo) || other.approvalNo == approvalNo)&&(identical(other.cardMasked, cardMasked) || other.cardMasked == cardMasked)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,status,method,cardCompany,installment,paidAt,approvalNo,cardMasked,approvedAt,amount);

@override
String toString() {
  return 'TicketPaymentSummary(status: $status, method: $method, cardCompany: $cardCompany, installment: $installment, paidAt: $paidAt, approvalNo: $approvalNo, cardMasked: $cardMasked, approvedAt: $approvedAt, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$TicketPaymentSummaryCopyWith<$Res> implements $TicketPaymentSummaryCopyWith<$Res> {
  factory _$TicketPaymentSummaryCopyWith(_TicketPaymentSummary value, $Res Function(_TicketPaymentSummary) _then) = __$TicketPaymentSummaryCopyWithImpl;
@override @useResult
$Res call({
 PaymentStatus status, PaymentMethod method, String cardCompany, int installment, DateTime? paidAt, String approvalNo, String cardMasked, DateTime? approvedAt, int amount
});




}
/// @nodoc
class __$TicketPaymentSummaryCopyWithImpl<$Res>
    implements _$TicketPaymentSummaryCopyWith<$Res> {
  __$TicketPaymentSummaryCopyWithImpl(this._self, this._then);

  final _TicketPaymentSummary _self;
  final $Res Function(_TicketPaymentSummary) _then;

/// Create a copy of TicketPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? method = null,Object? cardCompany = null,Object? installment = null,Object? paidAt = freezed,Object? approvalNo = null,Object? cardMasked = null,Object? approvedAt = freezed,Object? amount = null,}) {
  return _then(_TicketPaymentSummary(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,cardCompany: null == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalNo: null == approvalNo ? _self.approvalNo : approvalNo // ignore: cast_nullable_to_non_nullable
as String,cardMasked: null == cardMasked ? _self.cardMasked : cardMasked // ignore: cast_nullable_to_non_nullable
as String,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TicketRefundSummary {

 String get refundId; RefundStatus get status; int get amount; RefundReason get reason;
/// Create a copy of TicketRefundSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketRefundSummaryCopyWith<TicketRefundSummary> get copyWith => _$TicketRefundSummaryCopyWithImpl<TicketRefundSummary>(this as TicketRefundSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketRefundSummary&&(identical(other.refundId, refundId) || other.refundId == refundId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,refundId,status,amount,reason);

@override
String toString() {
  return 'TicketRefundSummary(refundId: $refundId, status: $status, amount: $amount, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $TicketRefundSummaryCopyWith<$Res>  {
  factory $TicketRefundSummaryCopyWith(TicketRefundSummary value, $Res Function(TicketRefundSummary) _then) = _$TicketRefundSummaryCopyWithImpl;
@useResult
$Res call({
 String refundId, RefundStatus status, int amount, RefundReason reason
});




}
/// @nodoc
class _$TicketRefundSummaryCopyWithImpl<$Res>
    implements $TicketRefundSummaryCopyWith<$Res> {
  _$TicketRefundSummaryCopyWithImpl(this._self, this._then);

  final TicketRefundSummary _self;
  final $Res Function(TicketRefundSummary) _then;

/// Create a copy of TicketRefundSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refundId = null,Object? status = null,Object? amount = null,Object? reason = null,}) {
  return _then(_self.copyWith(
refundId: null == refundId ? _self.refundId : refundId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RefundReason,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketRefundSummary].
extension TicketRefundSummaryPatterns on TicketRefundSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketRefundSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketRefundSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketRefundSummary value)  $default,){
final _that = this;
switch (_that) {
case _TicketRefundSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketRefundSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TicketRefundSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String refundId,  RefundStatus status,  int amount,  RefundReason reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketRefundSummary() when $default != null:
return $default(_that.refundId,_that.status,_that.amount,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String refundId,  RefundStatus status,  int amount,  RefundReason reason)  $default,) {final _that = this;
switch (_that) {
case _TicketRefundSummary():
return $default(_that.refundId,_that.status,_that.amount,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String refundId,  RefundStatus status,  int amount,  RefundReason reason)?  $default,) {final _that = this;
switch (_that) {
case _TicketRefundSummary() when $default != null:
return $default(_that.refundId,_that.status,_that.amount,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _TicketRefundSummary implements TicketRefundSummary {
  const _TicketRefundSummary({this.refundId = '', this.status = RefundStatus.unknown, this.amount = 0, this.reason = RefundReason.unknown});
  

@override@JsonKey() final  String refundId;
@override@JsonKey() final  RefundStatus status;
@override@JsonKey() final  int amount;
@override@JsonKey() final  RefundReason reason;

/// Create a copy of TicketRefundSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketRefundSummaryCopyWith<_TicketRefundSummary> get copyWith => __$TicketRefundSummaryCopyWithImpl<_TicketRefundSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketRefundSummary&&(identical(other.refundId, refundId) || other.refundId == refundId)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,refundId,status,amount,reason);

@override
String toString() {
  return 'TicketRefundSummary(refundId: $refundId, status: $status, amount: $amount, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$TicketRefundSummaryCopyWith<$Res> implements $TicketRefundSummaryCopyWith<$Res> {
  factory _$TicketRefundSummaryCopyWith(_TicketRefundSummary value, $Res Function(_TicketRefundSummary) _then) = __$TicketRefundSummaryCopyWithImpl;
@override @useResult
$Res call({
 String refundId, RefundStatus status, int amount, RefundReason reason
});




}
/// @nodoc
class __$TicketRefundSummaryCopyWithImpl<$Res>
    implements _$TicketRefundSummaryCopyWith<$Res> {
  __$TicketRefundSummaryCopyWithImpl(this._self, this._then);

  final _TicketRefundSummary _self;
  final $Res Function(_TicketRefundSummary) _then;

/// Create a copy of TicketRefundSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refundId = null,Object? status = null,Object? amount = null,Object? reason = null,}) {
  return _then(_TicketRefundSummary(
refundId: null == refundId ? _self.refundId : refundId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RefundReason,
  ));
}


}

/// @nodoc
mixin _$TicketShareSummary {

 String get serial; ShareLinkStatus get status; int get receivedCount; DateTime? get lastReceivedAt;/// 비밀번호를 설정한 시각(웨이팅 티켓만).
 DateTime? get passwordSetAt;
/// Create a copy of TicketShareSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketShareSummaryCopyWith<TicketShareSummary> get copyWith => _$TicketShareSummaryCopyWithImpl<TicketShareSummary>(this as TicketShareSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketShareSummary&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.status, status) || other.status == status)&&(identical(other.receivedCount, receivedCount) || other.receivedCount == receivedCount)&&(identical(other.lastReceivedAt, lastReceivedAt) || other.lastReceivedAt == lastReceivedAt)&&(identical(other.passwordSetAt, passwordSetAt) || other.passwordSetAt == passwordSetAt));
}


@override
int get hashCode => Object.hash(runtimeType,serial,status,receivedCount,lastReceivedAt,passwordSetAt);

@override
String toString() {
  return 'TicketShareSummary(serial: $serial, status: $status, receivedCount: $receivedCount, lastReceivedAt: $lastReceivedAt, passwordSetAt: $passwordSetAt)';
}


}

/// @nodoc
abstract mixin class $TicketShareSummaryCopyWith<$Res>  {
  factory $TicketShareSummaryCopyWith(TicketShareSummary value, $Res Function(TicketShareSummary) _then) = _$TicketShareSummaryCopyWithImpl;
@useResult
$Res call({
 String serial, ShareLinkStatus status, int receivedCount, DateTime? lastReceivedAt, DateTime? passwordSetAt
});




}
/// @nodoc
class _$TicketShareSummaryCopyWithImpl<$Res>
    implements $TicketShareSummaryCopyWith<$Res> {
  _$TicketShareSummaryCopyWithImpl(this._self, this._then);

  final TicketShareSummary _self;
  final $Res Function(TicketShareSummary) _then;

/// Create a copy of TicketShareSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serial = null,Object? status = null,Object? receivedCount = null,Object? lastReceivedAt = freezed,Object? passwordSetAt = freezed,}) {
  return _then(_self.copyWith(
serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShareLinkStatus,receivedCount: null == receivedCount ? _self.receivedCount : receivedCount // ignore: cast_nullable_to_non_nullable
as int,lastReceivedAt: freezed == lastReceivedAt ? _self.lastReceivedAt : lastReceivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordSetAt: freezed == passwordSetAt ? _self.passwordSetAt : passwordSetAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketShareSummary].
extension TicketShareSummaryPatterns on TicketShareSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketShareSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketShareSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketShareSummary value)  $default,){
final _that = this;
switch (_that) {
case _TicketShareSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketShareSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TicketShareSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serial,  ShareLinkStatus status,  int receivedCount,  DateTime? lastReceivedAt,  DateTime? passwordSetAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketShareSummary() when $default != null:
return $default(_that.serial,_that.status,_that.receivedCount,_that.lastReceivedAt,_that.passwordSetAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serial,  ShareLinkStatus status,  int receivedCount,  DateTime? lastReceivedAt,  DateTime? passwordSetAt)  $default,) {final _that = this;
switch (_that) {
case _TicketShareSummary():
return $default(_that.serial,_that.status,_that.receivedCount,_that.lastReceivedAt,_that.passwordSetAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serial,  ShareLinkStatus status,  int receivedCount,  DateTime? lastReceivedAt,  DateTime? passwordSetAt)?  $default,) {final _that = this;
switch (_that) {
case _TicketShareSummary() when $default != null:
return $default(_that.serial,_that.status,_that.receivedCount,_that.lastReceivedAt,_that.passwordSetAt);case _:
  return null;

}
}

}

/// @nodoc


class _TicketShareSummary implements TicketShareSummary {
  const _TicketShareSummary({this.serial = '', this.status = ShareLinkStatus.unknown, this.receivedCount = 0, this.lastReceivedAt, this.passwordSetAt});
  

@override@JsonKey() final  String serial;
@override@JsonKey() final  ShareLinkStatus status;
@override@JsonKey() final  int receivedCount;
@override final  DateTime? lastReceivedAt;
/// 비밀번호를 설정한 시각(웨이팅 티켓만).
@override final  DateTime? passwordSetAt;

/// Create a copy of TicketShareSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketShareSummaryCopyWith<_TicketShareSummary> get copyWith => __$TicketShareSummaryCopyWithImpl<_TicketShareSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketShareSummary&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.status, status) || other.status == status)&&(identical(other.receivedCount, receivedCount) || other.receivedCount == receivedCount)&&(identical(other.lastReceivedAt, lastReceivedAt) || other.lastReceivedAt == lastReceivedAt)&&(identical(other.passwordSetAt, passwordSetAt) || other.passwordSetAt == passwordSetAt));
}


@override
int get hashCode => Object.hash(runtimeType,serial,status,receivedCount,lastReceivedAt,passwordSetAt);

@override
String toString() {
  return 'TicketShareSummary(serial: $serial, status: $status, receivedCount: $receivedCount, lastReceivedAt: $lastReceivedAt, passwordSetAt: $passwordSetAt)';
}


}

/// @nodoc
abstract mixin class _$TicketShareSummaryCopyWith<$Res> implements $TicketShareSummaryCopyWith<$Res> {
  factory _$TicketShareSummaryCopyWith(_TicketShareSummary value, $Res Function(_TicketShareSummary) _then) = __$TicketShareSummaryCopyWithImpl;
@override @useResult
$Res call({
 String serial, ShareLinkStatus status, int receivedCount, DateTime? lastReceivedAt, DateTime? passwordSetAt
});




}
/// @nodoc
class __$TicketShareSummaryCopyWithImpl<$Res>
    implements _$TicketShareSummaryCopyWith<$Res> {
  __$TicketShareSummaryCopyWithImpl(this._self, this._then);

  final _TicketShareSummary _self;
  final $Res Function(_TicketShareSummary) _then;

/// Create a copy of TicketShareSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serial = null,Object? status = null,Object? receivedCount = null,Object? lastReceivedAt = freezed,Object? passwordSetAt = freezed,}) {
  return _then(_TicketShareSummary(
serial: null == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShareLinkStatus,receivedCount: null == receivedCount ? _self.receivedCount : receivedCount // ignore: cast_nullable_to_non_nullable
as int,lastReceivedAt: freezed == lastReceivedAt ? _self.lastReceivedAt : lastReceivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordSetAt: freezed == passwordSetAt ? _self.passwordSetAt : passwordSetAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$PenaltyLine {

 PenaltyKind get kind;/// 0~100 정수(%).
 int get rate;/// 원 단위 정수(내림).
 int get amount;
/// Create a copy of PenaltyLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PenaltyLineCopyWith<PenaltyLine> get copyWith => _$PenaltyLineCopyWithImpl<PenaltyLine>(this as PenaltyLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PenaltyLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,kind,rate,amount);

@override
String toString() {
  return 'PenaltyLine(kind: $kind, rate: $rate, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PenaltyLineCopyWith<$Res>  {
  factory $PenaltyLineCopyWith(PenaltyLine value, $Res Function(PenaltyLine) _then) = _$PenaltyLineCopyWithImpl;
@useResult
$Res call({
 PenaltyKind kind, int rate, int amount
});




}
/// @nodoc
class _$PenaltyLineCopyWithImpl<$Res>
    implements $PenaltyLineCopyWith<$Res> {
  _$PenaltyLineCopyWithImpl(this._self, this._then);

  final PenaltyLine _self;
  final $Res Function(PenaltyLine) _then;

/// Create a copy of PenaltyLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? rate = null,Object? amount = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PenaltyKind,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PenaltyLine].
extension PenaltyLinePatterns on PenaltyLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PenaltyLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PenaltyLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PenaltyLine value)  $default,){
final _that = this;
switch (_that) {
case _PenaltyLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PenaltyLine value)?  $default,){
final _that = this;
switch (_that) {
case _PenaltyLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PenaltyKind kind,  int rate,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PenaltyLine() when $default != null:
return $default(_that.kind,_that.rate,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PenaltyKind kind,  int rate,  int amount)  $default,) {final _that = this;
switch (_that) {
case _PenaltyLine():
return $default(_that.kind,_that.rate,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PenaltyKind kind,  int rate,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _PenaltyLine() when $default != null:
return $default(_that.kind,_that.rate,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _PenaltyLine implements PenaltyLine {
  const _PenaltyLine({this.kind = PenaltyKind.unknown, this.rate = 0, this.amount = 0});
  

@override@JsonKey() final  PenaltyKind kind;
/// 0~100 정수(%).
@override@JsonKey() final  int rate;
/// 원 단위 정수(내림).
@override@JsonKey() final  int amount;

/// Create a copy of PenaltyLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PenaltyLineCopyWith<_PenaltyLine> get copyWith => __$PenaltyLineCopyWithImpl<_PenaltyLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PenaltyLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,kind,rate,amount);

@override
String toString() {
  return 'PenaltyLine(kind: $kind, rate: $rate, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$PenaltyLineCopyWith<$Res> implements $PenaltyLineCopyWith<$Res> {
  factory _$PenaltyLineCopyWith(_PenaltyLine value, $Res Function(_PenaltyLine) _then) = __$PenaltyLineCopyWithImpl;
@override @useResult
$Res call({
 PenaltyKind kind, int rate, int amount
});




}
/// @nodoc
class __$PenaltyLineCopyWithImpl<$Res>
    implements _$PenaltyLineCopyWith<$Res> {
  __$PenaltyLineCopyWithImpl(this._self, this._then);

  final _PenaltyLine _self;
  final $Res Function(_PenaltyLine) _then;

/// Create a copy of PenaltyLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? rate = null,Object? amount = null,}) {
  return _then(_PenaltyLine(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PenaltyKind,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WaitingFee {

/// 1인 입장비.
 int get unit; int get people;/// 서버가 확정한 총액.
 int get total;/// 등록 시점 `ops/settings.version`.
 int get settingsVersion;
/// Create a copy of WaitingFee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaitingFeeCopyWith<WaitingFee> get copyWith => _$WaitingFeeCopyWithImpl<WaitingFee>(this as WaitingFee, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaitingFee&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.people, people) || other.people == people)&&(identical(other.total, total) || other.total == total)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion));
}


@override
int get hashCode => Object.hash(runtimeType,unit,people,total,settingsVersion);

@override
String toString() {
  return 'WaitingFee(unit: $unit, people: $people, total: $total, settingsVersion: $settingsVersion)';
}


}

/// @nodoc
abstract mixin class $WaitingFeeCopyWith<$Res>  {
  factory $WaitingFeeCopyWith(WaitingFee value, $Res Function(WaitingFee) _then) = _$WaitingFeeCopyWithImpl;
@useResult
$Res call({
 int unit, int people, int total, int settingsVersion
});




}
/// @nodoc
class _$WaitingFeeCopyWithImpl<$Res>
    implements $WaitingFeeCopyWith<$Res> {
  _$WaitingFeeCopyWithImpl(this._self, this._then);

  final WaitingFee _self;
  final $Res Function(WaitingFee) _then;

/// Create a copy of WaitingFee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? people = null,Object? total = null,Object? settingsVersion = null,}) {
  return _then(_self.copyWith(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as int,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WaitingFee].
extension WaitingFeePatterns on WaitingFee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaitingFee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaitingFee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaitingFee value)  $default,){
final _that = this;
switch (_that) {
case _WaitingFee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaitingFee value)?  $default,){
final _that = this;
switch (_that) {
case _WaitingFee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int unit,  int people,  int total,  int settingsVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaitingFee() when $default != null:
return $default(_that.unit,_that.people,_that.total,_that.settingsVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int unit,  int people,  int total,  int settingsVersion)  $default,) {final _that = this;
switch (_that) {
case _WaitingFee():
return $default(_that.unit,_that.people,_that.total,_that.settingsVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int unit,  int people,  int total,  int settingsVersion)?  $default,) {final _that = this;
switch (_that) {
case _WaitingFee() when $default != null:
return $default(_that.unit,_that.people,_that.total,_that.settingsVersion);case _:
  return null;

}
}

}

/// @nodoc


class _WaitingFee extends WaitingFee {
  const _WaitingFee({this.unit = 0, this.people = 0, this.total = 0, this.settingsVersion = 0}): super._();
  

/// 1인 입장비.
@override@JsonKey() final  int unit;
@override@JsonKey() final  int people;
/// 서버가 확정한 총액.
@override@JsonKey() final  int total;
/// 등록 시점 `ops/settings.version`.
@override@JsonKey() final  int settingsVersion;

/// Create a copy of WaitingFee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaitingFeeCopyWith<_WaitingFee> get copyWith => __$WaitingFeeCopyWithImpl<_WaitingFee>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaitingFee&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.people, people) || other.people == people)&&(identical(other.total, total) || other.total == total)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion));
}


@override
int get hashCode => Object.hash(runtimeType,unit,people,total,settingsVersion);

@override
String toString() {
  return 'WaitingFee(unit: $unit, people: $people, total: $total, settingsVersion: $settingsVersion)';
}


}

/// @nodoc
abstract mixin class _$WaitingFeeCopyWith<$Res> implements $WaitingFeeCopyWith<$Res> {
  factory _$WaitingFeeCopyWith(_WaitingFee value, $Res Function(_WaitingFee) _then) = __$WaitingFeeCopyWithImpl;
@override @useResult
$Res call({
 int unit, int people, int total, int settingsVersion
});




}
/// @nodoc
class __$WaitingFeeCopyWithImpl<$Res>
    implements _$WaitingFeeCopyWith<$Res> {
  __$WaitingFeeCopyWithImpl(this._self, this._then);

  final _WaitingFee _self;
  final $Res Function(_WaitingFee) _then;

/// Create a copy of WaitingFee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? people = null,Object? total = null,Object? settingsVersion = null,}) {
  return _then(_WaitingFee(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as int,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$EntryRef {

 EntryRefType get type; String get id;/// 티켓 표시 번호(예: 'WT-2607-0005').
 String get code;
/// Create a copy of EntryRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryRefCopyWith<EntryRef> get copyWith => _$EntryRefCopyWithImpl<EntryRef>(this as EntryRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryRef&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,type,id,code);

@override
String toString() {
  return 'EntryRef(type: $type, id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class $EntryRefCopyWith<$Res>  {
  factory $EntryRefCopyWith(EntryRef value, $Res Function(EntryRef) _then) = _$EntryRefCopyWithImpl;
@useResult
$Res call({
 EntryRefType type, String id, String code
});




}
/// @nodoc
class _$EntryRefCopyWithImpl<$Res>
    implements $EntryRefCopyWith<$Res> {
  _$EntryRefCopyWithImpl(this._self, this._then);

  final EntryRef _self;
  final $Res Function(EntryRef) _then;

/// Create a copy of EntryRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? code = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryRefType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EntryRef].
extension EntryRefPatterns on EntryRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntryRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntryRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntryRef value)  $default,){
final _that = this;
switch (_that) {
case _EntryRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntryRef value)?  $default,){
final _that = this;
switch (_that) {
case _EntryRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EntryRefType type,  String id,  String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntryRef() when $default != null:
return $default(_that.type,_that.id,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EntryRefType type,  String id,  String code)  $default,) {final _that = this;
switch (_that) {
case _EntryRef():
return $default(_that.type,_that.id,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EntryRefType type,  String id,  String code)?  $default,) {final _that = this;
switch (_that) {
case _EntryRef() when $default != null:
return $default(_that.type,_that.id,_that.code);case _:
  return null;

}
}

}

/// @nodoc


class _EntryRef implements EntryRef {
  const _EntryRef({this.type = EntryRefType.unknown, this.id = '', this.code = ''});
  

@override@JsonKey() final  EntryRefType type;
@override@JsonKey() final  String id;
/// 티켓 표시 번호(예: 'WT-2607-0005').
@override@JsonKey() final  String code;

/// Create a copy of EntryRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryRefCopyWith<_EntryRef> get copyWith => __$EntryRefCopyWithImpl<_EntryRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntryRef&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,type,id,code);

@override
String toString() {
  return 'EntryRef(type: $type, id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class _$EntryRefCopyWith<$Res> implements $EntryRefCopyWith<$Res> {
  factory _$EntryRefCopyWith(_EntryRef value, $Res Function(_EntryRef) _then) = __$EntryRefCopyWithImpl;
@override @useResult
$Res call({
 EntryRefType type, String id, String code
});




}
/// @nodoc
class __$EntryRefCopyWithImpl<$Res>
    implements _$EntryRefCopyWith<$Res> {
  __$EntryRefCopyWithImpl(this._self, this._then);

  final _EntryRef _self;
  final $Res Function(_EntryRef) _then;

/// Create a copy of EntryRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? code = null,}) {
  return _then(_EntryRef(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EntryRefType,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrderLine {

 String get menuId; String get name; int get qty; int get unitPrice;/// 추가 옵션(예: 레몬 슬라이스 추가 5P · +5,500원).
 List<OrderLineOption> get options;/// 서버가 확정한 줄 합계.
 int get lineTotal;
/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineCopyWith<OrderLine> get copyWith => _$OrderLineCopyWithImpl<OrderLine>(this as OrderLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLine&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.name, name) || other.name == name)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode => Object.hash(runtimeType,menuId,name,qty,unitPrice,const DeepCollectionEquality().hash(options),lineTotal);

@override
String toString() {
  return 'OrderLine(menuId: $menuId, name: $name, qty: $qty, unitPrice: $unitPrice, options: $options, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class $OrderLineCopyWith<$Res>  {
  factory $OrderLineCopyWith(OrderLine value, $Res Function(OrderLine) _then) = _$OrderLineCopyWithImpl;
@useResult
$Res call({
 String menuId, String name, int qty, int unitPrice, List<OrderLineOption> options, int lineTotal
});




}
/// @nodoc
class _$OrderLineCopyWithImpl<$Res>
    implements $OrderLineCopyWith<$Res> {
  _$OrderLineCopyWithImpl(this._self, this._then);

  final OrderLine _self;
  final $Res Function(OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuId = null,Object? name = null,Object? qty = null,Object? unitPrice = null,Object? options = null,Object? lineTotal = null,}) {
  return _then(_self.copyWith(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OrderLineOption>,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLine].
extension OrderLinePatterns on OrderLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLine value)  $default,){
final _that = this;
switch (_that) {
case _OrderLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLine value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String menuId,  String name,  int qty,  int unitPrice,  List<OrderLineOption> options,  int lineTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.menuId,_that.name,_that.qty,_that.unitPrice,_that.options,_that.lineTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String menuId,  String name,  int qty,  int unitPrice,  List<OrderLineOption> options,  int lineTotal)  $default,) {final _that = this;
switch (_that) {
case _OrderLine():
return $default(_that.menuId,_that.name,_that.qty,_that.unitPrice,_that.options,_that.lineTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String menuId,  String name,  int qty,  int unitPrice,  List<OrderLineOption> options,  int lineTotal)?  $default,) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.menuId,_that.name,_that.qty,_that.unitPrice,_that.options,_that.lineTotal);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLine extends OrderLine {
  const _OrderLine({this.menuId = '', this.name = '', this.qty = 0, this.unitPrice = 0, final  List<OrderLineOption> options = const <OrderLineOption>[], this.lineTotal = 0}): _options = options,super._();
  

@override@JsonKey() final  String menuId;
@override@JsonKey() final  String name;
@override@JsonKey() final  int qty;
@override@JsonKey() final  int unitPrice;
/// 추가 옵션(예: 레몬 슬라이스 추가 5P · +5,500원).
 final  List<OrderLineOption> _options;
/// 추가 옵션(예: 레몬 슬라이스 추가 5P · +5,500원).
@override@JsonKey() List<OrderLineOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

/// 서버가 확정한 줄 합계.
@override@JsonKey() final  int lineTotal;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineCopyWith<_OrderLine> get copyWith => __$OrderLineCopyWithImpl<_OrderLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLine&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.name, name) || other.name == name)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode => Object.hash(runtimeType,menuId,name,qty,unitPrice,const DeepCollectionEquality().hash(_options),lineTotal);

@override
String toString() {
  return 'OrderLine(menuId: $menuId, name: $name, qty: $qty, unitPrice: $unitPrice, options: $options, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$OrderLineCopyWith<$Res> implements $OrderLineCopyWith<$Res> {
  factory _$OrderLineCopyWith(_OrderLine value, $Res Function(_OrderLine) _then) = __$OrderLineCopyWithImpl;
@override @useResult
$Res call({
 String menuId, String name, int qty, int unitPrice, List<OrderLineOption> options, int lineTotal
});




}
/// @nodoc
class __$OrderLineCopyWithImpl<$Res>
    implements _$OrderLineCopyWith<$Res> {
  __$OrderLineCopyWithImpl(this._self, this._then);

  final _OrderLine _self;
  final $Res Function(_OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuId = null,Object? name = null,Object? qty = null,Object? unitPrice = null,Object? options = null,Object? lineTotal = null,}) {
  return _then(_OrderLine(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<OrderLineOption>,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderLineOption {

 String get id; String get name; int get price;
/// Create a copy of OrderLineOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineOptionCopyWith<OrderLineOption> get copyWith => _$OrderLineOptionCopyWithImpl<OrderLineOption>(this as OrderLineOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price);

@override
String toString() {
  return 'OrderLineOption(id: $id, name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class $OrderLineOptionCopyWith<$Res>  {
  factory $OrderLineOptionCopyWith(OrderLineOption value, $Res Function(OrderLineOption) _then) = _$OrderLineOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int price
});




}
/// @nodoc
class _$OrderLineOptionCopyWithImpl<$Res>
    implements $OrderLineOptionCopyWith<$Res> {
  _$OrderLineOptionCopyWithImpl(this._self, this._then);

  final OrderLineOption _self;
  final $Res Function(OrderLineOption) _then;

/// Create a copy of OrderLineOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineOption].
extension OrderLineOptionPatterns on OrderLineOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineOption value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineOption value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineOption() when $default != null:
return $default(_that.id,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int price)  $default,) {final _that = this;
switch (_that) {
case _OrderLineOption():
return $default(_that.id,_that.name,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int price)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineOption() when $default != null:
return $default(_that.id,_that.name,_that.price);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineOption implements OrderLineOption {
  const _OrderLineOption({this.id = '', this.name = '', this.price = 0});
  

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  int price;

/// Create a copy of OrderLineOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineOptionCopyWith<_OrderLineOption> get copyWith => __$OrderLineOptionCopyWithImpl<_OrderLineOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price);

@override
String toString() {
  return 'OrderLineOption(id: $id, name: $name, price: $price)';
}


}

/// @nodoc
abstract mixin class _$OrderLineOptionCopyWith<$Res> implements $OrderLineOptionCopyWith<$Res> {
  factory _$OrderLineOptionCopyWith(_OrderLineOption value, $Res Function(_OrderLineOption) _then) = __$OrderLineOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int price
});




}
/// @nodoc
class __$OrderLineOptionCopyWithImpl<$Res>
    implements _$OrderLineOptionCopyWith<$Res> {
  __$OrderLineOptionCopyWithImpl(this._self, this._then);

  final _OrderLineOption _self;
  final $Res Function(_OrderLineOption) _then;

/// Create a copy of OrderLineOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,}) {
  return _then(_OrderLineOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
