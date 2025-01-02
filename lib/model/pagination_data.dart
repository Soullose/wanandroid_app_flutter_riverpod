// To parse this JSON data, do
//
//     final paginationData = paginationDataFromJson(jsonString);

part of 'models.dart';

// PaginationData paginationDataFromJson(String str) =>
//     PaginationData.fromJson(json.decode(str));
//
// String paginationDataToJson(PaginationData data) => json.encode(data.toJson());

// @freezed
@JsonSerializable(genericArgumentFactories: true)
class PaginationData<T> {
  int? curPage;
  List<T>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  PaginationData(this.curPage, this.datas, this.offset, this.over,
      this.pageCount, this.size, this.total);

  factory PaginationData.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$PaginationDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) =>
      _$PaginationDataToJson(this, toJsonT);

  @override
  String toString() {
    return 'PaginationData{curPage: $curPage, datas: $datas, offset: $offset, over: $over, pageCount: $pageCount, size: $size, total: $total}';
  }
}
