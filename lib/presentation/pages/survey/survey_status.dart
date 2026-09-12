import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

enum SurveyDisplayStatus { notStarted, active, completed }

extension SurveyDisplayStatusExt on SurveyDisplayStatus {
  String get label {
    switch (this) {
      case SurveyDisplayStatus.notStarted:
        return 'Belum Mulai';
      case SurveyDisplayStatus.active:
        return 'Aktif';
      case SurveyDisplayStatus.completed:
        return 'Selesai';
    }
  }

  bool get isFillable => this == SurveyDisplayStatus.active;

  String get actionLabel {
    switch (this) {
      case SurveyDisplayStatus.notStarted:
        return 'Belum Mulai';
      case SurveyDisplayStatus.active:
        return 'Isi Survey';
      case SurveyDisplayStatus.completed:
        return 'Selesai';
    }
  }

  Color get color {
    switch (this) {
      case SurveyDisplayStatus.notStarted:
        return AppColors.blue;
      case SurveyDisplayStatus.active:
        return AppColors.green;
      case SurveyDisplayStatus.completed:
        return AppColors.grey;
    }
  }

  static SurveyDisplayStatus fromSurvey(Survey survey, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();

    if (survey.endDate != null && survey.endDate!.isBefore(currentTime)) {
      return SurveyDisplayStatus.completed;
    }

    if (survey.startDate != null && survey.startDate!.isAfter(currentTime)) {
      return SurveyDisplayStatus.notStarted;
    }

    return SurveyDisplayStatus.active;
  }
}
