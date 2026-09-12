import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_request.freezed.dart';

part 'pagination_request.g.dart';

@freezed
abstract class PaginationRequest with _$PaginationRequest {
  const factory PaginationRequest({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'limit') required int limit,
  }) = _PaginationRequest;

  factory PaginationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestFromJson(json);
}
