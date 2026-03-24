import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_data.freezed.dart';

/// 网络请求结果数据
/// 使用 freezed 生成不可变类
@freezed
sealed class ResultData with _$ResultData {
  const factory ResultData({
    /// 响应数据，使用 dynamic 以支持通用性
    required dynamic data,

    /// 请求是否成功
    required bool success,

    /// HTTP 状态码或自定义错误码
    int? code,

    /// 响应头信息
    dynamic headers,

    /// 错误或成功消息
    String? message,
  }) = _ResultData;
}
