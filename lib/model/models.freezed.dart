// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Banner _$BannerFromJson(Map<String, dynamic> json) {
  return _Banner.fromJson(json);
}

/// @nodoc
mixin _$Banner {
  String? get desc => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  int? get isVisible => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this Banner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerCopyWith<Banner> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerCopyWith<$Res> {
  factory $BannerCopyWith(Banner value, $Res Function(Banner) then) =
      _$BannerCopyWithImpl<$Res, Banner>;
  @useResult
  $Res call(
      {String? desc,
      int? id,
      String? imagePath,
      int? isVisible,
      int? order,
      String? title,
      int? type,
      String? url});
}

/// @nodoc
class _$BannerCopyWithImpl<$Res, $Val extends Banner>
    implements $BannerCopyWith<$Res> {
  _$BannerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = freezed,
    Object? id = freezed,
    Object? imagePath = freezed,
    Object? isVisible = freezed,
    Object? order = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVisible: freezed == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as int?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerImplCopyWith<$Res> implements $BannerCopyWith<$Res> {
  factory _$$BannerImplCopyWith(
          _$BannerImpl value, $Res Function(_$BannerImpl) then) =
      __$$BannerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? desc,
      int? id,
      String? imagePath,
      int? isVisible,
      int? order,
      String? title,
      int? type,
      String? url});
}

