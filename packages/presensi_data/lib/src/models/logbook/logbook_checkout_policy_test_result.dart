import 'package:equatable/equatable.dart';

class LogbookCheckoutPolicyTestResult extends Equatable {
  final String userId;
  final bool isRequired;
  final String policyName;
  final String reason;
  final int logbookCountToday;
  final int minLogbookEntries;
  final bool isBlocked;
  final String message;

  const LogbookCheckoutPolicyTestResult({
    required this.userId,
    required this.isRequired,
    required this.policyName,
    required this.reason,
    required this.logbookCountToday,
    required this.minLogbookEntries,
    required this.isBlocked,
    required this.message,
  });

  factory LogbookCheckoutPolicyTestResult.fromJson(Map<String, dynamic> json) {
    return LogbookCheckoutPolicyTestResult(
      userId: json['user_id'] ?? '',
      isRequired: json['is_required'] ?? false,
      policyName: json['policy_name'] ?? '',
      reason: json['reason'] ?? '',
      logbookCountToday: json['logbook_count_today'] ?? 0,
      minLogbookEntries: json['min_logbook_entries'] ?? 0,
      isBlocked: json['is_blocked'] ?? false,
      message: json['message'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        userId,
        isRequired,
        policyName,
        reason,
        logbookCountToday,
        minLogbookEntries,
        isBlocked,
        message,
      ];
}
