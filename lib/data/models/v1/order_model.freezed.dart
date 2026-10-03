// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderModel {

 String get orderId;/// 영업일 내 주문번호 3자리 — '017'.
 String get no; String get clubId; String get clubName; String get uid; String get businessDate;/// 주문 자격이 된 입장 티켓.
 EntryRef get entryRef;/// '테이블-4' · 웨이팅 입장이면 '입장권 WT-…'.
 String get tableLabel;/// 픽업 위치 — '바 카운터'.
 String get pickup; List<OrderLine> get lines;/// 서버가 계산한 총액.
 int get total; String get paymentId; TicketPaymentSummary? get payment; OrderStatus get status;/// 자동 전환으로 making 이 된 주문.
 bool get auto; OrderTimeline get timeline; OrderReject? get reject; DateTime? get cancelledAt; CancelledBy get cancelledBy; TicketRefundSummary? get refund; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.no, no) || other.no == no)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.entryRef, entryRef) || other.entryRef == entryRef)&&(identical(other.tableLabel, tableLabel) || other.tableLabel == tableLabel)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.total, total) || other.total == total)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.status, status) || other.status == status)&&(identical(other.auto, auto) || other.auto == auto)&&(identical(other.timeline, timeline) || other.timeline == timeline)&&(identical(other.reject, reject) || other.reject == reject)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,orderId,no,clubId,clubName,uid,businessDate,entryRef,tableLabel,pickup,const DeepCollectionEquality().hash(lines),total,paymentId,payment,status,auto,timeline,reject,cancelledAt,cancelledBy,refund,createdAt,updatedAt]);

@override
String toString() {
  return 'OrderModel(orderId: $orderId, no: $no, clubId: $clubId, clubName: $clubName, uid: $uid, businessDate: $businessDate, entryRef: $entryRef, tableLabel: $tableLabel, pickup: $pickup, lines: $lines, total: $total, paymentId: $paymentId, payment: $payment, status: $status, auto: $auto, timeline: $timeline, reject: $reject, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, refund: $refund, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 String orderId, String no, String clubId, String clubName, String uid, String businessDate, EntryRef entryRef, String tableLabel, String pickup, List<OrderLine> lines, int total, String paymentId, TicketPaymentSummary? payment, OrderStatus status, bool auto, OrderTimeline timeline, OrderReject? reject, DateTime? cancelledAt, CancelledBy cancelledBy, TicketRefundSummary? refund, DateTime createdAt, DateTime updatedAt
});


