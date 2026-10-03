// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_ops_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClubOpsSettings {

/// 1인 입장비(원 · 1,000 단위 · 0 = 없음).
 int get entryFee; int get minPeople;/// ⚠ 앱 스테퍼 상한과 같아야 한다(설계: maxPeople ≤ 8).
 int get maxPeople;/// 팀당 기준 대기시간(분 · 5~60 · 5단위).
 int get perTeamMin;/// 예약 도착 시간 슬롯.
 List<ArrivalSlot> get arrivalSlots;/// 주문 자동 '만드는 중' 전환.
 bool get autoMaking; int get version; DateTime? get updatedAt;
/// Create a copy of ClubOpsSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubOpsSettingsCopyWith<ClubOpsSettings> get copyWith => _$ClubOpsSettingsCopyWithImpl<ClubOpsSettings>(this as ClubOpsSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClubOpsSettings&&(identical(other.entryFee, entryFee) || other.entryFee == entryFee)&&(identical(other.minPeople, minPeople) || other.minPeople == minPeople)&&(identical(other.maxPeople, maxPeople) || other.maxPeople == maxPeople)&&(identical(other.perTeamMin, perTeamMin) || other.perTeamMin == perTeamMin)&&const DeepCollectionEquality().equals(other.arrivalSlots, arrivalSlots)&&(identical(other.autoMaking, autoMaking) || other.autoMaking == autoMaking)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,entryFee,minPeople,maxPeople,perTeamMin,const DeepCollectionEquality().hash(arrivalSlots),autoMaking,version,updatedAt);

