import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/attendance_detail_state.dart';

@RoutePage()
class AttendanceDetailPage extends StatelessWidget {
  final String attendanceId;
  const AttendanceDetailPage({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AttendanceDetailCubit>()..init(attendanceId),
        ),
        BlocProvider(create: (_) => sl<UserGetLocalCubit>()..getData()),
      ],
      child: const AttendanceDetailView(),
    );
  }
}

@RoutePage()
class AttendanceDetailView extends StatelessWidget {
  const AttendanceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceDetailCubit, AttendanceDetailState>(
      builder: (context, detailState) {
        return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
          builder: (context, userState) {
            final attendance = detailState.attendance.data;
            final currentUser = userState.data;

            final isOwnAttendance =
                attendance != null &&
                currentUser != null &&
                attendance.user?.id == currentUser.userId;

            return Scaffold(
              appBar: const AppTopBar(title: 'Detail Presensi'),
              body: detailState.attendance.when(
                initial: () => const SizedBox.shrink(),
                loading: () => _buildLoading(context),
                success: (attendance) => _buildSuccess(
                  context,
                  detailState,
                  attendance,
                  context.read<AttendanceDetailCubit>(),
                ),
                failure: (failure) => AppErrorView(
                  failure: failure,
                  onRetry: () =>
                      context.read<AttendanceDetailCubit>().onRefresh(),
                ),
              ),
              bottomNavigationBar: isOwnAttendance
                  ? Container(
                      color: context.theme.scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMediumX,
                        vertical: AppDimens.paddingMedium,
                      ),
                      child: AppButtonNew(
                        text: 'Request Edit Presensi',
                        onPressed: () {
                          context.router.push(
                            AttendanceRequestFormPageRoute(
                              attendance: attendance,
                            ),
                          );
                        },
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          // User Info Card Shimmer
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMedium,
              vertical: AppDimens.paddingSmall,
            ),
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
            child: const AppUserInfoTile(
              isLoading: true,
              padding: EdgeInsets.zero,
            ),
          ),
          // Main Info Card Shimmer
          _shimmerCard(context, itemCount: 5),
          // Duration Card Shimmer
          _shimmerCard(context, itemCount: 2),
          // Standard Card Shimmer
          _shimmerCard(context, itemCount: 4),
          // Presence Tabs Card Shimmer
          _shimmerCard(context, itemCount: 3),
        ],
      ),
    );
  }

  Widget _shimmerCard(BuildContext context, {required int itemCount}) {
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
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppShimmer.circle(size: 20),
              const SizedBox(width: 10),
              AppShimmer.box(width: 120, height: 16),
            ],
          ),
          const SizedBox(height: 12),
          AppShimmer.box(width: double.infinity, height: 1),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: List.generate(
              itemCount,
              (index) => Row(
                children: [
                  AppShimmer.box(width: 80, height: 14),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppShimmer.box(width: double.infinity, height: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    AttendanceDetailState state,
    Attendance attendance,
    AttendanceDetailCubit cubit,
  ) {
    return AppSmartRefresher(
      onRefresh: () async => cubit.onRefresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppDimens.h16,
          children: [
            if (attendance.user != null)
              _buildUserInfo(context, attendance.user!),
            _buildMainInfoCard(context, attendance),
            _buildDurationCard(context, attendance),
            _buildStandarCard(context, attendance),
            _PresenceTabs(
              masukKerja: _buildPresenceSection(
                context,
                title: 'Masuk Kerja',
                time: attendance.jamMasuk,
                addressState: state.checkInAddress,
                location: attendance.locationCheckIn,
                note: attendance.keterangan,
                photoUrl: attendance.fotoPresensi?.checkIn,
                pendukungUrl: attendance.fotoPendukung?.checkIn,
                key: const ValueKey('masuk_kerja'),
              ),
              pulangKerja: _buildPresenceSection(
                context,
                title: 'Pulang Kerja',
                time: attendance.jamPulang,
                addressState: state.checkOutAddress,
                location: attendance.locationCheckOut,
                note: null,
                photoUrl: attendance.fotoPresensi?.checkOut,
                pendukungUrl: attendance.fotoPendukung?.checkOut,
                key: const ValueKey('pulang_kerja'),
              ),
            ),
            if (attendance.activities.isNotEmpty)
              _buildAktivitasCard(context, attendance),
            _buildTechnicalInfo(context, attendance),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMedium,
        vertical: AppDimens.paddingSmall,
      ),
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
      child: AppUserInfoTile(user: user, padding: EdgeInsets.zero),
    );
  }

  // ── CARD: Info Utama ──
  Widget _buildMainInfoCard(BuildContext context, Attendance attendance) {
    final isToday = attendance.date?.isToday ?? false;
    return _card(
      context,
      title: 'Informasi Utama',
      icon: PhosphorIcons.identificationCardFill,
      children: [
        _infoRow(
          context,
          label: 'Tanggal',
          value:
              '${attendance.date?.format(pattern: 'EE, dd MMM yyyy')}${isToday ? " (Hari Ini)" : ""}',
        ),
        _infoRow(
          context,
          label: 'Status',
          valueWidget: AppChip(
            label: attendance.status.toDisplayName,
            color: attendance.status.toDisplayColor,
            borderRadius: AppDimens.r16,
          ),
        ),
        _infoRow(
          context,
          label: 'Tipe Presensi',
          value: attendance.type.toName,
        ),
        _infoRow(
          context,
          label: 'Check In',
          value: attendance.jamMasuk?.format(pattern: 'HH:mm:ss') ?? '--:--:--',
        ),
        _infoRow(
          context,
          label: 'Check Out',
          value:
              attendance.jamPulang?.format(pattern: 'HH:mm:ss') ?? '--:--:--',
        ),
      ],
    );
  }

  // ── CARD: Durasi ──
  Widget _buildDurationCard(BuildContext context, Attendance attendance) {
    return _card(
      context,
      title: 'Durasi Kerja',
      icon: PhosphorIcons.timerFill,
      children: [
        _infoRow(
          context,
          label: 'Total Kerja',
          value: attendance.totalKerja?.timeDuration() ?? '--:--',
        ),
        _infoRow(
          context,
          label: 'Total Istirahat',
          value: attendance.totalIstirahat?.timeDuration() ?? '--:--',
        ),
      ],
    );
  }

  // ── CARD: Waktu Standar ──
  Widget _buildStandarCard(BuildContext context, Attendance attendance) {
    final masukStandar = attendance.currentSetting?.jamMasuk ?? '-';
    final pulangStandar = attendance.currentSetting?.jamPulang ?? '-';

    String formatSelisih(String? strValue) {
      if (strValue == null) return '-';
      final value = double.tryParse(strValue);
      if (value == null) return strValue;

      final absVal = value.abs();
      final totalSeconds = (absVal * 60).round();
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      final seconds = totalSeconds % 60;
      
      final prefix = value < 0 ? '-' : '+';
      if (hours > 0) return '$prefix${hours}j ${minutes}m ${seconds}d';
      if (minutes > 0) return '$prefix${minutes}m ${seconds}d';
      return '$prefix${seconds}d';
    }

    return _card(
      context,
      title: 'Waktu Standar',
      icon: PhosphorIcons.clockCounterClockwiseFill,
      children: [
        _infoRow(context, label: 'Masuk Standar', value: masukStandar),
        _infoRow(
          context,
          label: 'Selisih Jam Masuk',
          value: formatSelisih(attendance.jarakCheckInToStandar),
        ),
        _infoRow(context, label: 'Pulang Standar', value: pulangStandar),
        _infoRow(
          context,
          label: 'Selisih Jam Pulang',
          value: formatSelisih(attendance.jarakCheckOutToStandar),
        ),
      ],
    );
  }

  // ── CARD: Presensi Tab Content ──
  Widget _buildPresenceSection(
    BuildContext context, {
    Key? key,
    required String title,
    DateTime? time,
    BaseState<AppAddress>? addressState,
    AppLocation? location,
    String? note,
    String? photoUrl,
    String? pendukungUrl,
  }) {
    final hasData = time != null || location != null || photoUrl != null;
    if (!hasData) {
      return Container(
        key: key,
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        alignment: Alignment.center,
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
        child: Text(
          'Belum ada data ${title.toLowerCase()}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
          ),
        ),
      );
    }

    final lat = location?.lat ?? double.parse(kDefaultLat);
    final lng = location?.long ?? double.parse(kDefaultLong);
    final latLng = LatLng(lat, lng);

    return Container(
      key: key,
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          if (location != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.r12),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    AppMapView(initialPosition: latLng, showMarker: true),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.router.push(
                            LocationPickerPageRoute(
                              isReadOnly: true,
                              initialLat: lat,
                              initialLong: lng,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (photoUrl != null || pendukungUrl != null)
            Row(
              spacing: AppDimens.w12,
              children: [
                if (photoUrl != null)
                  Expanded(
                    child: _buildFilePreview(
                      context,
                      label: 'Foto Presensi',
                      url: photoUrl,
                    ),
                  ),
                if (pendukungUrl != null)
                  Expanded(
                    child: _buildFilePreview(
                      context,
                      label: 'Foto Pendukung',
                      url: pendukungUrl,
                    ),
                  ),
              ],
            ),
          _infoRow(
            context,
            label: 'Waktu $title',
            value: time?.format(pattern: 'HH:mm:ss') ?? '--:--:--',
          ),
          if (location != null)
            _infoRow(
              context,
              label: 'Lokasi $title',
              valueWidget: addressState != null
                  ? addressState.when(
                      initial: () => const Text('-'),
                      loading: () => Text(
                        'Memuat alamat...',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.labelSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      success: (addr) => Text(
                        addr.address.isNotEmpty
                            ? addr.address
                            : 'Alamat tidak tersedia',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.labelPrimary,
                        ),
                      ),
                      failure: (fail) => Text(
                        'Gagal memuat alamat (${location.lat.toStringAsFixed(6)}, ${location.long.toStringAsFixed(6)})',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.red,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : const Text('-'),
            ),
          if (note != null && note.isNotEmpty)
            _infoRow(context, label: 'Catatan', value: note),
        ],
      ),
    );
  }

  Widget _buildFilePreview(
    BuildContext context, {
    required String label,
    required String url,
  }) {
    final resolvedUrl = AppUtility.resolveBackendUrl(url);
    final isPdf = url.toLowerCase().endsWith('.pdf');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppDimens.h8,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (isPdf)
          InkWell(
            onTap: () => AppUtility.launchLink(resolvedUrl),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.filePdfFill,
                    color: AppColors.red,
                    size: 48,
                  ),
                  SizedBox(height: AppDimens.h8),
                  Text(
                    'Lihat PDF',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
            child: CachedNetworkImage(
              imageUrl: resolvedUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => AppShimmer.box(
                width: double.infinity,
                height: 200,
                radius: AppDimens.radiusMediumX,
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: AppColors.bgSecondary,
                child: Center(
                  child: Icon(
                    PhosphorIcons.imageBroken,
                    color: AppColors.labelSecondary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        if (resolvedUrl.isNotEmpty) ...[
          InkWell(
            onTap: () => AppUtility.launchLink(resolvedUrl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Buka Tautan File',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  url,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.labelSecondary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── CARD: Aktivitas ──
  Widget _buildAktivitasCard(BuildContext context, Attendance attendance) {
    return _card(
      context,
      title: 'Daftar Aktivitas',
      icon: PhosphorIcons.listChecksFill,
      children: attendance.activities.asMap().entries.map((entry) {
        final index = entry.key;
        final activity = entry.value;
        return Column(
          children: [
            if (index > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.w12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name.toUpperCase(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (activity.jamMulai != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  PhosphorIcons.clock,
                                  size: 14,
                                  color: AppColors.labelSecondary,
                                ),
                                SizedBox(width: AppDimens.w4),
                                Text(
                                  activity.jamMulai!.format(
                                    pattern: 'HH:mm:ss',
                                  ),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.labelSecondary,
                                  ),
                                ),
                                if (activity.formatLocal?.full != null) ...[
                                  SizedBox(width: AppDimens.w10),
                                  Expanded(
                                    child: Text(
                                      '(${activity.formatLocal!.full!})',
                                      style: context.textTheme.labelSmall
                                          ?.copyWith(
                                            color: AppColors.labelTertiary,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        if (activity.keterangan != null &&
                            activity.keterangan!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              activity.keterangan!,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.labelSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (activity.isLate)
                    AppChip(
                      label: 'Terlambat',
                      color: AppColors.red,
                      borderRadius: AppDimens.r8,
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTechnicalInfo(BuildContext context, Attendance attendance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [const Divider(), AppMetaText('ID: #${attendance.id}')],
    );
  }

  // ── Helpers ──
  Widget _card(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return AppCard(
      showHeaderDivider: true,
      header: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: AppDimens.w10),
          Expanded(
            child: Text(
              title,
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
        spacing: AppDimens.h12,
        children: children,
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required String label,
    String? value,
    Widget? valueWidget,
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
            child:
                valueWidget ??
                Text(
                  value ?? '-',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.labelPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _PresenceTabs extends StatefulWidget {
  final Widget masukKerja;
  final Widget pulangKerja;

  const _PresenceTabs({required this.masukKerja, required this.pulangKerja});

  @override
  State<_PresenceTabs> createState() => _PresenceTabsState();
}

class _PresenceTabsState extends State<_PresenceTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppDimens.h16,
      children: [
        AppTabBar(
          tabs: const ['Masuk Kerja', 'Pulang Kerja'],
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          isScrollable: false,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentIndex == 0 ? widget.masukKerja : widget.pulangKerja,
        ),
      ],
    );
  }
}
