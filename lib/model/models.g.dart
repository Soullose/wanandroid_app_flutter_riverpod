// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerImpl _$$BannerImplFromJson(Map<String, dynamic> json) => _$BannerImpl(
      desc: json['desc'] as String?,
      id: (json['id'] as num?)?.toInt(),
      imagePath: json['imagePath'] as String?,
      isVisible: (json['isVisible'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: (json['type'] as num?)?.toInt(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$BannerImplToJson(_$BannerImpl instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'order': instance.order,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
    };

_$ArticlesImpl _$$ArticlesImplFromJson(Map<String, dynamic> json) =>
    _$ArticlesImpl(
      adminAdd: json['adminAdd'] as bool?,
      apkLink: json['apkLink'] as String?,
      audit: (json['audit'] as num?)?.toInt(),
      author: json['author'] as String?,
      canEdit: json['canEdit'] as bool?,
      chapterId: (json['chapterId'] as num?)?.toInt(),
      chapterName: json['chapterName'] as String?,
      collect: json['collect'] as bool?,
      courseId: (json['courseId'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      descMd: json['descMd'] as String?,
      envelopePic: json['envelopePic'] as String?,
      fresh: json['fresh'] as bool?,
      host: json['host'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isAdminAdd: json['isAdminAdd'] as bool?,
      link: json['link'] as String?,
      niceDate: json['niceDate'] as String?,
      niceShareDate: json['niceShareDate'] as String?,
      origin: json['origin'] as String?,
      prefix: json['prefix'] as String?,
      projectLink: json['projectLink'] as String?,
      publishTime: (json['publishTime'] as num?)?.toInt(),
      realSuperChapterId: (json['realSuperChapterId'] as num?)?.toInt(),
      selfVisible: (json['selfVisible'] as num?)?.toInt(),
      shareDate: (json['shareDate'] as num?)?.toInt(),
      shareUser: json['shareUser'] as String?,
      superChapterId: (json['superChapterId'] as num?)?.toInt(),
      superChapterName: json['superChapterName'] as String?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      type: (json['type'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      visible: (json['visible'] as num?)?.toInt(),
      zan: (json['zan'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ArticlesImplToJson(_$ArticlesImpl instance) =>
    <String, dynamic>{
      'adminAdd': instance.adminAdd,
      'apkLink': instance.apkLink,
      'audit': instance.audit,
      'author': instance.author,
      'canEdit': instance.canEdit,
      'chapterId': instance.chapterId,
      'chapterName': instance.chapterName,
      'collect': instance.collect,
      'courseId': instance.courseId,
      'desc': instance.desc,
      'descMd': instance.descMd,
      'envelopePic': instance.envelopePic,
      'fresh': instance.fresh,
      'host': instance.host,
      'id': instance.id,
      'isAdminAdd': instance.isAdminAdd,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'niceShareDate': instance.niceShareDate,
      'origin': instance.origin,
      'prefix': instance.prefix,
      'projectLink': instance.projectLink,
      'publishTime': instance.publishTime,
      'realSuperChapterId': instance.realSuperChapterId,
      'selfVisible': instance.selfVisible,
      'shareDate': instance.shareDate,
      'shareUser': instance.shareUser,
      'superChapterId': instance.superChapterId,
      'superChapterName': instance.superChapterName,
      'tags': instance.tags,
      'title': instance.title,
      'type': instance.type,
      'userId': instance.userId,
      'visible': instance.visible,
      'zan': instance.zan,
    };

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) => _$TagImpl(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$TagImplToJson(_$TagImpl instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

_$PaginationDataImpl _$$PaginationDataImplFromJson(Map<String, dynamic> json) =>
    _$PaginationDataImpl(
      curPage: (json['curPage'] as num?)?.toInt(),
      datas: json['datas'] as List<dynamic>?,
      offset: (json['offset'] as num?)?.toInt(),
      over: json['over'] as bool?,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PaginationDataImplToJson(
        _$PaginationDataImpl instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
    };
