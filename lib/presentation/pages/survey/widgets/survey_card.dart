import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../survey_status.dart';

class SurveyCard extends StatelessWidget {
  final Survey? survey;
  final SurveyDisplayStatus status;
  final VoidCallback? onTapFill;
  final bool isLoading;

  const SurveyCard({
    super.key,
    required this.survey,
    required this.status,
    this.onTapFill,
  }) : isLoading = false;

  const SurveyCard.shimmer({super.key})
    : survey = null,
      status = SurveyDisplayStatus.active,
      onTapFill = null,
      isLoading = true;

  String _periodText(DateTime? startDate, DateTime? endDate) {
    final start = startDate != null
        ? startDate.format(pattern: 'dd-MM-yyyy')
        : '-';
    final end = endDate != null ? endDate.format(pattern: 'dd-MM-yyyy') : '-';
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppRequestCard.shimmer();
    }

    final currentSurvey = survey!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimens.h12,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentSurvey.title,
                    style: context.textStyle.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppChip(label: status.label, color: status.color),
              ],
            ),

            if (currentSurvey.description.trim().isNotEmpty)
              Text(
                currentSurvey.description,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            AppRequestDateRow(
              title: 'Periode',
              value: _periodText(
                currentSurvey.startDate,
                currentSurvey.endDate,
              ),
              icon: PhosphorIcons.calendarBlank,
              iconColor: AppColors.primary,
            ),

            Row(
              children: [
                AppChip(
                  label: currentSurvey.isRequired ? 'Wajib' : 'Opsional',
                  color: currentSurvey.isRequired
                      ? AppColors.warning
                      : AppColors.labelSecondary,
                ),
                const Spacer(),
                SizedBox(
                  width: AppDimens.w128,
                  child: AppButtonNew(
                    text: status.actionLabel,
                    onPressed: onTapFill,
                    fullWidth: false,
                    isDisabled: !status.isFillable,
                    variant: status.isFillable
                        ? AppButtonNewVariant.primary
                        : AppButtonNewVariant.tertiary,
                    style: status.isFillable
                        ? AppButtonNewStyle.filled
                        : AppButtonNewStyle.ghost,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
