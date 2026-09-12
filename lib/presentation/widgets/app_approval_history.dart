import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AppApprovalHistory extends StatefulWidget {
  final ApprovalHistory history;
  final String title;

  const AppApprovalHistory({
    super.key,
    required this.history,
    this.title = 'Progress Approval',
  });

  @override
  State<AppApprovalHistory> createState() => _AppApprovalHistoryState();
}

class _AppApprovalHistoryState extends State<AppApprovalHistory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final allApprovers = widget.history.approvers.toList().reversed.toList();
    final showExpandButton = allApprovers.length > 1;
    final displayedApprovers = _isExpanded
        ? allApprovers
        : allApprovers.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: AppDimens.w8),
            AppChip(
              label:
                  '${widget.history.approvalType.toDisplayName} (${widget.history.currentLevel}/${widget.history.totalLevel})',
              color: AppColors.primary,
              fontSize: 10,
              borderRadius: AppDimens.r16,
            ),
          ],
        ),
        SizedBox(height: AppDimens.h12),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(displayedApprovers.length, (index) {
              final approver = displayedApprovers[index];
              final isLastItem = _isExpanded
                  ? (index == displayedApprovers.length - 1)
                  : true;

              return _ApproverItem(
                history: widget.history,
                approver: approver,
                isFirst: index == 0,
                isLast: isLastItem,
              );
            }),
          ),
        ),
        if (showExpandButton) ...[
          SizedBox(height: AppDimens.h4),
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppDimens.r8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimens.h4,
                horizontal: AppDimens.w8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: AppDimens.w4),
                  Icon(
                    _isExpanded
                        ? PhosphorIcons.caretUp
                        : PhosphorIcons.caretDown,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ApproverItem extends StatelessWidget {
  final ApprovalHistory history;
  final Approver approver;
  final bool isFirst;
  final bool isLast;

  const _ApproverItem({
    required this.history,
    required this.approver,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentLevel =
        history.currentLevel == approver.level &&
        approver.status == ApprovalStatus.pending;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.w8,
            child: Column(
              children: [
                Container(
                  width: AppDimens.w2,
                  height: AppDimens.h12,
                  color: isFirst
                      ? Colors.transparent
                      : AppColors.primary.withValues(alpha: 0.4),
                ),
                Container(
                  width: AppDimens.w12,
                  height: AppDimens.w12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: AppDimens.w2,
                    color: isLast
                        ? Colors.transparent
                        : AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.w16),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: AppDimens.h12),
              decoration: BoxDecoration(
                color: isCurrentLevel
                    ? AppColors.primary.withValues(alpha: 0.03)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.r12),
                border: Border.all(
                  color: isCurrentLevel
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.dividerLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.labelPrimary.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppExpansionTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        approver.levelName,
                        style: context.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.labelPrimary,
                        ),
                      ),
                    ),
                    if (isCurrentLevel &&
                        approver.status == ApprovalStatus.pending) ...[
                      PendingClockIcon(size: AppDimens.w16),
                      AppDimens.w8.wSpace,
                    ],
                    AppChip(
                      label: approver.status.toDisplayName,
                      color: approver.status.toDisplayColor,
                      fontSize: 10,
                      borderRadius: AppDimens.r32,
                    ),
                  ],
                ),
                subtitle: Text(
                  'Level ${approver.level}',
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                ),
                childrenPadding: EdgeInsets.all(AppDimens.paddingMediumX),
                children: [
                  _buildDetailRow(
                    context,
                    label: 'Approver',
                    value: approver.user.name.isEmptyStrip,
                    icon: PhosphorIcons.user,
                  ),
                  if (approver.actedAt != null) ...[
                    SizedBox(height: AppDimens.h12),
                    _buildDetailRow(
                      context,
                      label: 'Waktu',
                      value: approver.actedAt!.format(
                        pattern: 'dd MMM yyyy, HH:mm',
                      ),
                      icon: PhosphorIcons.clock,
                    ),
                  ],
                  if (approver.catatan != null &&
                      approver.catatan!.isNotEmpty) ...[
                    SizedBox(height: AppDimens.h12),
                    _buildDetailRow(
                      context,
                      label: 'Catatan',
                      value: approver.catatan!,
                      icon: PhosphorIcons.notebook,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailRow(
  BuildContext context, {
  required String label,
  required String value,
  required IconData icon,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: AppColors.labelSecondary),
      SizedBox(width: AppDimens.w8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelPrimary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class PendingClockIcon extends StatefulWidget {
  final double size;
  final Color color;

  const PendingClockIcon({
    super.key,
    this.size = 24,
    this.color = Colors.orange,
  });

  @override
  State<PendingClockIcon> createState() => _PendingClockIconState();
}

class _PendingClockIconState extends State<PendingClockIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ClockPainter(
              progress: controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ClockPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw circle
    canvas.drawCircle(center, radius, stroke);

    // Draw hour hand (rotating)
    final angle = 2 * pi * progress;
    final handLength = radius * 0.5;

    final handPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final handEnd = Offset(
      center.dx + handLength * cos(angle - pi / 2),
      center.dy + handLength * sin(angle - pi / 2),
    );

    canvas.drawLine(center, handEnd, handPaint);

    // Draw center dot
    canvas.drawCircle(center, 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
