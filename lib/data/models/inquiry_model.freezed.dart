// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InquiryModel {

 String get inquiryId; String get userId;/// 표시 이름. 어드민은 users 문서를 못 읽어(read: 본인만) 여기 비정규화한다.
 String get userName;/// 문의 유형 — "service"|"bug"|"report"|"account"|"etc" 영문 키만 저장.
/// 한글 라벨은 화면(`support_models.dart`)이 붙인다.
 String get category; String get title; String get content; List<String> get imageUrls;/// "pending" | "answered". 값이 늘어날 수 있으므로 판정은 [isAnswered] 한 곳에서.
 String get status; String get answer; DateTime? get answeredAt; String get answeredBy;/// 사용자가 답변을 확인한 시각. null 이면 미확인 = 배지 대상.
 DateTime? get readAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of InquiryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquiryModelCopyWith<InquiryModel> get copyWith => _$InquiryModelCopyWithImpl<InquiryModel>(this as InquiryModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InquiryModel&&(identical(other.inquiryId, inquiryId) || other.inquiryId == inquiryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.answeredBy, answeredBy) || other.answeredBy == answeredBy)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,inquiryId,userId,userName,category,title,content,const DeepCollectionEquality().hash(imageUrls),status,answer,answeredAt,answeredBy,readAt,createdAt,updatedAt);

@override
String toString() {
  return 'InquiryModel(inquiryId: $inquiryId, userId: $userId, userName: $userName, category: $category, title: $title, content: $content, imageUrls: $imageUrls, status: $status, answer: $answer, answeredAt: $answeredAt, answeredBy: $answeredBy, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InquiryModelCopyWith<$Res>  {
  factory $InquiryModelCopyWith(InquiryModel value, $Res Function(InquiryModel) _then) = _$InquiryModelCopyWithImpl;
@useResult
$Res call({
 String inquiryId, String userId, String userName, String category, String title, String content, List<String> imageUrls, String status, String answer, DateTime? answeredAt, String answeredBy, DateTime? readAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$InquiryModelCopyWithImpl<$Res>
    implements $InquiryModelCopyWith<$Res> {
  _$InquiryModelCopyWithImpl(this._self, this._then);

  final InquiryModel _self;
  final $Res Function(InquiryModel) _then;

/// Create a copy of InquiryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inquiryId = null,Object? userId = null,Object? userName = null,Object? category = null,Object? title = null,Object? content = null,Object? imageUrls = null,Object? status = null,Object? answer = null,Object? answeredAt = freezed,Object? answeredBy = null,Object? readAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
inquiryId: null == inquiryId ? _self.inquiryId : inquiryId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answeredBy: null == answeredBy ? _self.answeredBy : answeredBy // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InquiryModel].
extension InquiryModelPatterns on InquiryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InquiryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InquiryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InquiryModel value)  $default,){
final _that = this;
switch (_that) {
case _InquiryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InquiryModel value)?  $default,){
final _that = this;
switch (_that) {
case _InquiryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inquiryId,  String userId,  String userName,  String category,  String title,  String content,  List<String> imageUrls,  String status,  String answer,  DateTime? answeredAt,  String answeredBy,  DateTime? readAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InquiryModel() when $default != null:
return $default(_that.inquiryId,_that.userId,_that.userName,_that.category,_that.title,_that.content,_that.imageUrls,_that.status,_that.answer,_that.answeredAt,_that.answeredBy,_that.readAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inquiryId,  String userId,  String userName,  String category,  String title,  String content,  List<String> imageUrls,  String status,  String answer,  DateTime? answeredAt,  String answeredBy,  DateTime? readAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InquiryModel():
return $default(_that.inquiryId,_that.userId,_that.userName,_that.category,_that.title,_that.content,_that.imageUrls,_that.status,_that.answer,_that.answeredAt,_that.answeredBy,_that.readAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inquiryId,  String userId,  String userName,  String category,  String title,  String content,  List<String> imageUrls,  String status,  String answer,  DateTime? answeredAt,  String answeredBy,  DateTime? readAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InquiryModel() when $default != null:
return $default(_that.inquiryId,_that.userId,_that.userName,_that.category,_that.title,_that.content,_that.imageUrls,_that.status,_that.answer,_that.answeredAt,_that.answeredBy,_that.readAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _InquiryModel extends InquiryModel {
  const _InquiryModel({required this.inquiryId, required this.userId, this.userName = '', this.category = 'etc', required this.title, required this.content, final  List<String> imageUrls = const <String>[], this.status = 'pending', this.answer = '', this.answeredAt, this.answeredBy = '', this.readAt, required this.createdAt, required this.updatedAt}): _imageUrls = imageUrls,super._();
  

@override final  String inquiryId;
@override final  String userId;
/// 표시 이름. 어드민은 users 문서를 못 읽어(read: 본인만) 여기 비정규화한다.
@override@JsonKey() final  String userName;
/// 문의 유형 — "service"|"bug"|"report"|"account"|"etc" 영문 키만 저장.
/// 한글 라벨은 화면(`support_models.dart`)이 붙인다.
@override@JsonKey() final  String category;
@override final  String title;
@override final  String content;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

/// "pending" | "answered". 값이 늘어날 수 있으므로 판정은 [isAnswered] 한 곳에서.
@override@JsonKey() final  String status;
@override@JsonKey() final  String answer;
@override final  DateTime? answeredAt;
@override@JsonKey() final  String answeredBy;
/// 사용자가 답변을 확인한 시각. null 이면 미확인 = 배지 대상.
@override final  DateTime? readAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of InquiryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquiryModelCopyWith<_InquiryModel> get copyWith => __$InquiryModelCopyWithImpl<_InquiryModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InquiryModel&&(identical(other.inquiryId, inquiryId) || other.inquiryId == inquiryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.answeredBy, answeredBy) || other.answeredBy == answeredBy)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,inquiryId,userId,userName,category,title,content,const DeepCollectionEquality().hash(_imageUrls),status,answer,answeredAt,answeredBy,readAt,createdAt,updatedAt);

@override
String toString() {
  return 'InquiryModel(inquiryId: $inquiryId, userId: $userId, userName: $userName, category: $category, title: $title, content: $content, imageUrls: $imageUrls, status: $status, answer: $answer, answeredAt: $answeredAt, answeredBy: $answeredBy, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InquiryModelCopyWith<$Res> implements $InquiryModelCopyWith<$Res> {
  factory _$InquiryModelCopyWith(_InquiryModel value, $Res Function(_InquiryModel) _then) = __$InquiryModelCopyWithImpl;
@override @useResult
$Res call({
 String inquiryId, String userId, String userName, String category, String title, String content, List<String> imageUrls, String status, String answer, DateTime? answeredAt, String answeredBy, DateTime? readAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$InquiryModelCopyWithImpl<$Res>
    implements _$InquiryModelCopyWith<$Res> {
  __$InquiryModelCopyWithImpl(this._self, this._then);

  final _InquiryModel _self;
  final $Res Function(_InquiryModel) _then;

/// Create a copy of InquiryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inquiryId = null,Object? userId = null,Object? userName = null,Object? category = null,Object? title = null,Object? content = null,Object? imageUrls = null,Object? status = null,Object? answer = null,Object? answeredAt = freezed,Object? answeredBy = null,Object? readAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_InquiryModel(
inquiryId: null == inquiryId ? _self.inquiryId : inquiryId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answeredBy: null == answeredBy ? _self.answeredBy : answeredBy // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