$EntryRefCopyWith<$Res> get entryRef;$TicketPaymentSummaryCopyWith<$Res>? get payment;$OrderTimelineCopyWith<$Res> get timeline;$OrderRejectCopyWith<$Res>? get reject;$TicketRefundSummaryCopyWith<$Res>? get refund;

}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? no = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? businessDate = null,Object? entryRef = null,Object? tableLabel = null,Object? pickup = null,Object? lines = null,Object? total = null,Object? paymentId = null,Object? payment = freezed,Object? status = null,Object? auto = null,Object? timeline = null,Object? reject = freezed,Object? cancelledAt = freezed,Object? cancelledBy = null,Object? refund = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,entryRef: null == entryRef ? _self.entryRef : entryRef // ignore: cast_nullable_to_non_nullable
as EntryRef,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as OrderTimeline,reject: freezed == reject ? _self.reject : reject // ignore: cast_nullable_to_non_nullable
as OrderReject?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: null == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as CancelledBy,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get entryRef {
  
  return $EntryRefCopyWith<$Res>(_self.entryRef, (value) {
    return _then(_self.copyWith(entryRef: value));
  });
}/// Create a copy of OrderModel
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
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTimelineCopyWith<$Res> get timeline {
  
  return $OrderTimelineCopyWith<$Res>(_self.timeline, (value) {
    return _then(_self.copyWith(timeline: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderRejectCopyWith<$Res>? get reject {
    if (_self.reject == null) {
    return null;
  }

  return $OrderRejectCopyWith<$Res>(_self.reject!, (value) {
    return _then(_self.copyWith(reject: value));
  });
}/// Create a copy of OrderModel
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


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String no,  String clubId,  String clubName,  String uid,  String businessDate,  EntryRef entryRef,  String tableLabel,  String pickup,  List<OrderLine> lines,  int total,  String paymentId,  TicketPaymentSummary? payment,  OrderStatus status,  bool auto,  OrderTimeline timeline,  OrderReject? reject,  DateTime? cancelledAt,  CancelledBy cancelledBy,  TicketRefundSummary? refund,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.orderId,_that.no,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.entryRef,_that.tableLabel,_that.pickup,_that.lines,_that.total,_that.paymentId,_that.payment,_that.status,_that.auto,_that.timeline,_that.reject,_that.cancelledAt,_that.cancelledBy,_that.refund,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String no,  String clubId,  String clubName,  String uid,  String businessDate,  EntryRef entryRef,  String tableLabel,  String pickup,  List<OrderLine> lines,  int total,  String paymentId,  TicketPaymentSummary? payment,  OrderStatus status,  bool auto,  OrderTimeline timeline,  OrderReject? reject,  DateTime? cancelledAt,  CancelledBy cancelledBy,  TicketRefundSummary? refund,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that.orderId,_that.no,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.entryRef,_that.tableLabel,_that.pickup,_that.lines,_that.total,_that.paymentId,_that.payment,_that.status,_that.auto,_that.timeline,_that.reject,_that.cancelledAt,_that.cancelledBy,_that.refund,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String no,  String clubId,  String clubName,  String uid,  String businessDate,  EntryRef entryRef,  String tableLabel,  String pickup,  List<OrderLine> lines,  int total,  String paymentId,  TicketPaymentSummary? payment,  OrderStatus status,  bool auto,  OrderTimeline timeline,  OrderReject? reject,  DateTime? cancelledAt,  CancelledBy cancelledBy,  TicketRefundSummary? refund,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.orderId,_that.no,_that.clubId,_that.clubName,_that.uid,_that.businessDate,_that.entryRef,_that.tableLabel,_that.pickup,_that.lines,_that.total,_that.paymentId,_that.payment,_that.status,_that.auto,_that.timeline,_that.reject,_that.cancelledAt,_that.cancelledBy,_that.refund,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderModel extends OrderModel {
  const _OrderModel({required this.orderId, required this.no, required this.clubId, this.clubName = '', required this.uid, required this.businessDate, this.entryRef = const EntryRef(), this.tableLabel = '', this.pickup = '', final  List<OrderLine> lines = const <OrderLine>[], this.total = 0, this.paymentId = '', this.payment, this.status = OrderStatus.unknown, this.auto = false, this.timeline = const OrderTimeline(), this.reject, this.cancelledAt, this.cancelledBy = CancelledBy.unknown, this.refund, required this.createdAt, required this.updatedAt}): _lines = lines,super._();
  

@override final  String orderId;
/// 영업일 내 주문번호 3자리 — '017'.
@override final  String no;
@override final  String clubId;
@override@JsonKey() final  String clubName;
@override final  String uid;
@override final  String businessDate;
/// 주문 자격이 된 입장 티켓.
@override@JsonKey() final  EntryRef entryRef;
/// '테이블-4' · 웨이팅 입장이면 '입장권 WT-…'.
@override@JsonKey() final  String tableLabel;
/// 픽업 위치 — '바 카운터'.
@override@JsonKey() final  String pickup;
 final  List<OrderLine> _lines;
@override@JsonKey() List<OrderLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// 서버가 계산한 총액.
@override@JsonKey() final  int total;
@override@JsonKey() final  String paymentId;
@override final  TicketPaymentSummary? payment;
@override@JsonKey() final  OrderStatus status;
/// 자동 전환으로 making 이 된 주문.
@override@JsonKey() final  bool auto;
@override@JsonKey() final  OrderTimeline timeline;
@override final  OrderReject? reject;
@override final  DateTime? cancelledAt;
@override@JsonKey() final  CancelledBy cancelledBy;
@override final  TicketRefundSummary? refund;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.no, no) || other.no == no)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.clubName, clubName) || other.clubName == clubName)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.entryRef, entryRef) || other.entryRef == entryRef)&&(identical(other.tableLabel, tableLabel) || other.tableLabel == tableLabel)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.total, total) || other.total == total)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.status, status) || other.status == status)&&(identical(other.auto, auto) || other.auto == auto)&&(identical(other.timeline, timeline) || other.timeline == timeline)&&(identical(other.reject, reject) || other.reject == reject)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.refund, refund) || other.refund == refund)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,orderId,no,clubId,clubName,uid,businessDate,entryRef,tableLabel,pickup,const DeepCollectionEquality().hash(_lines),total,paymentId,payment,status,auto,timeline,reject,cancelledAt,cancelledBy,refund,createdAt,updatedAt]);

