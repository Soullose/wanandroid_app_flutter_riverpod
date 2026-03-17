class ResultData {
  dynamic data;
  bool result;
  int? code;
  Map<String, String>? headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}

extension ResultDataEx on ResultData {
  dynamic getData() => data['data'];
}
