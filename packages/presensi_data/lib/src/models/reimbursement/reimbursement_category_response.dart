import 'package:freezed_annotation/freezed_annotation.dart';

part 'reimbursement_category_response.freezed.dart';

part 'reimbursement_category_response.g.dart';

@freezed
abstract class ReimbursementCategoryResponse
    with _$ReimbursementCategoryResponse {
  const factory ReimbursementCategoryResponse({
    required String value,
    required String label,
  }) = _ReimbursementCategoryResponse;

  factory ReimbursementCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementCategoryResponseFromJson(json);
}
