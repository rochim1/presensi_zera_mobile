import 'package:equatable/equatable.dart';

class KpiAssignmentTemplate extends Equatable {
  final String? id;
  final String? namaTemplate;
  final bool? allowSelfAssessment;
  final bool? anonymousPeerReview;

  const KpiAssignmentTemplate({
    this.id,
    this.namaTemplate,
    this.allowSelfAssessment,
    this.anonymousPeerReview,
  });

  @override
  List<Object?> get props => [
    id,
    namaTemplate,
    allowSelfAssessment,
    anonymousPeerReview,
  ];
}
