// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popup_ad_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PopupAdModel {

 String get popupId; String get imageUrl;/// 스크린리더용 사진 설명. 사진뿐인 팝업이라 이게 없으면 읽어 줄 것이 없다.
 String get altText; PopupAdLinkType get linkType; String get linkValue;/// 1순위 — 운영자 페이지 토글. true면 [order]와 무관하게 맨 앞.
 bool get isPrimary; int get order; bool get isActive; DateTime get startAt; DateTime get endAt;
/// Create a copy of PopupAdModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopupAdModelCopyWith<PopupAdModel> get copyWith => _$PopupAdModelCopyWithImpl<PopupAdModel>(this as PopupAdModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopupAdModel&&(identical(other.popupId, popupId) || other.popupId == popupId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.linkType, linkType) || other.linkType == linkType)&&(identical(other.linkValue, linkValue) || other.linkValue == linkValue)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt));
}


@override
int get hashCode => Object.hash(runtimeType,popupId,imageUrl,altText,linkType,linkValue,isPrimary,order,isActive,startAt,endAt);

@override
String toString() {
  return 'PopupAdModel(popupId: $popupId, imageUrl: $imageUrl, altText: $altText, linkType: $linkType, linkValue: $linkValue, isPrimary: $isPrimary, order: $order, isActive: $isActive, startAt: $startAt, endAt: $endAt)';
}


}

/// @nodoc
abstract mixin class $PopupAdModelCopyWith<$Res>  {
  factory $PopupAdModelCopyWith(PopupAdModel value, $Res Function(PopupAdModel) _then) = _$PopupAdModelCopyWithImpl;
@useResult
$Res call({
 String popupId, String imageUrl, String altText, PopupAdLinkType linkType, String linkValue, bool isPrimary, int order, bool isActive, DateTime startAt, DateTime endAt
});




}
/// @nodoc
class _$PopupAdModelCopyWithImpl<$Res>
    implements $PopupAdModelCopyWith<$Res> {
  _$PopupAdModelCopyWithImpl(this._self, this._then);

  final PopupAdModel _self;
  final $Res Function(PopupAdModel) _then;

/// Create a copy of PopupAdModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? popupId = null,Object? imageUrl = null,Object? altText = null,Object? linkType = null,Object? linkValue = null,Object? isPrimary = null,Object? order = null,Object? isActive = null,Object? startAt = null,Object? endAt = null,}) {
  return _then(_self.copyWith(
popupId: null == popupId ? _self.popupId : popupId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,linkType: null == linkType ? _self.linkType : linkType // ignore: cast_nullable_to_non_nullable
as PopupAdLinkType,linkValue: null == linkValue ? _self.linkValue : linkValue // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PopupAdModel].
extension PopupAdModelPatterns on PopupAdModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopupAdModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopupAdModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopupAdModel value)  $default,){
final _that = this;
switch (_that) {
case _PopupAdModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopupAdModel value)?  $default,){
final _that = this;
switch (_that) {
case _PopupAdModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String popupId,  String imageUrl,  String altText,  PopupAdLinkType linkType,  String linkValue,  bool isPrimary,  int order,  bool isActive,  DateTime startAt,  DateTime endAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopupAdModel() when $default != null:
return $default(_that.popupId,_that.imageUrl,_that.altText,_that.linkType,_that.linkValue,_that.isPrimary,_that.order,_that.isActive,_that.startAt,_that.endAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String popupId,  String imageUrl,  String altText,  PopupAdLinkType linkType,  String linkValue,  bool isPrimary,  int order,  bool isActive,  DateTime startAt,  DateTime endAt)  $default,) {final _that = this;
switch (_that) {
case _PopupAdModel():
return $default(_that.popupId,_that.imageUrl,_that.altText,_that.linkType,_that.linkValue,_that.isPrimary,_that.order,_that.isActive,_that.startAt,_that.endAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String popupId,  String imageUrl,  String altText,  PopupAdLinkType linkType,  String linkValue,  bool isPrimary,  int order,  bool isActive,  DateTime startAt,  DateTime endAt)?  $default,) {final _that = this;
switch (_that) {
case _PopupAdModel() when $default != null:
return $default(_that.popupId,_that.imageUrl,_that.altText,_that.linkType,_that.linkValue,_that.isPrimary,_that.order,_that.isActive,_that.startAt,_that.endAt);case _:
  return null;

}
}

}

/// @nodoc


class _PopupAdModel extends PopupAdModel {
  const _PopupAdModel({required this.popupId, required this.imageUrl, required this.altText, required this.linkType, required this.linkValue, required this.isPrimary, required this.order, required this.isActive, required this.startAt, required this.endAt}): super._();
  

@override final  String popupId;
@override final  String imageUrl;
/// 스크린리더용 사진 설명. 사진뿐인 팝업이라 이게 없으면 읽어 줄 것이 없다.
@override final  String altText;
@override final  PopupAdLinkType linkType;
@override final  String linkValue;
/// 1순위 — 운영자 페이지 토글. true면 [order]와 무관하게 맨 앞.
@override final  bool isPrimary;
@override final  int order;
@override final  bool isActive;
@override final  DateTime startAt;
@override final  DateTime endAt;

/// Create a copy of PopupAdModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopupAdModelCopyWith<_PopupAdModel> get copyWith => __$PopupAdModelCopyWithImpl<_PopupAdModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopupAdModel&&(identical(other.popupId, popupId) || other.popupId == popupId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.linkType, linkType) || other.linkType == linkType)&&(identical(other.linkValue, linkValue) || other.linkValue == linkValue)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt));
}


@override
int get hashCode => Object.hash(runtimeType,popupId,imageUrl,altText,linkType,linkValue,isPrimary,order,isActive,startAt,endAt);

@override
String toString() {
  return 'PopupAdModel(popupId: $popupId, imageUrl: $imageUrl, altText: $altText, linkType: $linkType, linkValue: $linkValue, isPrimary: $isPrimary, order: $order, isActive: $isActive, startAt: $startAt, endAt: $endAt)';
}


}

/// @nodoc
abstract mixin class _$PopupAdModelCopyWith<$Res> implements $PopupAdModelCopyWith<$Res> {
  factory _$PopupAdModelCopyWith(_PopupAdModel value, $Res Function(_PopupAdModel) _then) = __$PopupAdModelCopyWithImpl;
@override @useResult
$Res call({
 String popupId, String imageUrl, String altText, PopupAdLinkType linkType, String linkValue, bool isPrimary, int order, bool isActive, DateTime startAt, DateTime endAt
});




}
/// @nodoc
class __$PopupAdModelCopyWithImpl<$Res>
    implements _$PopupAdModelCopyWith<$Res> {
  __$PopupAdModelCopyWithImpl(this._self, this._then);

  final _PopupAdModel _self;
  final $Res Function(_PopupAdModel) _then;

/// Create a copy of PopupAdModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? popupId = null,Object? imageUrl = null,Object? altText = null,Object? linkType = null,Object? linkValue = null,Object? isPrimary = null,Object? order = null,Object? isActive = null,Object? startAt = null,Object? endAt = null,}) {
  return _then(_PopupAdModel(
popupId: null == popupId ? _self.popupId : popupId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,altText: null == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String,linkType: null == linkType ? _self.linkType : linkType // ignore: cast_nullable_to_non_nullable
as PopupAdLinkType,linkValue: null == linkValue ? _self.linkValue : linkValue // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
