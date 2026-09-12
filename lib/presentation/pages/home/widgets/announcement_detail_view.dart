import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AnnouncementDetailView extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimens.w16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.bannerImage.isNotEmpty) ...[
            AppImage(
              url: announcement.bannerImage,
              width: double.infinity,
              height: AppDimens.h160,
              radius: BorderRadius.circular(AppDimens.r12),
              enablePreview: true,
              fit: BoxFit.cover,
              heroTag: announcement.bannerImage,
            ),
            SizedBox(height: AppDimens.h16),
          ],

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
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(announcement.prioritas),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppDimens.w6),
                  Text(
                    announcement.prioritas.name.toUpperCase(),
                    style: context.textStyle.labelSmall?.copyWith(
                      color: _getPriorityColor(announcement.prioritas),
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
                  size: 16,
                  color: AppColors.primary,
                ),
            ],
          ),

          SizedBox(height: AppDimens.h16),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w12,
              vertical: AppDimens.h10,
            ),
            decoration: BoxDecoration(
              color: AppColors.labelSecondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimens.r12),
              border: Border.all(color: AppColors.dividerLight),
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimens.w32,
                  height: AppDimens.w32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.r8),
                  ),
                  child: Icon(
                    PhosphorIcons.calendarBlank,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Periode pengumuman',
                        style: context.textStyle.labelSmall?.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                      ),
                      SizedBox(height: AppDimens.h2),
                      Text(
                        [
                          announcement.tanggalMulai?.format() ?? '-',
                          if (announcement.tanggalBerakhir != null)
                            ' – ${announcement.tanggalBerakhir?.format()}',
                        ].join(),
                        style: context.textStyle.bodySmall?.copyWith(
                          color: AppColors.labelPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if ((announcement.createdAt?.timeAgo() ?? '').isNotEmpty)
                  Text(
                    announcement.createdAt!.timeAgo(),
                    style: context.textStyle.labelSmall?.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: AppDimens.h16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimens.w16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimens.r12),
              border: Border.all(color: AppColors.dividerLight),
            ),
            child: Text(
              announcement.isi,
              style: context.textStyle.bodyMedium?.copyWith(
                height: 1.65,
                color: AppColors.labelPrimary,
              ),
            ),
          ),

          if (announcement.linkUrl.isNotEmpty) ...[
            SizedBox(height: AppDimens.h16),
            _LinkTile(url: announcement.linkUrl),
          ],

          SizedBox(height: AppDimens.h20),

          Divider(color: AppColors.dividerLight, height: 1),
          SizedBox(height: AppDimens.h16),

          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(
                  PhosphorIcons.user,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppDimens.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dibuat oleh',
                      style: context.textStyle.labelSmall?.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                    ),
                    Text(
                      announcement.createdBy.name,
                      style: context.textStyle.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (announcement.lampiran.isNotEmpty) ...[
            SizedBox(height: AppDimens.h20),
            Text(
              'Lampiran',
              style: context.textStyle.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimens.h12),

            ...announcement.lampiran.map((e) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppDimens.h8),
                child: _AttachmentTile(attachment: e),
              );
            }),
          ],
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

class _LinkTile extends StatelessWidget {
  final String url;

  const _LinkTile({required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.r12),
      onTap: () => context.router.push(InAppBrowserPageRoute(url: url)),
      child: Container(
        padding: EdgeInsets.all(AppDimens.w12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.r12),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.link, color: AppColors.primary, size: 18),
            SizedBox(width: AppDimens.w12),
            Expanded(
              child: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Icon(PhosphorIcons.caretRight, size: 16),
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final AnnouncementAttachment attachment;

  const _AttachmentTile({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.r12),
      onTap: () {
        if (attachment.url.isNotEmpty) {
          context.router.push(InAppBrowserPageRoute(url: attachment.url));
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppDimens.w12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r12),
          border: Border.all(
            color: AppColors.labelSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.fileText, color: AppColors.primary),
            SizedBox(width: AppDimens.w12),
            Expanded(
              child: Text(
                attachment.namaFile,
                style: context.textStyle.bodyMedium,
              ),
            ),
            Icon(PhosphorIcons.downloadSimple, size: 18),
          ],
        ),
      ),
    );
  }
}
