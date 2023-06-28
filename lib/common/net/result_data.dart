class ResultData {
  dynamic data;
  bool result;
  int? code;
  dynamic headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}

extension ResultDataEx on ResultData {
  dynamic getData() => data['data'];

  int getErrorCode() => data['errorCode'];

  String getErrorMsg() => data['errorMsg'];
}