@override
String toString() {
  return 'OrderModel(orderId: $orderId, no: $no, clubId: $clubId, clubName: $clubName, uid: $uid, businessDate: $businessDate, entryRef: $entryRef, tableLabel: $tableLabel, pickup: $pickup, lines: $lines, total: $total, paymentId: $paymentId, payment: $payment, status: $status, auto: $auto, timeline: $timeline, reject: $reject, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, refund: $refund, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String no, String clubId, String clubName, String uid, String businessDate, EntryRef entryRef, String tableLabel, String pickup, List<OrderLine> lines, int total, String paymentId, TicketPaymentSummary? payment, OrderStatus status, bool auto, OrderTimeline timeline, OrderReject? reject, DateTime? cancelledAt, CancelledBy cancelledBy, TicketRefundSummary? refund, DateTime createdAt, DateTime updatedAt
});


@override $EntryRefCopyWith<$Res> get entryRef;@override $TicketPaymentSummaryCopyWith<$Res>? get payment;@override $OrderTimelineCopyWith<$Res> get timeline;@override $OrderRejectCopyWith<$Res>? get reject;@override $TicketRefundSummaryCopyWith<$Res>? get refund;

}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? no = null,Object? clubId = null,Object? clubName = null,Object? uid = null,Object? businessDate = null,Object? entryRef = null,Object? tableLabel = null,Object? pickup = null,Object? lines = null,Object? total = null,Object? paymentId = null,Object? payment = freezed,Object? status = null,Object? auto = null,Object? timeline = null,Object? reject = freezed,Object? cancelledAt = freezed,Object? cancelledBy = null,Object? refund = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_OrderModel(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as String,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,clubName: null == clubName ? _self.clubName : clubName // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,entryRef: null == entryRef ? _self.entryRef : entryRef // ignore: cast_nullable_to_non_nullable
as EntryRef,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as TicketPaymentSummary?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as OrderTimeline,reject: freezed == reject ? _self.reject : reject // ignore: cast_nullable_to_non_nullable
as OrderReject?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: null == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as CancelledBy,refund: freezed == refund ? _self.refund : refund // ignore: cast_nullable_to_non_nullable
as TicketRefundSummary?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntryRefCopyWith<$Res> get entryRef {
  
  return $EntryRefCopyWith<$Res>(_self.entryRef, (value) {
    return _then(_self.copyWith(entryRef: value));
  });
}/// Create a copy of OrderModel
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
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTimelineCopyWith<$Res> get timeline {
  
  return $OrderTimelineCopyWith<$Res>(_self.timeline, (value) {
    return _then(_self.copyWith(timeline: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderRejectCopyWith<$Res>? get reject {
    if (_self.reject == null) {
    return null;
  }

  return $OrderRejectCopyWith<$Res>(_self.reject!, (value) {
    return _then(_self.copyWith(reject: value));
  });
}/// Create a copy of OrderModel
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
mixin _$OrderTimeline {

 DateTime? get paidAt; DateTime? get makingAt; DateTime? get readyAt; DateTime? get doneAt;
/// Create a copy of OrderTimeline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTimelineCopyWith<OrderTimeline> get copyWith => _$OrderTimelineCopyWithImpl<OrderTimeline>(this as OrderTimeline, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTimeline&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.makingAt, makingAt) || other.makingAt == makingAt)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt));
}


@override
int get hashCode => Object.hash(runtimeType,paidAt,makingAt,readyAt,doneAt);

@override
String toString() {
  return 'OrderTimeline(paidAt: $paidAt, makingAt: $makingAt, readyAt: $readyAt, doneAt: $doneAt)';
}


}

/// @nodoc
abstract mixin class $OrderTimelineCopyWith<$Res>  {
  factory $OrderTimelineCopyWith(OrderTimeline value, $Res Function(OrderTimeline) _then) = _$OrderTimelineCopyWithImpl;
@useResult
$Res call({
 DateTime? paidAt, DateTime? makingAt, DateTime? readyAt, DateTime? doneAt
});




}
/// @nodoc
class _$OrderTimelineCopyWithImpl<$Res>
    implements $OrderTimelineCopyWith<$Res> {
  _$OrderTimelineCopyWithImpl(this._self, this._then);

  final OrderTimeline _self;
  final $Res Function(OrderTimeline) _then;

/// Create a copy of OrderTimeline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paidAt = freezed,Object? makingAt = freezed,Object? readyAt = freezed,Object? doneAt = freezed,}) {
  return _then(_self.copyWith(
paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,makingAt: freezed == makingAt ? _self.makingAt : makingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTimeline].
extension OrderTimelinePatterns on OrderTimeline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTimeline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTimeline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTimeline value)  $default,){
final _that = this;
switch (_that) {
case _OrderTimeline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTimeline value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTimeline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? paidAt,  DateTime? makingAt,  DateTime? readyAt,  DateTime? doneAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTimeline() when $default != null:
return $default(_that.paidAt,_that.makingAt,_that.readyAt,_that.doneAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? paidAt,  DateTime? makingAt,  DateTime? readyAt,  DateTime? doneAt)  $default,) {final _that = this;
switch (_that) {
case _OrderTimeline():
return $default(_that.paidAt,_that.makingAt,_that.readyAt,_that.doneAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? paidAt,  DateTime? makingAt,  DateTime? readyAt,  DateTime? doneAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderTimeline() when $default != null:
return $default(_that.paidAt,_that.makingAt,_that.readyAt,_that.doneAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderTimeline implements OrderTimeline {
  const _OrderTimeline({this.paidAt, this.makingAt, this.readyAt, this.doneAt});
  

@override final  DateTime? paidAt;
@override final  DateTime? makingAt;
@override final  DateTime? readyAt;
@override final  DateTime? doneAt;

/// Create a copy of OrderTimeline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTimelineCopyWith<_OrderTimeline> get copyWith => __$OrderTimelineCopyWithImpl<_OrderTimeline>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTimeline&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.makingAt, makingAt) || other.makingAt == makingAt)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.doneAt, doneAt) || other.doneAt == doneAt));
}


@override
int get hashCode => Object.hash(runtimeType,paidAt,makingAt,readyAt,doneAt);

@override
String toString() {
  return 'OrderTimeline(paidAt: $paidAt, makingAt: $makingAt, readyAt: $readyAt, doneAt: $doneAt)';
}


}

/// @nodoc
abstract mixin class _$OrderTimelineCopyWith<$Res> implements $OrderTimelineCopyWith<$Res> {
  factory _$OrderTimelineCopyWith(_OrderTimeline value, $Res Function(_OrderTimeline) _then) = __$OrderTimelineCopyWithImpl;
@override @useResult
$Res call({
 DateTime? paidAt, DateTime? makingAt, DateTime? readyAt, DateTime? doneAt
});




}
/// @nodoc
class __$OrderTimelineCopyWithImpl<$Res>
    implements _$OrderTimelineCopyWith<$Res> {
  __$OrderTimelineCopyWithImpl(this._self, this._then);

  final _OrderTimeline _self;
  final $Res Function(_OrderTimeline) _then;

/// Create a copy of OrderTimeline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paidAt = freezed,Object? makingAt = freezed,Object? readyAt = freezed,Object? doneAt = freezed,}) {
  return _then(_OrderTimeline(
paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,makingAt: freezed == makingAt ? _self.makingAt : makingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doneAt: freezed == doneAt ? _self.doneAt : doneAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$OrderReject {

 DateTime? get at; OrderRejectReason get reason; String get by;/// 거절과 함께 품절 처리했는지.
 bool get markSoldOut;
/// Create a copy of OrderReject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderRejectCopyWith<OrderReject> get copyWith => _$OrderRejectCopyWithImpl<OrderReject>(this as OrderReject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderReject&&(identical(other.at, at) || other.at == at)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.by, by) || other.by == by)&&(identical(other.markSoldOut, markSoldOut) || other.markSoldOut == markSoldOut));
}


@override
int get hashCode => Object.hash(runtimeType,at,reason,by,markSoldOut);

@override
String toString() {
  return 'OrderReject(at: $at, reason: $reason, by: $by, markSoldOut: $markSoldOut)';
}


}

/// @nodoc
abstract mixin class $OrderRejectCopyWith<$Res>  {
  factory $OrderRejectCopyWith(OrderReject value, $Res Function(OrderReject) _then) = _$OrderRejectCopyWithImpl;
@useResult
$Res call({
 DateTime? at, OrderRejectReason reason, String by, bool markSoldOut
});




}
/// @nodoc
class _$OrderRejectCopyWithImpl<$Res>
    implements $OrderRejectCopyWith<$Res> {
  _$OrderRejectCopyWithImpl(this._self, this._then);

  final OrderReject _self;
  final $Res Function(OrderReject) _then;

/// Create a copy of OrderReject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = freezed,Object? reason = null,Object? by = null,Object? markSoldOut = null,}) {
  return _then(_self.copyWith(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as OrderRejectReason,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,markSoldOut: null == markSoldOut ? _self.markSoldOut : markSoldOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderReject].
extension OrderRejectPatterns on OrderReject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderReject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderReject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderReject value)  $default,){
final _that = this;
switch (_that) {
case _OrderReject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderReject value)?  $default,){
final _that = this;
switch (_that) {
case _OrderReject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? at,  OrderRejectReason reason,  String by,  bool markSoldOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderReject() when $default != null:
return $default(_that.at,_that.reason,_that.by,_that.markSoldOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? at,  OrderRejectReason reason,  String by,  bool markSoldOut)  $default,) {final _that = this;
switch (_that) {
case _OrderReject():
return $default(_that.at,_that.reason,_that.by,_that.markSoldOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? at,  OrderRejectReason reason,  String by,  bool markSoldOut)?  $default,) {final _that = this;
switch (_that) {
case _OrderReject() when $default != null:
return $default(_that.at,_that.reason,_that.by,_that.markSoldOut);case _:
  return null;

}
}

}

/// @nodoc


class _OrderReject implements OrderReject {
  const _OrderReject({this.at, this.reason = OrderRejectReason.unknown, this.by = '', this.markSoldOut = false});
  

@override final  DateTime? at;
@override@JsonKey() final  OrderRejectReason reason;
@override@JsonKey() final  String by;
/// 거절과 함께 품절 처리했는지.
@override@JsonKey() final  bool markSoldOut;

/// Create a copy of OrderReject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderRejectCopyWith<_OrderReject> get copyWith => __$OrderRejectCopyWithImpl<_OrderReject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderReject&&(identical(other.at, at) || other.at == at)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.by, by) || other.by == by)&&(identical(other.markSoldOut, markSoldOut) || other.markSoldOut == markSoldOut));
}


@override
int get hashCode => Object.hash(runtimeType,at,reason,by,markSoldOut);

@override
String toString() {
  return 'OrderReject(at: $at, reason: $reason, by: $by, markSoldOut: $markSoldOut)';
}


}

/// @nodoc
abstract mixin class _$OrderRejectCopyWith<$Res> implements $OrderRejectCopyWith<$Res> {
  factory _$OrderRejectCopyWith(_OrderReject value, $Res Function(_OrderReject) _then) = __$OrderRejectCopyWithImpl;
@override @useResult
$Res call({
 DateTime? at, OrderRejectReason reason, String by, bool markSoldOut
});




}
/// @nodoc
class __$OrderRejectCopyWithImpl<$Res>
    implements _$OrderRejectCopyWith<$Res> {
  __$OrderRejectCopyWithImpl(this._self, this._then);

  final _OrderReject _self;
  final $Res Function(_OrderReject) _then;

/// Create a copy of OrderReject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = freezed,Object? reason = null,Object? by = null,Object? markSoldOut = null,}) {
  return _then(_OrderReject(
at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as OrderRejectReason,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,markSoldOut: null == markSoldOut ? _self.markSoldOut : markSoldOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