/// @nodoc
class __$$BannerImplCopyWithImpl<$Res>
    extends _$BannerCopyWithImpl<$Res, _$BannerImpl>
    implements _$$BannerImplCopyWith<$Res> {
  __$$BannerImplCopyWithImpl(
      _$BannerImpl _value, $Res Function(_$BannerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? desc = freezed,
    Object? id = freezed,
    Object? imagePath = freezed,
    Object? isVisible = freezed,
    Object? order = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? url = freezed,
  }) {
    return _then(_$BannerImpl(
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVisible: freezed == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as int?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerImpl implements _Banner {
  const _$BannerImpl(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory _$BannerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerImplFromJson(json);

  @override
  final String? desc;
  @override
  final int? id;
  @override
  final String? imagePath;
  @override
  final int? isVisible;
  @override
  final int? order;
  @override
  final String? title;
  @override
  final int? type;
  @override
  final String? url;

  @override
  String toString() {
    return 'Banner(desc: $desc, id: $id, imagePath: $imagePath, isVisible: $isVisible, order: $order, title: $title, type: $type, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerImpl &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, desc, id, imagePath, isVisible, order, title, type, url);

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerImplCopyWith<_$BannerImpl> get copyWith =>
      __$$BannerImplCopyWithImpl<_$BannerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerImplToJson(
      this,
    );
  }
}

abstract class _Banner implements Banner {
  const factory _Banner(
      {final String? desc,
      final int? id,
      final String? imagePath,
      final int? isVisible,
      final int? order,
      final String? title,
      final int? type,
      final String? url}) = _$BannerImpl;

  factory _Banner.fromJson(Map<String, dynamic> json) = _$BannerImpl.fromJson;

  @override
  String? get desc;
  @override
  int? get id;
  @override
  String? get imagePath;
  @override
  int? get isVisible;
  @override
  int? get order;
  @override
  String? get title;
  @override
  int? get type;
  @override
  String? get url;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerImplCopyWith<_$BannerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Articles _$ArticlesFromJson(Map<String, dynamic> json) {
  return _Articles.fromJson(json);
}

/// @nodoc
mixin _$Articles {
  bool? get adminAdd => throw _privateConstructorUsedError;
  String? get apkLink => throw _privateConstructorUsedError;
  int? get audit => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  bool? get canEdit => throw _privateConstructorUsedError;
  int? get chapterId => throw _privateConstructorUsedError;
  String? get chapterName => throw _privateConstructorUsedError;
  bool? get collect => throw _privateConstructorUsedError;
  int? get courseId => throw _privateConstructorUsedError;
  String? get desc => throw _privateConstructorUsedError;
  String? get descMd => throw _privateConstructorUsedError;
  String? get envelopePic => throw _privateConstructorUsedError;
  bool? get fresh => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  bool? get isAdminAdd => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String? get niceDate => throw _privateConstructorUsedError;
  String? get niceShareDate => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get prefix => throw _privateConstructorUsedError;
  String? get projectLink => throw _privateConstructorUsedError;
  int? get publishTime => throw _privateConstructorUsedError;
  int? get realSuperChapterId => throw _privateConstructorUsedError;
  int? get selfVisible => throw _privateConstructorUsedError;
  int? get shareDate => throw _privateConstructorUsedError;
  String? get shareUser => throw _privateConstructorUsedError;
  int? get superChapterId => throw _privateConstructorUsedError;
  String? get superChapterName => throw _privateConstructorUsedError;
  List<Tag>? get tags => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get visible => throw _privateConstructorUsedError;
  int? get zan => throw _privateConstructorUsedError;

  /// Serializes this Articles to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Articles
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticlesCopyWith<Articles> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticlesCopyWith<$Res> {
  factory $ArticlesCopyWith(Articles value, $Res Function(Articles) then) =
      _$ArticlesCopyWithImpl<$Res, Articles>;
  @useResult
  $Res call(
      {bool? adminAdd,
      String? apkLink,
      int? audit,
      String? author,
      bool? canEdit,
      int? chapterId,
      String? chapterName,
      bool? collect,
      int? courseId,
      String? desc,
      String? descMd,
      String? envelopePic,
      bool? fresh,
      String? host,
      int? id,
      bool? isAdminAdd,
      String? link,
      String? niceDate,
      String? niceShareDate,
      String? origin,
      String? prefix,
      String? projectLink,
      int? publishTime,
      int? realSuperChapterId,
      int? selfVisible,
      int? shareDate,
      String? shareUser,
      int? superChapterId,
      String? superChapterName,
      List<Tag>? tags,
      String? title,
      int? type,
      int? userId,
      int? visible,
      int? zan});
}

/// @nodoc
class _$ArticlesCopyWithImpl<$Res, $Val extends Articles>
    implements $ArticlesCopyWith<$Res> {
  _$ArticlesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Articles
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adminAdd = freezed,
    Object? apkLink = freezed,
    Object? audit = freezed,
    Object? author = freezed,
    Object? canEdit = freezed,
    Object? chapterId = freezed,
    Object? chapterName = freezed,
    Object? collect = freezed,
    Object? courseId = freezed,
    Object? desc = freezed,
    Object? descMd = freezed,
    Object? envelopePic = freezed,
    Object? fresh = freezed,
    Object? host = freezed,
    Object? id = freezed,
    Object? isAdminAdd = freezed,
    Object? link = freezed,
    Object? niceDate = freezed,
    Object? niceShareDate = freezed,
    Object? origin = freezed,
    Object? prefix = freezed,
    Object? projectLink = freezed,
    Object? publishTime = freezed,
    Object? realSuperChapterId = freezed,
    Object? selfVisible = freezed,
    Object? shareDate = freezed,
    Object? shareUser = freezed,
    Object? superChapterId = freezed,
    Object? superChapterName = freezed,
    Object? tags = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? userId = freezed,
    Object? visible = freezed,
    Object? zan = freezed,
  }) {
    return _then(_value.copyWith(
      adminAdd: freezed == adminAdd
          ? _value.adminAdd
          : adminAdd // ignore: cast_nullable_to_non_nullable
              as bool?,
      apkLink: freezed == apkLink
          ? _value.apkLink
          : apkLink // ignore: cast_nullable_to_non_nullable
              as String?,
      audit: freezed == audit
          ? _value.audit
          : audit // ignore: cast_nullable_to_non_nullable
              as int?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      canEdit: freezed == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool?,
      chapterId: freezed == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      chapterName: freezed == chapterName
          ? _value.chapterName
          : chapterName // ignore: cast_nullable_to_non_nullable
              as String?,
      collect: freezed == collect
          ? _value.collect
          : collect // ignore: cast_nullable_to_non_nullable
              as bool?,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as int?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      descMd: freezed == descMd
          ? _value.descMd
          : descMd // ignore: cast_nullable_to_non_nullable
              as String?,
      envelopePic: freezed == envelopePic
          ? _value.envelopePic
          : envelopePic // ignore: cast_nullable_to_non_nullable
              as String?,
      fresh: freezed == fresh
          ? _value.fresh
          : fresh // ignore: cast_nullable_to_non_nullable
              as bool?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      isAdminAdd: freezed == isAdminAdd
          ? _value.isAdminAdd
          : isAdminAdd // ignore: cast_nullable_to_non_nullable
              as bool?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      niceDate: freezed == niceDate
          ? _value.niceDate
          : niceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      niceShareDate: freezed == niceShareDate
          ? _value.niceShareDate
          : niceShareDate // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
      projectLink: freezed == projectLink
          ? _value.projectLink
          : projectLink // ignore: cast_nullable_to_non_nullable
              as String?,
      publishTime: freezed == publishTime
          ? _value.publishTime
          : publishTime // ignore: cast_nullable_to_non_nullable
              as int?,
      realSuperChapterId: freezed == realSuperChapterId
          ? _value.realSuperChapterId
          : realSuperChapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      selfVisible: freezed == selfVisible
          ? _value.selfVisible
          : selfVisible // ignore: cast_nullable_to_non_nullable
              as int?,
      shareDate: freezed == shareDate
          ? _value.shareDate
          : shareDate // ignore: cast_nullable_to_non_nullable
              as int?,
      shareUser: freezed == shareUser
          ? _value.shareUser
          : shareUser // ignore: cast_nullable_to_non_nullable
              as String?,
      superChapterId: freezed == superChapterId
          ? _value.superChapterId
          : superChapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      superChapterName: freezed == superChapterName
          ? _value.superChapterName
          : superChapterName // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      visible: freezed == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as int?,
      zan: freezed == zan
          ? _value.zan
          : zan // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticlesImplCopyWith<$Res>
    implements $ArticlesCopyWith<$Res> {
  factory _$$ArticlesImplCopyWith(
          _$ArticlesImpl value, $Res Function(_$ArticlesImpl) then) =
      __$$ArticlesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? adminAdd,
      String? apkLink,
      int? audit,
      String? author,
      bool? canEdit,
      int? chapterId,
      String? chapterName,
      bool? collect,
      int? courseId,
      String? desc,
      String? descMd,
      String? envelopePic,
      bool? fresh,
      String? host,
      int? id,
      bool? isAdminAdd,
      String? link,
      String? niceDate,
      String? niceShareDate,
      String? origin,
      String? prefix,
      String? projectLink,
      int? publishTime,
      int? realSuperChapterId,
      int? selfVisible,
      int? shareDate,
      String? shareUser,
      int? superChapterId,
      String? superChapterName,
      List<Tag>? tags,
      String? title,
      int? type,
      int? userId,
      int? visible,
      int? zan});
}

/// @nodoc
class __$$ArticlesImplCopyWithImpl<$Res>
    extends _$ArticlesCopyWithImpl<$Res, _$ArticlesImpl>
    implements _$$ArticlesImplCopyWith<$Res> {
  __$$ArticlesImplCopyWithImpl(
      _$ArticlesImpl _value, $Res Function(_$ArticlesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Articles
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adminAdd = freezed,
    Object? apkLink = freezed,
    Object? audit = freezed,
    Object? author = freezed,
    Object? canEdit = freezed,
    Object? chapterId = freezed,
    Object? chapterName = freezed,
    Object? collect = freezed,
    Object? courseId = freezed,
    Object? desc = freezed,
    Object? descMd = freezed,
    Object? envelopePic = freezed,
    Object? fresh = freezed,
    Object? host = freezed,
    Object? id = freezed,
    Object? isAdminAdd = freezed,
    Object? link = freezed,
    Object? niceDate = freezed,
    Object? niceShareDate = freezed,
    Object? origin = freezed,
    Object? prefix = freezed,
    Object? projectLink = freezed,
    Object? publishTime = freezed,
    Object? realSuperChapterId = freezed,
    Object? selfVisible = freezed,
    Object? shareDate = freezed,
    Object? shareUser = freezed,
    Object? superChapterId = freezed,
    Object? superChapterName = freezed,
    Object? tags = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? userId = freezed,
    Object? visible = freezed,
    Object? zan = freezed,
  }) {
    return _then(_$ArticlesImpl(
      adminAdd: freezed == adminAdd
          ? _value.adminAdd
          : adminAdd // ignore: cast_nullable_to_non_nullable
              as bool?,
      apkLink: freezed == apkLink
          ? _value.apkLink
          : apkLink // ignore: cast_nullable_to_non_nullable
              as String?,
      audit: freezed == audit
          ? _value.audit
          : audit // ignore: cast_nullable_to_non_nullable
              as int?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      canEdit: freezed == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool?,
      chapterId: freezed == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      chapterName: freezed == chapterName
          ? _value.chapterName
          : chapterName // ignore: cast_nullable_to_non_nullable
              as String?,
      collect: freezed == collect
          ? _value.collect
          : collect // ignore: cast_nullable_to_non_nullable
              as bool?,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as int?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      descMd: freezed == descMd
          ? _value.descMd
          : descMd // ignore: cast_nullable_to_non_nullable
              as String?,
      envelopePic: freezed == envelopePic
          ? _value.envelopePic
          : envelopePic // ignore: cast_nullable_to_non_nullable
              as String?,
      fresh: freezed == fresh
          ? _value.fresh
          : fresh // ignore: cast_nullable_to_non_nullable
              as bool?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      isAdminAdd: freezed == isAdminAdd
          ? _value.isAdminAdd
          : isAdminAdd // ignore: cast_nullable_to_non_nullable
              as bool?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      niceDate: freezed == niceDate
          ? _value.niceDate
          : niceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      niceShareDate: freezed == niceShareDate
          ? _value.niceShareDate
          : niceShareDate // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
      projectLink: freezed == projectLink
          ? _value.projectLink
          : projectLink // ignore: cast_nullable_to_non_nullable
              as String?,
      publishTime: freezed == publishTime
          ? _value.publishTime
          : publishTime // ignore: cast_nullable_to_non_nullable
              as int?,
      realSuperChapterId: freezed == realSuperChapterId
          ? _value.realSuperChapterId
          : realSuperChapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      selfVisible: freezed == selfVisible
          ? _value.selfVisible
          : selfVisible // ignore: cast_nullable_to_non_nullable
              as int?,
      shareDate: freezed == shareDate
          ? _value.shareDate
          : shareDate // ignore: cast_nullable_to_non_nullable
              as int?,
      shareUser: freezed == shareUser
          ? _value.shareUser
          : shareUser // ignore: cast_nullable_to_non_nullable
              as String?,
      superChapterId: freezed == superChapterId
          ? _value.superChapterId
          : superChapterId // ignore: cast_nullable_to_non_nullable
              as int?,
      superChapterName: freezed == superChapterName
          ? _value.superChapterName
          : superChapterName // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      visible: freezed == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as int?,
      zan: freezed == zan
          ? _value.zan
          : zan // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticlesImpl implements _Articles {
  const _$ArticlesImpl(
      {this.adminAdd,
      this.apkLink,
      this.audit,
      this.author,
      this.canEdit,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.descMd,
      this.envelopePic,
      this.fresh,
      this.host,
      this.id,
      this.isAdminAdd,
      this.link,
      this.niceDate,
      this.niceShareDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.realSuperChapterId,
      this.selfVisible,
      this.shareDate,
      this.shareUser,
      this.superChapterId,
      this.superChapterName,
      final List<Tag>? tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan})
      : _tags = tags;

  factory _$ArticlesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticlesImplFromJson(json);

  @override
  final bool? adminAdd;
  @override
  final String? apkLink;
  @override
  final int? audit;
  @override
  final String? author;
  @override
  final bool? canEdit;
  @override
  final int? chapterId;
  @override
  final String? chapterName;
  @override
  final bool? collect;
  @override
  final int? courseId;
  @override
  final String? desc;
  @override
  final String? descMd;
  @override
  final String? envelopePic;
  @override
  final bool? fresh;
  @override
  final String? host;
  @override
  final int? id;
  @override
  final bool? isAdminAdd;
  @override
  final String? link;
  @override
  final String? niceDate;
  @override
  final String? niceShareDate;
  @override
  final String? origin;
  @override
  final String? prefix;
  @override
  final String? projectLink;
  @override
  final int? publishTime;
  @override
  final int? realSuperChapterId;
  @override
  final int? selfVisible;
  @override
  final int? shareDate;
  @override
  final String? shareUser;
  @override
  final int? superChapterId;
  @override
  final String? superChapterName;
  final List<Tag>? _tags;
  @override
  List<Tag>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? title;
  @override
  final int? type;
  @override
  final int? userId;
  @override
  final int? visible;
  @override
  final int? zan;

  @override
  String toString() {
    return 'Articles(adminAdd: $adminAdd, apkLink: $apkLink, audit: $audit, author: $author, canEdit: $canEdit, chapterId: $chapterId, chapterName: $chapterName, collect: $collect, courseId: $courseId, desc: $desc, descMd: $descMd, envelopePic: $envelopePic, fresh: $fresh, host: $host, id: $id, isAdminAdd: $isAdminAdd, link: $link, niceDate: $niceDate, niceShareDate: $niceShareDate, origin: $origin, prefix: $prefix, projectLink: $projectLink, publishTime: $publishTime, realSuperChapterId: $realSuperChapterId, selfVisible: $selfVisible, shareDate: $shareDate, shareUser: $shareUser, superChapterId: $superChapterId, superChapterName: $superChapterName, tags: $tags, title: $title, type: $type, userId: $userId, visible: $visible, zan: $zan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticlesImpl &&
            (identical(other.adminAdd, adminAdd) ||
                other.adminAdd == adminAdd) &&
            (identical(other.apkLink, apkLink) || other.apkLink == apkLink) &&
            (identical(other.audit, audit) || other.audit == audit) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.collect, collect) || other.collect == collect) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.descMd, descMd) || other.descMd == descMd) &&
            (identical(other.envelopePic, envelopePic) ||
                other.envelopePic == envelopePic) &&
            (identical(other.fresh, fresh) || other.fresh == fresh) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isAdminAdd, isAdminAdd) ||
                other.isAdminAdd == isAdminAdd) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.niceDate, niceDate) ||
                other.niceDate == niceDate) &&
            (identical(other.niceShareDate, niceShareDate) ||
                other.niceShareDate == niceShareDate) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.prefix, prefix) || other.prefix == prefix) &&
            (identical(other.projectLink, projectLink) ||
                other.projectLink == projectLink) &&
            (identical(other.publishTime, publishTime) ||
                other.publishTime == publishTime) &&
            (identical(other.realSuperChapterId, realSuperChapterId) ||
                other.realSuperChapterId == realSuperChapterId) &&
            (identical(other.selfVisible, selfVisible) ||
                other.selfVisible == selfVisible) &&
            (identical(other.shareDate, shareDate) ||
                other.shareDate == shareDate) &&
            (identical(other.shareUser, shareUser) ||
                other.shareUser == shareUser) &&
            (identical(other.superChapterId, superChapterId) ||
                other.superChapterId == superChapterId) &&
            (identical(other.superChapterName, superChapterName) ||
                other.superChapterName == superChapterName) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.zan, zan) || other.zan == zan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        adminAdd,
        apkLink,
        audit,
        author,
        canEdit,
        chapterId,
        chapterName,
        collect,
        courseId,
        desc,
        descMd,
        envelopePic,
        fresh,
        host,
        id,
        isAdminAdd,
        link,
        niceDate,
        niceShareDate,
        origin,
        prefix,
        projectLink,
        publishTime,
        realSuperChapterId,
        selfVisible,
        shareDate,
        shareUser,
        superChapterId,
        superChapterName,
        const DeepCollectionEquality().hash(_tags),
        title,
        type,
        userId,
        visible,
        zan
      ]);

  /// Create a copy of Articles
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticlesImplCopyWith<_$ArticlesImpl> get copyWith =>
      __$$ArticlesImplCopyWithImpl<_$ArticlesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticlesImplToJson(
      this,
    );
  }
}

