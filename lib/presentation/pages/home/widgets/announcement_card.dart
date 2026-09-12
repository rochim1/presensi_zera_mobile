import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AnnouncementCard extends StatefulWidget {
  final Announcement? item;
  final VoidCallback? onTap;
  final bool isLoading;

  const AnnouncementCard({super.key, required this.item, this.onTap})
    : isLoading = false;

  const AnnouncementCard.shimmer({super.key})
    : item = null,
      onTap = null,
      isLoading = true;

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildShimmer(context);

    final announcement = widget.item!;

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: isPressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.r16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.r16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white,
                    AppColors.primary.withValues(alpha: 0.035),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(painter: _PantooWavePainter()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.w14,
                      vertical: AppDimens.h12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppChip(
                              label: announcement.kategori.toUpperCase(),
                              color: AppColors.primary,
                              borderRadius: AppDimens.r16,
                            ),

                            SizedBox(width: AppDimens.w8),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: AppDimens.w8,
                                  height: AppDimens.h8,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                      announcement.prioritas,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: AppDimens.w6),
                                Text(
                                  announcement.prioritas.name.toUpperCase(),
                                  style: context.theme.textTheme.labelSmall
                                      ?.copyWith(
                                        color: _getPriorityColor(
                                          announcement.prioritas,
                                        ),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            if (announcement.isPinned)
                              Icon(
                                PhosphorIcons.pushPinFill,
                                size: 14,
                                color: AppColors.primary,
                              ),
                          ],
                        ),

                        SizedBox(height: AppDimens.h8),

                        Text(
                          announcement.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: AppColors.labelPrimary,
                          ),
                        ),

                        SizedBox(height: AppDimens.h6),

                        Text(
                          announcement.isi,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            color: AppColors.labelPrimary.withValues(
                              alpha: 0.82,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: AppDimens.h8),

                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.calendarBlank,
                              size: 14,
                              color: AppColors.labelSecondary,
                            ),
                            SizedBox(width: AppDimens.w6),

                            Expanded(
                              child: Text(
                                [
                                  announcement.tanggalMulai?.format(),
                                  if (announcement.tanggalBerakhir != null)
                                    ' - ${announcement.tanggalBerakhir?.format()}',
                                ].join(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.theme.textTheme.bodySmall
                                    ?.copyWith(color: AppColors.labelSecondary),
                              ),
                            ),

                            SizedBox(width: AppDimens.w8),

                            Text(
                              announcement.createdAt?.timeAgo() ?? '',
                              style: context.theme.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.labelSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.r16),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimens.w16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppShimmer.box(
                      width: 80,
                      height: 24,
                      radius: AppDimens.r16,
                    ),
                    SizedBox(width: AppDimens.w8),
                    AppShimmer.circle(size: AppDimens.w8),
                  ],
                ),
                SizedBox(height: AppDimens.h16),
                AppShimmer.box(width: double.infinity, height: 20),
                SizedBox(height: AppDimens.h6),
                AppShimmer.box(width: 150, height: 20),
                SizedBox(height: AppDimens.h12),
                AppShimmer.box(width: double.infinity, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.tinggi:
        return AppColors.danger;
      case AnnouncementPriority.sedang:
        return AppColors.warning;
      case AnnouncementPriority.rendah:
        return AppColors.grey;
    }
  }
}

class _PantooWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backWave = Path()
      ..moveTo(size.width * 0.48, 0)
      ..cubicTo(
        size.width * 0.67,
        size.height * 0.34,
        size.width * 0.78,
        size.height * 0.06,
        size.width,
        size.height * 0.28,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(
      backWave,
      Paint()..color = AppColors.primary.withValues(alpha: 0.07),
    );

    final frontWave = Path()
      ..moveTo(size.width * 0.68, size.height)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.72,
        size.width * 0.9,
        size.height * 0.86,
        size.width,
        size.height * 0.56,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      frontWave,
      Paint()..color = AppColors.primary.withValues(alpha: 0.11),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
