class LeaveCategory {
  final String id;
  final String name;
  final String? isSpecial;
  final int suggestedDayOff;
  final bool isAllowHalfDay;
  final String? isAllowExceedAnnually;
  final int numberOfExceed;
  final int maxDurationInDays;
  final String keterangan;
  final bool isNeedAttachment;
  final String? isAllowMinGap;
  final int minGapBeforeCuti;
  final String status;

  LeaveCategory({
    required this.id,
    required this.name,
    this.isSpecial,
    required this.suggestedDayOff,
    required this.isAllowHalfDay,
    this.isAllowExceedAnnually,
    required this.numberOfExceed,
    required this.maxDurationInDays,
    required this.keterangan,
    required this.isNeedAttachment,
    this.isAllowMinGap,
    required this.minGapBeforeCuti,
    required this.status,
  });
}