abstract class _Articles implements Articles {
  const factory _Articles(
      {final bool? adminAdd,
      final String? apkLink,
      final int? audit,
      final String? author,
      final bool? canEdit,
      final int? chapterId,
      final String? chapterName,
      final bool? collect,
      final int? courseId,
      final String? desc,
      final String? descMd,
      final String? envelopePic,
      final bool? fresh,
      final String? host,
      final int? id,
      final bool? isAdminAdd,
      final String? link,
      final String? niceDate,
      final String? niceShareDate,
      final String? origin,
      final String? prefix,
      final String? projectLink,
      final int? publishTime,
      final int? realSuperChapterId,
      final int? selfVisible,
      final int? shareDate,
      final String? shareUser,
      final int? superChapterId,
      final String? superChapterName,
      final List<Tag>? tags,
      final String? title,
      final int? type,
      final int? userId,
      final int? visible,
      final int? zan}) = _$ArticlesImpl;

  factory _Articles.fromJson(Map<String, dynamic> json) =
      _$ArticlesImpl.fromJson;

  @override
  bool? get adminAdd;
  @override
  String? get apkLink;
  @override
  int? get audit;
  @override
  String? get author;
  @override
  bool? get canEdit;
  @override
  int? get chapterId;
  @override
  String? get chapterName;
  @override
  bool? get collect;
  @override
  int? get courseId;
  @override
  String? get desc;
  @override
  String? get descMd;
  @override
  String? get envelopePic;
  @override
  bool? get fresh;
  @override
  String? get host;
  @override
  int? get id;
  @override
  bool? get isAdminAdd;
  @override
  String? get link;
  @override
  String? get niceDate;
  @override
  String? get niceShareDate;
  @override
  String? get origin;
  @override
  String? get prefix;
  @override
  String? get projectLink;
  @override
  int? get publishTime;
  @override
  int? get realSuperChapterId;
  @override
  int? get selfVisible;
  @override
  int? get shareDate;
  @override
  String? get shareUser;
  @override
  int? get superChapterId;
  @override
  String? get superChapterName;
  @override
  List<Tag>? get tags;
  @override
  String? get title;
  @override
  int? get type;
  @override
  int? get userId;
  @override
  int? get visible;
  @override
  int? get zan;