@override
String toString() {
  return 'ClubOpsSettings(entryFee: $entryFee, minPeople: $minPeople, maxPeople: $maxPeople, perTeamMin: $perTeamMin, arrivalSlots: $arrivalSlots, autoMaking: $autoMaking, version: $version, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ClubOpsSettingsCopyWith<$Res>  {
  factory $ClubOpsSettingsCopyWith(ClubOpsSettings value, $Res Function(ClubOpsSettings) _then) = _$ClubOpsSettingsCopyWithImpl;
@useResult
$Res call({
 int entryFee, int minPeople, int maxPeople, int perTeamMin, List<ArrivalSlot> arrivalSlots, bool autoMaking, int version, DateTime? updatedAt
});




}
/// @nodoc
class _$ClubOpsSettingsCopyWithImpl<$Res>
    implements $ClubOpsSettingsCopyWith<$Res> {
  _$ClubOpsSettingsCopyWithImpl(this._self, this._then);

  final ClubOpsSettings _self;
  final $Res Function(ClubOpsSettings) _then;

/// Create a copy of ClubOpsSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryFee = null,Object? minPeople = null,Object? maxPeople = null,Object? perTeamMin = null,Object? arrivalSlots = null,Object? autoMaking = null,Object? version = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
entryFee: null == entryFee ? _self.entryFee : entryFee // ignore: cast_nullable_to_non_nullable
as int,minPeople: null == minPeople ? _self.minPeople : minPeople // ignore: cast_nullable_to_non_nullable
as int,maxPeople: null == maxPeople ? _self.maxPeople : maxPeople // ignore: cast_nullable_to_non_nullable
as int,perTeamMin: null == perTeamMin ? _self.perTeamMin : perTeamMin // ignore: cast_nullable_to_non_nullable
as int,arrivalSlots: null == arrivalSlots ? _self.arrivalSlots : arrivalSlots // ignore: cast_nullable_to_non_nullable
as List<ArrivalSlot>,autoMaking: null == autoMaking ? _self.autoMaking : autoMaking // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClubOpsSettings].
extension ClubOpsSettingsPatterns on ClubOpsSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClubOpsSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClubOpsSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClubOpsSettings value)  $default,){
final _that = this;
switch (_that) {
case _ClubOpsSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClubOpsSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ClubOpsSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int entryFee,  int minPeople,  int maxPeople,  int perTeamMin,  List<ArrivalSlot> arrivalSlots,  bool autoMaking,  int version,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClubOpsSettings() when $default != null:
return $default(_that.entryFee,_that.minPeople,_that.maxPeople,_that.perTeamMin,_that.arrivalSlots,_that.autoMaking,_that.version,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int entryFee,  int minPeople,  int maxPeople,  int perTeamMin,  List<ArrivalSlot> arrivalSlots,  bool autoMaking,  int version,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ClubOpsSettings():
return $default(_that.entryFee,_that.minPeople,_that.maxPeople,_that.perTeamMin,_that.arrivalSlots,_that.autoMaking,_that.version,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int entryFee,  int minPeople,  int maxPeople,  int perTeamMin,  List<ArrivalSlot> arrivalSlots,  bool autoMaking,  int version,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ClubOpsSettings() when $default != null:
return $default(_that.entryFee,_that.minPeople,_that.maxPeople,_that.perTeamMin,_that.arrivalSlots,_that.autoMaking,_that.version,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ClubOpsSettings extends ClubOpsSettings {
  const _ClubOpsSettings({this.entryFee = 0, this.minPeople = 1, this.maxPeople = 8, this.perTeamMin = 10, final  List<ArrivalSlot> arrivalSlots = const <ArrivalSlot>[], this.autoMaking = false, this.version = 0, this.updatedAt}): _arrivalSlots = arrivalSlots,super._();
  

/// 1인 입장비(원 · 1,000 단위 · 0 = 없음).
@override@JsonKey() final  int entryFee;
@override@JsonKey() final  int minPeople;
/// ⚠ 앱 스테퍼 상한과 같아야 한다(설계: maxPeople ≤ 8).
@override@JsonKey() final  int maxPeople;
/// 팀당 기준 대기시간(분 · 5~60 · 5단위).
@override@JsonKey() final  int perTeamMin;
/// 예약 도착 시간 슬롯.
 final  List<ArrivalSlot> _arrivalSlots;
/// 예약 도착 시간 슬롯.
@override@JsonKey() List<ArrivalSlot> get arrivalSlots {
  if (_arrivalSlots is EqualUnmodifiableListView) return _arrivalSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arrivalSlots);
}

/// 주문 자동 '만드는 중' 전환.
@override@JsonKey() final  bool autoMaking;
@override@JsonKey() final  int version;
@override final  DateTime? updatedAt;

/// Create a copy of ClubOpsSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubOpsSettingsCopyWith<_ClubOpsSettings> get copyWith => __$ClubOpsSettingsCopyWithImpl<_ClubOpsSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClubOpsSettings&&(identical(other.entryFee, entryFee) || other.entryFee == entryFee)&&(identical(other.minPeople, minPeople) || other.minPeople == minPeople)&&(identical(other.maxPeople, maxPeople) || other.maxPeople == maxPeople)&&(identical(other.perTeamMin, perTeamMin) || other.perTeamMin == perTeamMin)&&const DeepCollectionEquality().equals(other._arrivalSlots, _arrivalSlots)&&(identical(other.autoMaking, autoMaking) || other.autoMaking == autoMaking)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,entryFee,minPeople,maxPeople,perTeamMin,const DeepCollectionEquality().hash(_arrivalSlots),autoMaking,version,updatedAt);

@override
String toString() {
  return 'ClubOpsSettings(entryFee: $entryFee, minPeople: $minPeople, maxPeople: $maxPeople, perTeamMin: $perTeamMin, arrivalSlots: $arrivalSlots, autoMaking: $autoMaking, version: $version, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ClubOpsSettingsCopyWith<$Res> implements $ClubOpsSettingsCopyWith<$Res> {
  factory _$ClubOpsSettingsCopyWith(_ClubOpsSettings value, $Res Function(_ClubOpsSettings) _then) = __$ClubOpsSettingsCopyWithImpl;
@override @useResult
$Res call({
 int entryFee, int minPeople, int maxPeople, int perTeamMin, List<ArrivalSlot> arrivalSlots, bool autoMaking, int version, DateTime? updatedAt
});




}
/// @nodoc
class __$ClubOpsSettingsCopyWithImpl<$Res>
    implements _$ClubOpsSettingsCopyWith<$Res> {
  __$ClubOpsSettingsCopyWithImpl(this._self, this._then);

  final _ClubOpsSettings _self;
  final $Res Function(_ClubOpsSettings) _then;

/// Create a copy of ClubOpsSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryFee = null,Object? minPeople = null,Object? maxPeople = null,Object? perTeamMin = null,Object? arrivalSlots = null,Object? autoMaking = null,Object? version = null,Object? updatedAt = freezed,}) {
  return _then(_ClubOpsSettings(
entryFee: null == entryFee ? _self.entryFee : entryFee // ignore: cast_nullable_to_non_nullable
as int,minPeople: null == minPeople ? _self.minPeople : minPeople // ignore: cast_nullable_to_non_nullable
as int,maxPeople: null == maxPeople ? _self.maxPeople : maxPeople // ignore: cast_nullable_to_non_nullable
as int,perTeamMin: null == perTeamMin ? _self.perTeamMin : perTeamMin // ignore: cast_nullable_to_non_nullable
as int,arrivalSlots: null == arrivalSlots ? _self._arrivalSlots : arrivalSlots // ignore: cast_nullable_to_non_nullable
as List<ArrivalSlot>,autoMaking: null == autoMaking ? _self.autoMaking : autoMaking // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ClubFeatures {

 bool get waiting; bool get reservation; bool get order;
/// Create a copy of ClubFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubFeaturesCopyWith<ClubFeatures> get copyWith => _$ClubFeaturesCopyWithImpl<ClubFeatures>(this as ClubFeatures, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClubFeatures&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.reservation, reservation) || other.reservation == reservation)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,waiting,reservation,order);

@override
String toString() {
  return 'ClubFeatures(waiting: $waiting, reservation: $reservation, order: $order)';
}


}

/// @nodoc
abstract mixin class $ClubFeaturesCopyWith<$Res>  {
  factory $ClubFeaturesCopyWith(ClubFeatures value, $Res Function(ClubFeatures) _then) = _$ClubFeaturesCopyWithImpl;
@useResult
$Res call({
 bool waiting, bool reservation, bool order
});




}
/// @nodoc
class _$ClubFeaturesCopyWithImpl<$Res>
    implements $ClubFeaturesCopyWith<$Res> {
  _$ClubFeaturesCopyWithImpl(this._self, this._then);

  final ClubFeatures _self;
  final $Res Function(ClubFeatures) _then;

/// Create a copy of ClubFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? waiting = null,Object? reservation = null,Object? order = null,}) {
  return _then(_self.copyWith(
waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,reservation: null == reservation ? _self.reservation : reservation // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClubFeatures].
extension ClubFeaturesPatterns on ClubFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClubFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClubFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClubFeatures value)  $default,){
final _that = this;
switch (_that) {
case _ClubFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClubFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _ClubFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool waiting,  bool reservation,  bool order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClubFeatures() when $default != null:
return $default(_that.waiting,_that.reservation,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool waiting,  bool reservation,  bool order)  $default,) {final _that = this;
switch (_that) {
case _ClubFeatures():
return $default(_that.waiting,_that.reservation,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool waiting,  bool reservation,  bool order)?  $default,) {final _that = this;
switch (_that) {
case _ClubFeatures() when $default != null:
return $default(_that.waiting,_that.reservation,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _ClubFeatures extends ClubFeatures {
  const _ClubFeatures({this.waiting = false, this.reservation = false, this.order = false}): super._();
  

@override@JsonKey() final  bool waiting;
@override@JsonKey() final  bool reservation;
@override@JsonKey() final  bool order;

/// Create a copy of ClubFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubFeaturesCopyWith<_ClubFeatures> get copyWith => __$ClubFeaturesCopyWithImpl<_ClubFeatures>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClubFeatures&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.reservation, reservation) || other.reservation == reservation)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,waiting,reservation,order);

@override
String toString() {
  return 'ClubFeatures(waiting: $waiting, reservation: $reservation, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ClubFeaturesCopyWith<$Res> implements $ClubFeaturesCopyWith<$Res> {
  factory _$ClubFeaturesCopyWith(_ClubFeatures value, $Res Function(_ClubFeatures) _then) = __$ClubFeaturesCopyWithImpl;
@override @useResult
$Res call({
 bool waiting, bool reservation, bool order
});




}
/// @nodoc
class __$ClubFeaturesCopyWithImpl<$Res>
    implements _$ClubFeaturesCopyWith<$Res> {
  __$ClubFeaturesCopyWithImpl(this._self, this._then);

  final _ClubFeatures _self;
  final $Res Function(_ClubFeatures) _then;

/// Create a copy of ClubFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? waiting = null,Object? reservation = null,Object? order = null,}) {
  return _then(_ClubFeatures(
waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as bool,reservation: null == reservation ? _self.reservation : reservation // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ArrivalSlot {

/// '20:00'.
 String get label; bool get enabled;
/// Create a copy of ArrivalSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArrivalSlotCopyWith<ArrivalSlot> get copyWith => _$ArrivalSlotCopyWithImpl<ArrivalSlot>(this as ArrivalSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArrivalSlot&&(identical(other.label, label) || other.label == label)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,label,enabled);

@override
String toString() {
  return 'ArrivalSlot(label: $label, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $ArrivalSlotCopyWith<$Res>  {
  factory $ArrivalSlotCopyWith(ArrivalSlot value, $Res Function(ArrivalSlot) _then) = _$ArrivalSlotCopyWithImpl;
@useResult
$Res call({
 String label, bool enabled
});




}
/// @nodoc
class _$ArrivalSlotCopyWithImpl<$Res>
    implements $ArrivalSlotCopyWith<$Res> {
  _$ArrivalSlotCopyWithImpl(this._self, this._then);

  final ArrivalSlot _self;
  final $Res Function(ArrivalSlot) _then;

/// Create a copy of ArrivalSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArrivalSlot].
extension ArrivalSlotPatterns on ArrivalSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArrivalSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArrivalSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArrivalSlot value)  $default,){
final _that = this;
switch (_that) {
case _ArrivalSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArrivalSlot value)?  $default,){
final _that = this;
switch (_that) {
case _ArrivalSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArrivalSlot() when $default != null:
return $default(_that.label,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _ArrivalSlot():
return $default(_that.label,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _ArrivalSlot() when $default != null:
return $default(_that.label,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _ArrivalSlot implements ArrivalSlot {
  const _ArrivalSlot({required this.label, this.enabled = true});
  

/// '20:00'.
@override final  String label;
@override@JsonKey() final  bool enabled;

/// Create a copy of ArrivalSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArrivalSlotCopyWith<_ArrivalSlot> get copyWith => __$ArrivalSlotCopyWithImpl<_ArrivalSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArrivalSlot&&(identical(other.label, label) || other.label == label)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,label,enabled);

@override
String toString() {
  return 'ArrivalSlot(label: $label, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ArrivalSlotCopyWith<$Res> implements $ArrivalSlotCopyWith<$Res> {
  factory _$ArrivalSlotCopyWith(_ArrivalSlot value, $Res Function(_ArrivalSlot) _then) = __$ArrivalSlotCopyWithImpl;
@override @useResult
$Res call({
 String label, bool enabled
});




}
/// @nodoc
class __$ArrivalSlotCopyWithImpl<$Res>
    implements _$ArrivalSlotCopyWith<$Res> {
  __$ArrivalSlotCopyWithImpl(this._self, this._then);

  final _ArrivalSlot _self;
  final $Res Function(_ArrivalSlot) _then;

/// Create a copy of ArrivalSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? enabled = null,}) {
  return _then(_ArrivalSlot(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ClubOpsLive {

 String get businessDate; OpsPhase get phase; DateTime? get openedAt; DateTime? get closedAt; DateTime? get autoOpenAt; DateTime? get autoCloseAt; OpsLiveWaiting get waiting; OpsLiveOrder get order; OpsLiveReservation get reservation; OpsLiveShare get share; DateTime? get updatedAt;
/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubOpsLiveCopyWith<ClubOpsLive> get copyWith => _$ClubOpsLiveCopyWithImpl<ClubOpsLive>(this as ClubOpsLive, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClubOpsLive&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.autoOpenAt, autoOpenAt) || other.autoOpenAt == autoOpenAt)&&(identical(other.autoCloseAt, autoCloseAt) || other.autoCloseAt == autoCloseAt)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.order, order) || other.order == order)&&(identical(other.reservation, reservation) || other.reservation == reservation)&&(identical(other.share, share) || other.share == share)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,businessDate,phase,openedAt,closedAt,autoOpenAt,autoCloseAt,waiting,order,reservation,share,updatedAt);

@override
String toString() {
  return 'ClubOpsLive(businessDate: $businessDate, phase: $phase, openedAt: $openedAt, closedAt: $closedAt, autoOpenAt: $autoOpenAt, autoCloseAt: $autoCloseAt, waiting: $waiting, order: $order, reservation: $reservation, share: $share, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ClubOpsLiveCopyWith<$Res>  {
  factory $ClubOpsLiveCopyWith(ClubOpsLive value, $Res Function(ClubOpsLive) _then) = _$ClubOpsLiveCopyWithImpl;
@useResult
$Res call({
 String businessDate, OpsPhase phase, DateTime? openedAt, DateTime? closedAt, DateTime? autoOpenAt, DateTime? autoCloseAt, OpsLiveWaiting waiting, OpsLiveOrder order, OpsLiveReservation reservation, OpsLiveShare share, DateTime? updatedAt
});


$OpsLiveWaitingCopyWith<$Res> get waiting;$OpsLiveOrderCopyWith<$Res> get order;$OpsLiveReservationCopyWith<$Res> get reservation;$OpsLiveShareCopyWith<$Res> get share;

}
/// @nodoc
class _$ClubOpsLiveCopyWithImpl<$Res>
    implements $ClubOpsLiveCopyWith<$Res> {
  _$ClubOpsLiveCopyWithImpl(this._self, this._then);

  final ClubOpsLive _self;
  final $Res Function(ClubOpsLive) _then;

/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? businessDate = null,Object? phase = null,Object? openedAt = freezed,Object? closedAt = freezed,Object? autoOpenAt = freezed,Object? autoCloseAt = freezed,Object? waiting = null,Object? order = null,Object? reservation = null,Object? share = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as OpsPhase,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoOpenAt: freezed == autoOpenAt ? _self.autoOpenAt : autoOpenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoCloseAt: freezed == autoCloseAt ? _self.autoCloseAt : autoCloseAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as OpsLiveWaiting,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OpsLiveOrder,reservation: null == reservation ? _self.reservation : reservation // ignore: cast_nullable_to_non_nullable
as OpsLiveReservation,share: null == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as OpsLiveShare,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveWaitingCopyWith<$Res> get waiting {
  
  return $OpsLiveWaitingCopyWith<$Res>(_self.waiting, (value) {
    return _then(_self.copyWith(waiting: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveOrderCopyWith<$Res> get order {
  
  return $OpsLiveOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveReservationCopyWith<$Res> get reservation {
  
  return $OpsLiveReservationCopyWith<$Res>(_self.reservation, (value) {
    return _then(_self.copyWith(reservation: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveShareCopyWith<$Res> get share {
  
  return $OpsLiveShareCopyWith<$Res>(_self.share, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClubOpsLive].
extension ClubOpsLivePatterns on ClubOpsLive {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClubOpsLive value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClubOpsLive() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClubOpsLive value)  $default,){
final _that = this;
switch (_that) {
case _ClubOpsLive():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClubOpsLive value)?  $default,){
final _that = this;
switch (_that) {
case _ClubOpsLive() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String businessDate,  OpsPhase phase,  DateTime? openedAt,  DateTime? closedAt,  DateTime? autoOpenAt,  DateTime? autoCloseAt,  OpsLiveWaiting waiting,  OpsLiveOrder order,  OpsLiveReservation reservation,  OpsLiveShare share,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClubOpsLive() when $default != null:
return $default(_that.businessDate,_that.phase,_that.openedAt,_that.closedAt,_that.autoOpenAt,_that.autoCloseAt,_that.waiting,_that.order,_that.reservation,_that.share,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String businessDate,  OpsPhase phase,  DateTime? openedAt,  DateTime? closedAt,  DateTime? autoOpenAt,  DateTime? autoCloseAt,  OpsLiveWaiting waiting,  OpsLiveOrder order,  OpsLiveReservation reservation,  OpsLiveShare share,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ClubOpsLive():
return $default(_that.businessDate,_that.phase,_that.openedAt,_that.closedAt,_that.autoOpenAt,_that.autoCloseAt,_that.waiting,_that.order,_that.reservation,_that.share,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String businessDate,  OpsPhase phase,  DateTime? openedAt,  DateTime? closedAt,  DateTime? autoOpenAt,  DateTime? autoCloseAt,  OpsLiveWaiting waiting,  OpsLiveOrder order,  OpsLiveReservation reservation,  OpsLiveShare share,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ClubOpsLive() when $default != null:
return $default(_that.businessDate,_that.phase,_that.openedAt,_that.closedAt,_that.autoOpenAt,_that.autoCloseAt,_that.waiting,_that.order,_that.reservation,_that.share,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ClubOpsLive extends ClubOpsLive {
  const _ClubOpsLive({required this.businessDate, this.phase = OpsPhase.unknown, this.openedAt, this.closedAt, this.autoOpenAt, this.autoCloseAt, this.waiting = const OpsLiveWaiting(), this.order = const OpsLiveOrder(), this.reservation = const OpsLiveReservation(), this.share = const OpsLiveShare(), this.updatedAt}): super._();
  

@override final  String businessDate;
@override@JsonKey() final  OpsPhase phase;
@override final  DateTime? openedAt;
@override final  DateTime? closedAt;
@override final  DateTime? autoOpenAt;
@override final  DateTime? autoCloseAt;
@override@JsonKey() final  OpsLiveWaiting waiting;
@override@JsonKey() final  OpsLiveOrder order;
@override@JsonKey() final  OpsLiveReservation reservation;
@override@JsonKey() final  OpsLiveShare share;
@override final  DateTime? updatedAt;

/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubOpsLiveCopyWith<_ClubOpsLive> get copyWith => __$ClubOpsLiveCopyWithImpl<_ClubOpsLive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClubOpsLive&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.autoOpenAt, autoOpenAt) || other.autoOpenAt == autoOpenAt)&&(identical(other.autoCloseAt, autoCloseAt) || other.autoCloseAt == autoCloseAt)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.order, order) || other.order == order)&&(identical(other.reservation, reservation) || other.reservation == reservation)&&(identical(other.share, share) || other.share == share)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,businessDate,phase,openedAt,closedAt,autoOpenAt,autoCloseAt,waiting,order,reservation,share,updatedAt);

@override
String toString() {
  return 'ClubOpsLive(businessDate: $businessDate, phase: $phase, openedAt: $openedAt, closedAt: $closedAt, autoOpenAt: $autoOpenAt, autoCloseAt: $autoCloseAt, waiting: $waiting, order: $order, reservation: $reservation, share: $share, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ClubOpsLiveCopyWith<$Res> implements $ClubOpsLiveCopyWith<$Res> {
  factory _$ClubOpsLiveCopyWith(_ClubOpsLive value, $Res Function(_ClubOpsLive) _then) = __$ClubOpsLiveCopyWithImpl;
@override @useResult
$Res call({
 String businessDate, OpsPhase phase, DateTime? openedAt, DateTime? closedAt, DateTime? autoOpenAt, DateTime? autoCloseAt, OpsLiveWaiting waiting, OpsLiveOrder order, OpsLiveReservation reservation, OpsLiveShare share, DateTime? updatedAt
});


@override $OpsLiveWaitingCopyWith<$Res> get waiting;@override $OpsLiveOrderCopyWith<$Res> get order;@override $OpsLiveReservationCopyWith<$Res> get reservation;@override $OpsLiveShareCopyWith<$Res> get share;

}
/// @nodoc
class __$ClubOpsLiveCopyWithImpl<$Res>
    implements _$ClubOpsLiveCopyWith<$Res> {
  __$ClubOpsLiveCopyWithImpl(this._self, this._then);

  final _ClubOpsLive _self;
  final $Res Function(_ClubOpsLive) _then;

/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? businessDate = null,Object? phase = null,Object? openedAt = freezed,Object? closedAt = freezed,Object? autoOpenAt = freezed,Object? autoCloseAt = freezed,Object? waiting = null,Object? order = null,Object? reservation = null,Object? share = null,Object? updatedAt = freezed,}) {
  return _then(_ClubOpsLive(
businessDate: null == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as OpsPhase,openedAt: freezed == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoOpenAt: freezed == autoOpenAt ? _self.autoOpenAt : autoOpenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoCloseAt: freezed == autoCloseAt ? _self.autoCloseAt : autoCloseAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as OpsLiveWaiting,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as OpsLiveOrder,reservation: null == reservation ? _self.reservation : reservation // ignore: cast_nullable_to_non_nullable
as OpsLiveReservation,share: null == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as OpsLiveShare,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveWaitingCopyWith<$Res> get waiting {
  
  return $OpsLiveWaitingCopyWith<$Res>(_self.waiting, (value) {
    return _then(_self.copyWith(waiting: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveOrderCopyWith<$Res> get order {
  
  return $OpsLiveOrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveReservationCopyWith<$Res> get reservation {
  
  return $OpsLiveReservationCopyWith<$Res>(_self.reservation, (value) {
    return _then(_self.copyWith(reservation: value));
  });
}/// Create a copy of ClubOpsLive
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsLiveShareCopyWith<$Res> get share {
  
  return $OpsLiveShareCopyWith<$Res>(_self.share, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}

/// @nodoc
mixin _$OpsLiveWaiting {

/// 지금 웨이팅을 받는지.
 bool get accept;/// 오늘 웨이팅 마감.
 bool get closed; int get nextSeq;/// 대기 중인 순번들.
 List<int> get queue;/// 호출된 순번들.
 List<int> get calledSeqs; int get waitingCount; int get calledCount; int get enteredCount; int get noShowCount; int get cancelledCount;/// 오늘 실측 팀당 평균(분).
 int get perTeamMinToday;
/// Create a copy of OpsLiveWaiting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsLiveWaitingCopyWith<OpsLiveWaiting> get copyWith => _$OpsLiveWaitingCopyWithImpl<OpsLiveWaiting>(this as OpsLiveWaiting, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsLiveWaiting&&(identical(other.accept, accept) || other.accept == accept)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.nextSeq, nextSeq) || other.nextSeq == nextSeq)&&const DeepCollectionEquality().equals(other.queue, queue)&&const DeepCollectionEquality().equals(other.calledSeqs, calledSeqs)&&(identical(other.waitingCount, waitingCount) || other.waitingCount == waitingCount)&&(identical(other.calledCount, calledCount) || other.calledCount == calledCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount)&&(identical(other.noShowCount, noShowCount) || other.noShowCount == noShowCount)&&(identical(other.cancelledCount, cancelledCount) || other.cancelledCount == cancelledCount)&&(identical(other.perTeamMinToday, perTeamMinToday) || other.perTeamMinToday == perTeamMinToday));
}


@override
int get hashCode => Object.hash(runtimeType,accept,closed,nextSeq,const DeepCollectionEquality().hash(queue),const DeepCollectionEquality().hash(calledSeqs),waitingCount,calledCount,enteredCount,noShowCount,cancelledCount,perTeamMinToday);

@override
String toString() {
  return 'OpsLiveWaiting(accept: $accept, closed: $closed, nextSeq: $nextSeq, queue: $queue, calledSeqs: $calledSeqs, waitingCount: $waitingCount, calledCount: $calledCount, enteredCount: $enteredCount, noShowCount: $noShowCount, cancelledCount: $cancelledCount, perTeamMinToday: $perTeamMinToday)';
}


}

/// @nodoc
abstract mixin class $OpsLiveWaitingCopyWith<$Res>  {
  factory $OpsLiveWaitingCopyWith(OpsLiveWaiting value, $Res Function(OpsLiveWaiting) _then) = _$OpsLiveWaitingCopyWithImpl;
@useResult
$Res call({
 bool accept, bool closed, int nextSeq, List<int> queue, List<int> calledSeqs, int waitingCount, int calledCount, int enteredCount, int noShowCount, int cancelledCount, int perTeamMinToday
});




}
/// @nodoc
class _$OpsLiveWaitingCopyWithImpl<$Res>
    implements $OpsLiveWaitingCopyWith<$Res> {
  _$OpsLiveWaitingCopyWithImpl(this._self, this._then);

  final OpsLiveWaiting _self;
  final $Res Function(OpsLiveWaiting) _then;

/// Create a copy of OpsLiveWaiting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accept = null,Object? closed = null,Object? nextSeq = null,Object? queue = null,Object? calledSeqs = null,Object? waitingCount = null,Object? calledCount = null,Object? enteredCount = null,Object? noShowCount = null,Object? cancelledCount = null,Object? perTeamMinToday = null,}) {
  return _then(_self.copyWith(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,nextSeq: null == nextSeq ? _self.nextSeq : nextSeq // ignore: cast_nullable_to_non_nullable
as int,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<int>,calledSeqs: null == calledSeqs ? _self.calledSeqs : calledSeqs // ignore: cast_nullable_to_non_nullable
as List<int>,waitingCount: null == waitingCount ? _self.waitingCount : waitingCount // ignore: cast_nullable_to_non_nullable
as int,calledCount: null == calledCount ? _self.calledCount : calledCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,noShowCount: null == noShowCount ? _self.noShowCount : noShowCount // ignore: cast_nullable_to_non_nullable
as int,cancelledCount: null == cancelledCount ? _self.cancelledCount : cancelledCount // ignore: cast_nullable_to_non_nullable
as int,perTeamMinToday: null == perTeamMinToday ? _self.perTeamMinToday : perTeamMinToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsLiveWaiting].
extension OpsLiveWaitingPatterns on OpsLiveWaiting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsLiveWaiting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsLiveWaiting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsLiveWaiting value)  $default,){
final _that = this;
switch (_that) {
case _OpsLiveWaiting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsLiveWaiting value)?  $default,){
final _that = this;
switch (_that) {
case _OpsLiveWaiting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accept,  bool closed,  int nextSeq,  List<int> queue,  List<int> calledSeqs,  int waitingCount,  int calledCount,  int enteredCount,  int noShowCount,  int cancelledCount,  int perTeamMinToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsLiveWaiting() when $default != null:
return $default(_that.accept,_that.closed,_that.nextSeq,_that.queue,_that.calledSeqs,_that.waitingCount,_that.calledCount,_that.enteredCount,_that.noShowCount,_that.cancelledCount,_that.perTeamMinToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accept,  bool closed,  int nextSeq,  List<int> queue,  List<int> calledSeqs,  int waitingCount,  int calledCount,  int enteredCount,  int noShowCount,  int cancelledCount,  int perTeamMinToday)  $default,) {final _that = this;
switch (_that) {
case _OpsLiveWaiting():
return $default(_that.accept,_that.closed,_that.nextSeq,_that.queue,_that.calledSeqs,_that.waitingCount,_that.calledCount,_that.enteredCount,_that.noShowCount,_that.cancelledCount,_that.perTeamMinToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accept,  bool closed,  int nextSeq,  List<int> queue,  List<int> calledSeqs,  int waitingCount,  int calledCount,  int enteredCount,  int noShowCount,  int cancelledCount,  int perTeamMinToday)?  $default,) {final _that = this;
switch (_that) {
case _OpsLiveWaiting() when $default != null:
return $default(_that.accept,_that.closed,_that.nextSeq,_that.queue,_that.calledSeqs,_that.waitingCount,_that.calledCount,_that.enteredCount,_that.noShowCount,_that.cancelledCount,_that.perTeamMinToday);case _:
  return null;

}
}

}

/// @nodoc


class _OpsLiveWaiting extends OpsLiveWaiting {
  const _OpsLiveWaiting({this.accept = false, this.closed = false, this.nextSeq = 1, final  List<int> queue = const <int>[], final  List<int> calledSeqs = const <int>[], this.waitingCount = 0, this.calledCount = 0, this.enteredCount = 0, this.noShowCount = 0, this.cancelledCount = 0, this.perTeamMinToday = 0}): _queue = queue,_calledSeqs = calledSeqs,super._();
  

/// 지금 웨이팅을 받는지.
@override@JsonKey() final  bool accept;
/// 오늘 웨이팅 마감.
@override@JsonKey() final  bool closed;
@override@JsonKey() final  int nextSeq;
/// 대기 중인 순번들.
 final  List<int> _queue;
/// 대기 중인 순번들.
@override@JsonKey() List<int> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

/// 호출된 순번들.
 final  List<int> _calledSeqs;
/// 호출된 순번들.
@override@JsonKey() List<int> get calledSeqs {
  if (_calledSeqs is EqualUnmodifiableListView) return _calledSeqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calledSeqs);
}

@override@JsonKey() final  int waitingCount;
@override@JsonKey() final  int calledCount;
@override@JsonKey() final  int enteredCount;
@override@JsonKey() final  int noShowCount;
@override@JsonKey() final  int cancelledCount;
/// 오늘 실측 팀당 평균(분).
@override@JsonKey() final  int perTeamMinToday;

/// Create a copy of OpsLiveWaiting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsLiveWaitingCopyWith<_OpsLiveWaiting> get copyWith => __$OpsLiveWaitingCopyWithImpl<_OpsLiveWaiting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsLiveWaiting&&(identical(other.accept, accept) || other.accept == accept)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.nextSeq, nextSeq) || other.nextSeq == nextSeq)&&const DeepCollectionEquality().equals(other._queue, _queue)&&const DeepCollectionEquality().equals(other._calledSeqs, _calledSeqs)&&(identical(other.waitingCount, waitingCount) || other.waitingCount == waitingCount)&&(identical(other.calledCount, calledCount) || other.calledCount == calledCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount)&&(identical(other.noShowCount, noShowCount) || other.noShowCount == noShowCount)&&(identical(other.cancelledCount, cancelledCount) || other.cancelledCount == cancelledCount)&&(identical(other.perTeamMinToday, perTeamMinToday) || other.perTeamMinToday == perTeamMinToday));
}


@override
int get hashCode => Object.hash(runtimeType,accept,closed,nextSeq,const DeepCollectionEquality().hash(_queue),const DeepCollectionEquality().hash(_calledSeqs),waitingCount,calledCount,enteredCount,noShowCount,cancelledCount,perTeamMinToday);

@override
String toString() {
  return 'OpsLiveWaiting(accept: $accept, closed: $closed, nextSeq: $nextSeq, queue: $queue, calledSeqs: $calledSeqs, waitingCount: $waitingCount, calledCount: $calledCount, enteredCount: $enteredCount, noShowCount: $noShowCount, cancelledCount: $cancelledCount, perTeamMinToday: $perTeamMinToday)';
}


}

/// @nodoc
abstract mixin class _$OpsLiveWaitingCopyWith<$Res> implements $OpsLiveWaitingCopyWith<$Res> {
  factory _$OpsLiveWaitingCopyWith(_OpsLiveWaiting value, $Res Function(_OpsLiveWaiting) _then) = __$OpsLiveWaitingCopyWithImpl;
@override @useResult
$Res call({
 bool accept, bool closed, int nextSeq, List<int> queue, List<int> calledSeqs, int waitingCount, int calledCount, int enteredCount, int noShowCount, int cancelledCount, int perTeamMinToday
});




}
/// @nodoc
class __$OpsLiveWaitingCopyWithImpl<$Res>
    implements _$OpsLiveWaitingCopyWith<$Res> {
  __$OpsLiveWaitingCopyWithImpl(this._self, this._then);

  final _OpsLiveWaiting _self;
  final $Res Function(_OpsLiveWaiting) _then;

/// Create a copy of OpsLiveWaiting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accept = null,Object? closed = null,Object? nextSeq = null,Object? queue = null,Object? calledSeqs = null,Object? waitingCount = null,Object? calledCount = null,Object? enteredCount = null,Object? noShowCount = null,Object? cancelledCount = null,Object? perTeamMinToday = null,}) {
  return _then(_OpsLiveWaiting(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,nextSeq: null == nextSeq ? _self.nextSeq : nextSeq // ignore: cast_nullable_to_non_nullable
as int,queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<int>,calledSeqs: null == calledSeqs ? _self._calledSeqs : calledSeqs // ignore: cast_nullable_to_non_nullable
as List<int>,waitingCount: null == waitingCount ? _self.waitingCount : waitingCount // ignore: cast_nullable_to_non_nullable
as int,calledCount: null == calledCount ? _self.calledCount : calledCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,noShowCount: null == noShowCount ? _self.noShowCount : noShowCount // ignore: cast_nullable_to_non_nullable
as int,cancelledCount: null == cancelledCount ? _self.cancelledCount : cancelledCount // ignore: cast_nullable_to_non_nullable
as int,perTeamMinToday: null == perTeamMinToday ? _self.perTeamMinToday : perTeamMinToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OpsLiveOrder {

 bool get accept; int get nextNo; int get paidCount; int get makingCount; int get readyCount; int get doneCount;
/// Create a copy of OpsLiveOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsLiveOrderCopyWith<OpsLiveOrder> get copyWith => _$OpsLiveOrderCopyWithImpl<OpsLiveOrder>(this as OpsLiveOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsLiveOrder&&(identical(other.accept, accept) || other.accept == accept)&&(identical(other.nextNo, nextNo) || other.nextNo == nextNo)&&(identical(other.paidCount, paidCount) || other.paidCount == paidCount)&&(identical(other.makingCount, makingCount) || other.makingCount == makingCount)&&(identical(other.readyCount, readyCount) || other.readyCount == readyCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount));
}


@override
int get hashCode => Object.hash(runtimeType,accept,nextNo,paidCount,makingCount,readyCount,doneCount);

@override
String toString() {
  return 'OpsLiveOrder(accept: $accept, nextNo: $nextNo, paidCount: $paidCount, makingCount: $makingCount, readyCount: $readyCount, doneCount: $doneCount)';
}


}

/// @nodoc
abstract mixin class $OpsLiveOrderCopyWith<$Res>  {
  factory $OpsLiveOrderCopyWith(OpsLiveOrder value, $Res Function(OpsLiveOrder) _then) = _$OpsLiveOrderCopyWithImpl;
@useResult
$Res call({
 bool accept, int nextNo, int paidCount, int makingCount, int readyCount, int doneCount
});




}
/// @nodoc
class _$OpsLiveOrderCopyWithImpl<$Res>
    implements $OpsLiveOrderCopyWith<$Res> {
  _$OpsLiveOrderCopyWithImpl(this._self, this._then);

  final OpsLiveOrder _self;
  final $Res Function(OpsLiveOrder) _then;

/// Create a copy of OpsLiveOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accept = null,Object? nextNo = null,Object? paidCount = null,Object? makingCount = null,Object? readyCount = null,Object? doneCount = null,}) {
  return _then(_self.copyWith(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,nextNo: null == nextNo ? _self.nextNo : nextNo // ignore: cast_nullable_to_non_nullable
as int,paidCount: null == paidCount ? _self.paidCount : paidCount // ignore: cast_nullable_to_non_nullable
as int,makingCount: null == makingCount ? _self.makingCount : makingCount // ignore: cast_nullable_to_non_nullable
as int,readyCount: null == readyCount ? _self.readyCount : readyCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsLiveOrder].
extension OpsLiveOrderPatterns on OpsLiveOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsLiveOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsLiveOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsLiveOrder value)  $default,){
final _that = this;
switch (_that) {
case _OpsLiveOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsLiveOrder value)?  $default,){
final _that = this;
switch (_that) {
case _OpsLiveOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accept,  int nextNo,  int paidCount,  int makingCount,  int readyCount,  int doneCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsLiveOrder() when $default != null:
return $default(_that.accept,_that.nextNo,_that.paidCount,_that.makingCount,_that.readyCount,_that.doneCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accept,  int nextNo,  int paidCount,  int makingCount,  int readyCount,  int doneCount)  $default,) {final _that = this;
switch (_that) {
case _OpsLiveOrder():
return $default(_that.accept,_that.nextNo,_that.paidCount,_that.makingCount,_that.readyCount,_that.doneCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accept,  int nextNo,  int paidCount,  int makingCount,  int readyCount,  int doneCount)?  $default,) {final _that = this;
switch (_that) {
case _OpsLiveOrder() when $default != null:
return $default(_that.accept,_that.nextNo,_that.paidCount,_that.makingCount,_that.readyCount,_that.doneCount);case _:
  return null;

}
}

}

/// @nodoc


class _OpsLiveOrder implements OpsLiveOrder {
  const _OpsLiveOrder({this.accept = false, this.nextNo = 1, this.paidCount = 0, this.makingCount = 0, this.readyCount = 0, this.doneCount = 0});
  

@override@JsonKey() final  bool accept;
@override@JsonKey() final  int nextNo;
@override@JsonKey() final  int paidCount;
@override@JsonKey() final  int makingCount;
@override@JsonKey() final  int readyCount;
@override@JsonKey() final  int doneCount;

/// Create a copy of OpsLiveOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsLiveOrderCopyWith<_OpsLiveOrder> get copyWith => __$OpsLiveOrderCopyWithImpl<_OpsLiveOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsLiveOrder&&(identical(other.accept, accept) || other.accept == accept)&&(identical(other.nextNo, nextNo) || other.nextNo == nextNo)&&(identical(other.paidCount, paidCount) || other.paidCount == paidCount)&&(identical(other.makingCount, makingCount) || other.makingCount == makingCount)&&(identical(other.readyCount, readyCount) || other.readyCount == readyCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount));
}


@override
int get hashCode => Object.hash(runtimeType,accept,nextNo,paidCount,makingCount,readyCount,doneCount);

@override
String toString() {
  return 'OpsLiveOrder(accept: $accept, nextNo: $nextNo, paidCount: $paidCount, makingCount: $makingCount, readyCount: $readyCount, doneCount: $doneCount)';
}


}

/// @nodoc
abstract mixin class _$OpsLiveOrderCopyWith<$Res> implements $OpsLiveOrderCopyWith<$Res> {
  factory _$OpsLiveOrderCopyWith(_OpsLiveOrder value, $Res Function(_OpsLiveOrder) _then) = __$OpsLiveOrderCopyWithImpl;
@override @useResult
$Res call({
 bool accept, int nextNo, int paidCount, int makingCount, int readyCount, int doneCount
});




}
/// @nodoc
class __$OpsLiveOrderCopyWithImpl<$Res>
    implements _$OpsLiveOrderCopyWith<$Res> {
  __$OpsLiveOrderCopyWithImpl(this._self, this._then);

  final _OpsLiveOrder _self;
  final $Res Function(_OpsLiveOrder) _then;

/// Create a copy of OpsLiveOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accept = null,Object? nextNo = null,Object? paidCount = null,Object? makingCount = null,Object? readyCount = null,Object? doneCount = null,}) {
  return _then(_OpsLiveOrder(
accept: null == accept ? _self.accept : accept // ignore: cast_nullable_to_non_nullable
as bool,nextNo: null == nextNo ? _self.nextNo : nextNo // ignore: cast_nullable_to_non_nullable
as int,paidCount: null == paidCount ? _self.paidCount : paidCount // ignore: cast_nullable_to_non_nullable
as int,makingCount: null == makingCount ? _self.makingCount : makingCount // ignore: cast_nullable_to_non_nullable
as int,readyCount: null == readyCount ? _self.readyCount : readyCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OpsLiveReservation {

 int get todayCount; int get convertedCount; int get enteredCount; int get pendingCount;
/// Create a copy of OpsLiveReservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsLiveReservationCopyWith<OpsLiveReservation> get copyWith => _$OpsLiveReservationCopyWithImpl<OpsLiveReservation>(this as OpsLiveReservation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsLiveReservation&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount)&&(identical(other.convertedCount, convertedCount) || other.convertedCount == convertedCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}


@override
int get hashCode => Object.hash(runtimeType,todayCount,convertedCount,enteredCount,pendingCount);

@override
String toString() {
  return 'OpsLiveReservation(todayCount: $todayCount, convertedCount: $convertedCount, enteredCount: $enteredCount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class $OpsLiveReservationCopyWith<$Res>  {
  factory $OpsLiveReservationCopyWith(OpsLiveReservation value, $Res Function(OpsLiveReservation) _then) = _$OpsLiveReservationCopyWithImpl;
@useResult
$Res call({
 int todayCount, int convertedCount, int enteredCount, int pendingCount
});




}
/// @nodoc
class _$OpsLiveReservationCopyWithImpl<$Res>
    implements $OpsLiveReservationCopyWith<$Res> {
  _$OpsLiveReservationCopyWithImpl(this._self, this._then);

  final OpsLiveReservation _self;
  final $Res Function(OpsLiveReservation) _then;

/// Create a copy of OpsLiveReservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayCount = null,Object? convertedCount = null,Object? enteredCount = null,Object? pendingCount = null,}) {
  return _then(_self.copyWith(
todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,convertedCount: null == convertedCount ? _self.convertedCount : convertedCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsLiveReservation].
extension OpsLiveReservationPatterns on OpsLiveReservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsLiveReservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsLiveReservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsLiveReservation value)  $default,){
final _that = this;
switch (_that) {
case _OpsLiveReservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsLiveReservation value)?  $default,){
final _that = this;
switch (_that) {
case _OpsLiveReservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todayCount,  int convertedCount,  int enteredCount,  int pendingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsLiveReservation() when $default != null:
return $default(_that.todayCount,_that.convertedCount,_that.enteredCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todayCount,  int convertedCount,  int enteredCount,  int pendingCount)  $default,) {final _that = this;
switch (_that) {
case _OpsLiveReservation():
return $default(_that.todayCount,_that.convertedCount,_that.enteredCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todayCount,  int convertedCount,  int enteredCount,  int pendingCount)?  $default,) {final _that = this;
switch (_that) {
case _OpsLiveReservation() when $default != null:
return $default(_that.todayCount,_that.convertedCount,_that.enteredCount,_that.pendingCount);case _:
  return null;

}
}

}

/// @nodoc


class _OpsLiveReservation implements OpsLiveReservation {
  const _OpsLiveReservation({this.todayCount = 0, this.convertedCount = 0, this.enteredCount = 0, this.pendingCount = 0});
  

@override@JsonKey() final  int todayCount;
@override@JsonKey() final  int convertedCount;
@override@JsonKey() final  int enteredCount;
@override@JsonKey() final  int pendingCount;

/// Create a copy of OpsLiveReservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsLiveReservationCopyWith<_OpsLiveReservation> get copyWith => __$OpsLiveReservationCopyWithImpl<_OpsLiveReservation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsLiveReservation&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount)&&(identical(other.convertedCount, convertedCount) || other.convertedCount == convertedCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}


@override
int get hashCode => Object.hash(runtimeType,todayCount,convertedCount,enteredCount,pendingCount);

@override
String toString() {
  return 'OpsLiveReservation(todayCount: $todayCount, convertedCount: $convertedCount, enteredCount: $enteredCount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class _$OpsLiveReservationCopyWith<$Res> implements $OpsLiveReservationCopyWith<$Res> {
  factory _$OpsLiveReservationCopyWith(_OpsLiveReservation value, $Res Function(_OpsLiveReservation) _then) = __$OpsLiveReservationCopyWithImpl;
@override @useResult
$Res call({
 int todayCount, int convertedCount, int enteredCount, int pendingCount
});




}
/// @nodoc
class __$OpsLiveReservationCopyWithImpl<$Res>
    implements _$OpsLiveReservationCopyWith<$Res> {
  __$OpsLiveReservationCopyWithImpl(this._self, this._then);

  final _OpsLiveReservation _self;
  final $Res Function(_OpsLiveReservation) _then;

/// Create a copy of OpsLiveReservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayCount = null,Object? convertedCount = null,Object? enteredCount = null,Object? pendingCount = null,}) {
  return _then(_OpsLiveReservation(
todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,convertedCount: null == convertedCount ? _self.convertedCount : convertedCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OpsLiveShare {

 int get activeCount; int get receivedCount; int get enteredCount;
/// Create a copy of OpsLiveShare
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsLiveShareCopyWith<OpsLiveShare> get copyWith => _$OpsLiveShareCopyWithImpl<OpsLiveShare>(this as OpsLiveShare, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsLiveShare&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.receivedCount, receivedCount) || other.receivedCount == receivedCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount));
}


@override
int get hashCode => Object.hash(runtimeType,activeCount,receivedCount,enteredCount);

@override
String toString() {
  return 'OpsLiveShare(activeCount: $activeCount, receivedCount: $receivedCount, enteredCount: $enteredCount)';
}


}

/// @nodoc
abstract mixin class $OpsLiveShareCopyWith<$Res>  {
  factory $OpsLiveShareCopyWith(OpsLiveShare value, $Res Function(OpsLiveShare) _then) = _$OpsLiveShareCopyWithImpl;
@useResult
$Res call({
 int activeCount, int receivedCount, int enteredCount
});




}
/// @nodoc
class _$OpsLiveShareCopyWithImpl<$Res>
    implements $OpsLiveShareCopyWith<$Res> {
  _$OpsLiveShareCopyWithImpl(this._self, this._then);

  final OpsLiveShare _self;
  final $Res Function(OpsLiveShare) _then;

/// Create a copy of OpsLiveShare
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeCount = null,Object? receivedCount = null,Object? enteredCount = null,}) {
  return _then(_self.copyWith(
activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,receivedCount: null == receivedCount ? _self.receivedCount : receivedCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsLiveShare].
extension OpsLiveSharePatterns on OpsLiveShare {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsLiveShare value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsLiveShare() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsLiveShare value)  $default,){
final _that = this;
switch (_that) {
case _OpsLiveShare():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsLiveShare value)?  $default,){
final _that = this;
switch (_that) {
case _OpsLiveShare() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeCount,  int receivedCount,  int enteredCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsLiveShare() when $default != null:
return $default(_that.activeCount,_that.receivedCount,_that.enteredCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeCount,  int receivedCount,  int enteredCount)  $default,) {final _that = this;
switch (_that) {
case _OpsLiveShare():
return $default(_that.activeCount,_that.receivedCount,_that.enteredCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeCount,  int receivedCount,  int enteredCount)?  $default,) {final _that = this;
switch (_that) {
case _OpsLiveShare() when $default != null:
return $default(_that.activeCount,_that.receivedCount,_that.enteredCount);case _:
  return null;

}
}

}

/// @nodoc


class _OpsLiveShare implements OpsLiveShare {
  const _OpsLiveShare({this.activeCount = 0, this.receivedCount = 0, this.enteredCount = 0});
  

@override@JsonKey() final  int activeCount;
@override@JsonKey() final  int receivedCount;
@override@JsonKey() final  int enteredCount;

/// Create a copy of OpsLiveShare
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsLiveShareCopyWith<_OpsLiveShare> get copyWith => __$OpsLiveShareCopyWithImpl<_OpsLiveShare>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsLiveShare&&(identical(other.activeCount, activeCount) || other.activeCount == activeCount)&&(identical(other.receivedCount, receivedCount) || other.receivedCount == receivedCount)&&(identical(other.enteredCount, enteredCount) || other.enteredCount == enteredCount));
}


@override
int get hashCode => Object.hash(runtimeType,activeCount,receivedCount,enteredCount);

@override
String toString() {
  return 'OpsLiveShare(activeCount: $activeCount, receivedCount: $receivedCount, enteredCount: $enteredCount)';
}


}

/// @nodoc
abstract mixin class _$OpsLiveShareCopyWith<$Res> implements $OpsLiveShareCopyWith<$Res> {
  factory _$OpsLiveShareCopyWith(_OpsLiveShare value, $Res Function(_OpsLiveShare) _then) = __$OpsLiveShareCopyWithImpl;
@override @useResult
$Res call({
 int activeCount, int receivedCount, int enteredCount
});




}
/// @nodoc
class __$OpsLiveShareCopyWithImpl<$Res>
    implements _$OpsLiveShareCopyWith<$Res> {
  __$OpsLiveShareCopyWithImpl(this._self, this._then);

  final _OpsLiveShare _self;
  final $Res Function(_OpsLiveShare) _then;

/// Create a copy of OpsLiveShare
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeCount = null,Object? receivedCount = null,Object? enteredCount = null,}) {
  return _then(_OpsLiveShare(
activeCount: null == activeCount ? _self.activeCount : activeCount // ignore: cast_nullable_to_non_nullable
as int,receivedCount: null == receivedCount ? _self.receivedCount : receivedCount // ignore: cast_nullable_to_non_nullable
as int,enteredCount: null == enteredCount ? _self.enteredCount : enteredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
