// To parse this JSON data, do
//
//     final paginationData = paginationDataFromJson(jsonString);

part of 'models.dart';

PaginationData paginationDataFromJson(String str) =>
    PaginationData.fromJson(json.decode(str));

String paginationDataToJson(PaginationData data) => json.encode(data.toJson());

@freezed
class PaginationData with _$PaginationData {
  const factory PaginationData({
    int? curPage,
    List<dynamic>? datas,
    int? offset,
    bool? over,
    int? pageCount,
    int? size,
    int? total,
  }) = _PaginationData;

  factory PaginationData.fromJson(Map<String, dynamic> json) =>
      _$PaginationDataFromJson(json);
}