  /// Create a copy of Articles
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticlesImplCopyWith<_$ArticlesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Tag _$TagFromJson(Map<String, dynamic> json) {
  return _Tag.fromJson(json);
}

/// @nodoc
mixin _$Tag {
  String? get name => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TagCopyWith<Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) then) =
      _$TagCopyWithImpl<$Res, Tag>;
  @useResult
  $Res call({String? name, String? url});
}

/// @nodoc
class _$TagCopyWithImpl<$Res, $Val extends Tag> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagImplCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$$TagImplCopyWith(_$TagImpl value, $Res Function(_$TagImpl) then) =
      __$$TagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? url});
}

/// @nodoc
class __$$TagImplCopyWithImpl<$Res> extends _$TagCopyWithImpl<$Res, _$TagImpl>
    implements _$$TagImplCopyWith<$Res> {
  __$$TagImplCopyWithImpl(_$TagImpl _value, $Res Function(_$TagImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_$TagImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagImpl implements _Tag {
  const _$TagImpl({this.name, this.url});

  factory _$TagImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagImplFromJson(json);

  @override
  final String? name;
  @override
  final String? url;

  @override
  String toString() {
    return 'Tag(name: $name, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url);

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      __$$TagImplCopyWithImpl<_$TagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagImplToJson(
      this,
    );
  }
}

abstract class _Tag implements Tag {
  const factory _Tag({final String? name, final String? url}) = _$TagImpl;

  factory _Tag.fromJson(Map<String, dynamic> json) = _$TagImpl.fromJson;

  @override
  String? get name;
  @override
  String? get url;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationData _$PaginationDataFromJson(Map<String, dynamic> json) {
  return _PaginationData.fromJson(json);
}

/// @nodoc
mixin _$PaginationData {
  int? get curPage => throw _privateConstructorUsedError;
  List<dynamic>? get datas => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;
  bool? get over => throw _privateConstructorUsedError;
  int? get pageCount => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;

  /// Serializes this PaginationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationDataCopyWith<PaginationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationDataCopyWith<$Res> {
  factory $PaginationDataCopyWith(
          PaginationData value, $Res Function(PaginationData) then) =
      _$PaginationDataCopyWithImpl<$Res, PaginationData>;
  @useResult
  $Res call(
      {int? curPage,
      List<dynamic>? datas,
      int? offset,
      bool? over,
      int? pageCount,
      int? size,
      int? total});
}

/// @nodoc
class _$PaginationDataCopyWithImpl<$Res, $Val extends PaginationData>
    implements $PaginationDataCopyWith<$Res> {
  _$PaginationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? curPage = freezed,
    Object? datas = freezed,
    Object? offset = freezed,
    Object? over = freezed,
    Object? pageCount = freezed,
    Object? size = freezed,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      curPage: freezed == curPage
          ? _value.curPage
          : curPage // ignore: cast_nullable_to_non_nullable
              as int?,
      datas: freezed == datas
          ? _value.datas
          : datas // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      over: freezed == over
          ? _value.over
          : over // ignore: cast_nullable_to_non_nullable
              as bool?,
      pageCount: freezed == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationDataImplCopyWith<$Res>
    implements $PaginationDataCopyWith<$Res> {
  factory _$$PaginationDataImplCopyWith(_$PaginationDataImpl value,
          $Res Function(_$PaginationDataImpl) then) =
      __$$PaginationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? curPage,
      List<dynamic>? datas,
      int? offset,
      bool? over,
      int? pageCount,
      int? size,
      int? total});
}

/// @nodoc
class __$$PaginationDataImplCopyWithImpl<$Res>
    extends _$PaginationDataCopyWithImpl<$Res, _$PaginationDataImpl>
    implements _$$PaginationDataImplCopyWith<$Res> {
  __$$PaginationDataImplCopyWithImpl(
      _$PaginationDataImpl _value, $Res Function(_$PaginationDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? curPage = freezed,
    Object? datas = freezed,
    Object? offset = freezed,
    Object? over = freezed,
    Object? pageCount = freezed,
    Object? size = freezed,
    Object? total = freezed,
  }) {
    return _then(_$PaginationDataImpl(
      curPage: freezed == curPage
          ? _value.curPage
          : curPage // ignore: cast_nullable_to_non_nullable
              as int?,
      datas: freezed == datas
          ? _value._datas
          : datas // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      over: freezed == over
          ? _value.over
          : over // ignore: cast_nullable_to_non_nullable
              as bool?,
      pageCount: freezed == pageCount
          ? _value.pageCount
          : pageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationDataImpl implements _PaginationData {
  const _$PaginationDataImpl(
      {this.curPage,
      final List<dynamic>? datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total})
      : _datas = datas;

  factory _$PaginationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationDataImplFromJson(json);

  @override
  final int? curPage;
  final List<dynamic>? _datas;
  @override
  List<dynamic>? get datas {
    final value = _datas;
    if (value == null) return null;
    if (_datas is EqualUnmodifiableListView) return _datas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? offset;
  @override
  final bool? over;
  @override
  final int? pageCount;
  @override
  final int? size;
  @override
  final int? total;

  @override
  String toString() {
    return 'PaginationData(curPage: $curPage, datas: $datas, offset: $offset, over: $over, pageCount: $pageCount, size: $size, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationDataImpl &&
            (identical(other.curPage, curPage) || other.curPage == curPage) &&
            const DeepCollectionEquality().equals(other._datas, _datas) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.over, over) || other.over == over) &&
            (identical(other.pageCount, pageCount) ||
                other.pageCount == pageCount) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      curPage,
      const DeepCollectionEquality().hash(_datas),
      offset,
      over,
      pageCount,
      size,
      total);

  /// Create a copy of PaginationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationDataImplCopyWith<_$PaginationDataImpl> get copyWith =>
      __$$PaginationDataImplCopyWithImpl<_$PaginationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationDataImplToJson(
      this,
    );
  }
}

abstract class _PaginationData implements PaginationData {
  const factory _PaginationData(
      {final int? curPage,
      final List<dynamic>? datas,
      final int? offset,
      final bool? over,
      final int? pageCount,
      final int? size,
      final int? total}) = _$PaginationDataImpl;

  factory _PaginationData.fromJson(Map<String, dynamic> json) =
      _$PaginationDataImpl.fromJson;

  @override
  int? get curPage;
  @override
  List<dynamic>? get datas;
  @override
  int? get offset;
  @override
  bool? get over;
  @override
  int? get pageCount;
  @override
  int? get size;
  @override
  int? get total;

  /// Create a copy of PaginationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationDataImplCopyWith<_$PaginationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
