class Survey {
  final String id;
  final String surveyCode;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isRequired;
  final bool isAnonymous;
  final int totalResponses;
  final DateTime? createdAt;

  const Survey({
    required this.id,
    required this.surveyCode,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    required this.isRequired,
    required this.isAnonymous,
    required this.totalResponses,
    this.createdAt,
  });
}
