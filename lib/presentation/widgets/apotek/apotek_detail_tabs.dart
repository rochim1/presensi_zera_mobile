import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:url_launcher/url_launcher.dart';

class ApotekDetailIdentitasTab extends StatelessWidget {
  final ApotekEntity apotek;

  const ApotekDetailIdentitasTab({super.key, required this.apotek});

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ' :  ',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.labelPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            showHeaderDivider: true,
            header: Row(
              children: [
                Icon(
                  PhosphorIcons.userListFill,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: Text(
                    'Identitas Outlet',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  context,
                  label: 'Nama Outlet',
                  value: apotek.namaApotik?.isEmptyStrip ?? '-',
                ),

                _infoRow(
                  context,
                  label: 'Nama Pemilik',
                  value: apotek.namaOwner?.isEmptyStrip ?? '-',
                ),
                _infoRow(
                  context,
                  label: 'Penanggung Jawab',
                  value: apotek.namaAPJ?.isEmptyStrip ?? '-',
                ),
                _infoRow(
                  context,
                  label: 'Nomor Telepon',
                  value: apotek.telponNumber?.isEmptyStrip ?? '-',
                ),
                _infoRow(
                  context,
                  label: 'Ditambahkan Oleh',
                  value: apotek.userCreatedName?.isEmptyStrip ?? '-',
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.h16),
          AppCard(
            showHeaderDivider: true,
            header: Row(
              children: [
                Icon(
                  PhosphorIcons.lightningFill,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: Text(
                    'Aksi Cepat',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final phone = apotek.telponNumber;
                          if (phone != null && phone.isNotEmpty) {
                            final url = Uri.parse('tel:$phone');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          PhosphorIcons.phoneFill,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Telepon',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.w12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final phone = apotek.telponNumber;
                          if (phone != null && phone.isNotEmpty) {
                            var formattedPhone = phone;
                            if (formattedPhone.startsWith('0')) {
                              formattedPhone =
                                  '62${formattedPhone.substring(1)}';
                            }
                            final url = Uri.parse(
                              'https://wa.me/$formattedPhone',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981), // Emerald
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          PhosphorIcons.whatsappLogoFill,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.h12),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to taking order
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    PhosphorIcons.shoppingCartFill,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Buat Order (Taking Order)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApotekDetailLokasiTab extends StatelessWidget {
  final ApotekEntity apotek;
  final LatLng position;
  final String address;
  final bool isLoading;
  final Function(GoogleMapController)? onMapCreated;

  const ApotekDetailLokasiTab({
    super.key,
    required this.apotek,
    required this.position,
    required this.address,
    required this.isLoading,
    this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            content: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.r16),
              child: SizedBox(
                height: 250,
                child: MapViewWidget(
                  initialCameraPosition: CameraPosition(target: position),
                  onMapCreated: onMapCreated,
                  position: position,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimens.h16),
          AppCard(
            showHeaderDivider: true,
            header: Row(
              children: [
                Icon(
                  PhosphorIcons.mapPinFill,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: Text(
                    'Alamat',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            content: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    address.isNotEmpty ? address : 'Alamat tidak ditemukan',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ApotekDetailStatistikTab extends StatelessWidget {
  final ApotekEntity apotek;

  const ApotekDetailStatistikTab({super.key, required this.apotek});

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ' :  ',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.labelPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: AppCard(
        showHeaderDivider: true,
        header: Row(
          children: [
            Icon(
              PhosphorIcons.chartBarFill,
              size: 20,
              color: AppColors.primary,
            ),
            SizedBox(width: AppDimens.w10),
            Expanded(
              child: Text(
                'Statistik & CRM',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(
              context,
              label: 'Tipe Outlet',
              value: apotek.tipeOutlet?.isEmptyStrip ?? '-',
            ),
            _infoRow(
              context,
              label: 'Kategori Produk',
              value: apotek.kategoriProduk?.isEmptyStrip ?? '-',
            ),
            _infoRow(
              context,
              label: 'Total Pembelian',
              value: apotek.totalValue != null
                  ? 'Rp ${apotek.totalValue!.toStringAsFixed(0)}'
                  : '-',
            ),
            _infoRow(
              context,
              label: 'Transaksi Terakhir',
              value: apotek.lastOrderDate?.isEmptyStrip ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}

class ApotekDetailEmptyTab extends StatelessWidget {
  final String title;

  const ApotekDetailEmptyTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.fileXFill,
              size: 64,
              color: AppColors.labelTertiary,
            ),
            SizedBox(height: AppDimens.h16),
            Text(
              'Belum Ada Data $title',
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
            SizedBox(height: AppDimens.h8),
            Text(
              'Data $title saat ini belum tersedia untuk diakses dari aplikasi mobile.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
