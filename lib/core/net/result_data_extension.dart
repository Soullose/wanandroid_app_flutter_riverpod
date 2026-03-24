import 'package:wanandroid_app_flutter_riverpod/model/pagination_data.dart';

import 'result_data.dart';

/// ResultData 扩展方法
/// 提供便捷的数据解析方法，避免手动处理类型转换
extension ResultDataExtension on ResultData {
  /// 将 data 转换为 `Map<String, dynamic>` 类型
  /// 如果 data 为 null 或不是 Map 类型，返回 null
  Map<String, dynamic>? get asMap {
    final d = data;
    if (d == null || d is! Map<String, dynamic>) return null;
    return d;
  }

  /// 将 data 转换为 List 类型
  /// 如果 data 为 null 或不是 List 类型，返回 null
  List<dynamic>? get asList {
    final d = data;
    if (d == null || d is! List) return null;
    return d;
  }

  /// 将 data 解析为指定类型的对象
  /// [fromJson] 是从 JSON 创建对象的工厂函数
  ///
  /// 示例:
  /// ```dart
  /// final article = response?.parseData((json) => Article.fromJson(json));
  /// ```
  T? parseData<T>(T Function(Map<String, dynamic> json) fromJson) {
    final map = asMap;
    if (map == null) return null;
    return fromJson(map);
  }

  /// 将 data 解析为指定类型的列表
  /// [fromJson] 是从 JSON 创建单个对象的工厂函数
  ///
  /// 示例:
  /// ```dart
  /// final articles = response?.parseList((json) => Article.fromJson(json));
  /// ```
  List<T>? parseList<T>(T Function(Map<String, dynamic> json) fromJson) {
    final list = asList;
    if (list == null) return null;
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 将 data 解析为分页数据
  /// [fromJson] 是从 JSON 创建单个数据项的工厂函数
  ///
  /// 示例:
  /// ```dart
  /// final paginationData = response?.parsePagination<Articles>(
  ///   (json) => Articles.fromJson(json),
  /// );
  /// ```
  PaginationData<T>? parsePagination<T>(T Function(dynamic json) fromJson) {
    final map = asMap;
    if (map == null) return null;
    return PaginationData<T>.fromJson(map, fromJson);
  }
}
