import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ApotekItemCard extends StatefulWidget {
  const ApotekItemCard({
    super.key,
    required this.apotek,
    this.index,
    this.onTap,
  });

  final ApotekEntity apotek;
  final int? index;
  final Function()? onTap;

  @override
  State<ApotekItemCard> createState() => _ApotekItemCardState();
}

class _ApotekItemCardState extends State<ApotekItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.dividerLight.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppDimens.r16),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.h16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, widget.apotek),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.dividerLight),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoSection(
                      context,
                      label: 'Area',
                      value: widget.apotek.area ?? '-',
                      icon: PhosphorIcons.mapPin,
                      iconColor: AppColors.green,
                    ),
                  ),
                  Container(height: 28, width: 1, color: AppColors.dividerLight),
                  SizedBox(width: AppDimens.w16),
                  Expanded(
                    child: _buildInfoSection(
                      context,
                      label: 'Penanggung Jawab',
                      value: widget.apotek.namaAPJ ?? '-',
                      icon: PhosphorIcons.user,
                      iconColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.dividerLight),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Tipe',
                            value: widget.apotek.tipeOutlet ?? '-',
                            icon: PhosphorIcons.storefront,
                            iconColor: AppColors.orange,
                          ),
                        ),
                        Container(height: 28, width: 1, color: AppColors.dividerLight),
                        SizedBox(width: AppDimens.w16),
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Kategori',
                            value: widget.apotek.kategoriProduk ?? '-',
                            icon: PhosphorIcons.tag,
                            iconColor: AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Total Value',
                            value: widget.apotek.totalValue != null
                                ? 'Rp ${widget.apotek.totalValue!.toStringAsFixed(0)}'
                                : '-',
                            icon: PhosphorIcons.money,
                            iconColor: AppColors.primary,
                          ),
                        ),
                        Container(height: 28, width: 1, color: AppColors.dividerLight),
                        SizedBox(width: AppDimens.w16),
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Last Order',
                            value: widget.apotek.lastOrderDate ?? '-',
                            icon: PhosphorIcons.clockCounterClockwise,
                            iconColor: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Pemilik',
                            value: widget.apotek.namaOwner ?? '-',
                            icon: PhosphorIcons.identificationCard,
                            iconColor: AppColors.blue,
                          ),
                        ),
                        Container(height: 28, width: 1, color: AppColors.dividerLight),
                        SizedBox(width: AppDimens.w16),
                        Expanded(
                          child: _buildInfoSection(
                            context,
                            label: 'Dibuat Oleh',
                            value: widget.apotek.userCreatedName ?? '-',
                            icon: PhosphorIcons.userPlus,
                            iconColor: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isExpanded ? 'Sembunyikan Detail' : 'Lihat Detail',
                        style: context.textStyle.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ApotekEntity apotek) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: widget.index != null
                    ? Center(
                        child: Text(
                          '${widget.index! + 1}',
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Icon(
                        PhosphorIcons.storefront,
                        size: 16,
                        color: AppColors.primary,
                      ),
              ),
              SizedBox(width: AppDimens.w8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apotek.namaApotik ?? '-',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      apotek.kodeApotik ?? '-',
                      style: context.textStyle.bodySmall?.copyWith(
                        color: AppColors.labelSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (apotek.status != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: AppChip(
              label: apotek.status?.toActiveType?.toName ?? '',
              color: apotek.status?.toActiveType?.toColor ?? AppColors.fillSecondary,
              borderRadius: AppDimens.r16,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelPrimary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
