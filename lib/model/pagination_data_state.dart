import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_data_state.freezed.dart';

@freezed
class PaginationDataState<T> with _$PaginationDataState<T> {
  const factory PaginationDataState.loading() = Loading;

  const factory PaginationDataState.empty() = Empty;

  const factory PaginationDataState.ready(T data) = Ready<T>;

  const factory PaginationDataState.error({required String error}) = Error;
}
