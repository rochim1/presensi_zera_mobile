import 'package:presensi_mobile/l10n/hr_localization.dart';
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
  @override
  Widget build(BuildContext context) {
    hrLocale(context); // Refresh relative timestamps when the language changes.
    if (widget.isLoading) return _buildShimmer(context);

    final announcement = widget.item!;

    final priorityColor = _getPriorityColor(announcement.prioritas);
    final dates = [
      announcement.tanggalMulai?.format(),
      if (announcement.tanggalBerakhir != null)
        announcement.tanggalBerakhir?.format(),
    ].whereType<String>().join(' – ');
    return Material(
      color: AppColors.primarySoft,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.successBorder),
          image: const DecorationImage(
            image: AssetImage(AppImages.geometricBg),
            fit: BoxFit.cover,
            opacity: 0.07,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        announcement.kategori.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      announcement.prioritas.name.capitalize.tr(context),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                    if (announcement.isPinned) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        PhosphorIcons.pushPinFill,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: AppColors.labelPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  announcement.isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.bodyText,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      PhosphorIcons.calendarBlank,
                      size: 14,
                      color: AppColors.labelSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dates.isNotEmpty
                            ? dates
                            : announcement.createdAt?.timeAgo() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.labelSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
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
