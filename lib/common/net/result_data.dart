import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ResultData<T> {
  T data;
  bool result;
  int? code;
  dynamic headers;

  ResultData(this.data, this.result, this.code, {this.headers});

  factory ResultData.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$ResultDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) => _$ResultDataToJson(this, toJsonT);
  @override
  String toString() {
    return 'ResultData{data: $data, result: $result, code: $code, headers: $headers}';
  }
}

extension ResultDataEx on ResultData {
  dynamic getData() => data['data'];

  int getErrorCode() => data['errorCode'];

  String getErrorMsg() => data['errorMsg'];
}
