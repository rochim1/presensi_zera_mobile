import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_data/presensi_data.dart';

@RoutePage()
class ProfileOfficePage extends StatelessWidget {
  const ProfileOfficePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserGetDataCubit>()),
      ],
      child: BlocBuilder<UserGetDataCubit, UserGetDataState>(
        builder: (ctxUser, stateData) {
          return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
            builder: (context, stateLocal) {
              final userInstance =
                  stateData.data?.user?.instansiId ??
                  stateLocal.data?.user?.instansiId;
              return Scaffold(
                backgroundColor: AppColors.bgPrimary,
                appBar: const AppTopBar(title: 'Detail Perusahaan'),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppCard(
                              showHeaderDivider: true,
                              header: Text(
                                'Informasi Perusahaan',
                                style: context.textStyle.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              content: Column(
                                children: [
                                  Center(
                                    child: MemoryImageWidget(
                                      value: userInstance?.logo,
                                      defaultImage: AppImages.zeraLogo,
                                      isLoading: stateData.status.isLoading,
                                      radius: AppDimens.imageAvatarPSize.height,
                                      hasBorder: true,
                                      size: AppDimens.imageAvatarPSize,
                                    ),
                                  ),
                                  AppDimens.size3M.hSpace,
                                  ProfileFieldRow(
                                    title: 'Nama Perusahaan',
                                    value: AppUtility.nullHandler(
                                      userInstance?.namaInstansi,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Nama Resmi',
                                    value: AppUtility.nullHandler(
                                      userInstance?.namaResmi,
                                      fallback: '-',
                                    ),
                                  ),
                                  const _SubscriptionStatusWidget(),
                                  ProfileFieldRow(
                                    title: 'Nomor Telepon',
                                    value: AppUtility.nullHandler(
                                      userInstance?.telponNumber,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Website',
                                    value: AppUtility.nullHandler(
                                      userInstance?.website,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Tanggal Berdiri',
                                    value: AppUtility.nullHandler(
                                      userInstance
                                          ?.tahunBerdiri
                                          ?.toDateTime
                                          ?.yMMMMd,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Dasar Hukum',
                                    value: AppUtility.nullHandler(
                                      userInstance?.dasarHukumPendirian,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Alamat',
                                    value: AppUtility.nullHandler(
                                      userInstance?.alamat,
                                      fallback: '-',
                                    ),
                                  ),
                                  ProfileFieldRow(
                                    title: 'Kegiatan Usaha',
                                    value: AppUtility.nullHandler(
                                      userInstance?.kegiatanUsaha,
                                      fallback: '-',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppDimens.paddingLarge.hSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SubscriptionStatusWidget extends StatefulWidget {
  const _SubscriptionStatusWidget();

  @override
  State<_SubscriptionStatusWidget> createState() =>
      _SubscriptionStatusWidgetState();
}

class _SubscriptionStatusWidgetState extends State<_SubscriptionStatusWidget> {
  Map<String, dynamic>? _subData;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionStatus();
  }

  Future<void> _fetchSubscriptionStatus() async {
    try {
      final graphQlService = sl<GraphQlService>();
      const query = '''
query GetSubscriptionStatus {
  GetSubscriptionStatus {
    subscription_status
    package_name
    package_code
    subscription_end_date
    trial_start_date
    days_remaining
    is_owner
    grace_period_days
    grace_days_remaining
    access_level
  }
}
      ''';
      final response = await graphQlService.query(query: query);
      if (mounted) {
        setState(() {
          _subData = response['GetSubscriptionStatus'] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
        child: LinearProgressIndicator(),
      );
    }
    if (_errorMsg != null) {
      return const ProfileFieldRow(
        title: 'Status Langganan',
        value: 'Tidak tersedia',
      );
    }

    final rawStatus =
        _subData?['subscription_status']?.toString().toLowerCase() ?? 'trial';
    final status = _statusLabel(rawStatus);
    final pkgName = _subData?['package_name']?.toString() ?? '-';
    final days = _subData?['days_remaining']?.toString() ?? '0';
    final statusColor = _statusColor(rawStatus);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: statusColor.withValues(alpha: .24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langganan',
            style: context.textStyle.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppDimens.h8.hSpace,
          Wrap(
            spacing: AppDimens.w8,
            runSpacing: AppDimens.h8,
            children: [
              _SubscriptionPill(
                label: status,
                icon: Icons.bookmark,
                color: statusColor,
              ),
              _SubscriptionPill(
                label: pkgName,
                icon: Icons.workspace_premium_outlined,
                color: AppColors.primary,
              ),
              _SubscriptionPill(
                label: '$days hari tersisa',
                icon: Icons.schedule_outlined,
                color: AppColors.labelSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
    'active' => 'Aktif',
    'trial' => 'Trial',
    'expired' => 'Berakhir',
    'grace_period' => 'Masa Tenggang',
    'suspended' => 'Ditangguhkan',
    _ => status.isEmpty ? 'Tidak diketahui' : status.toUpperCase(),
  };

  Color _statusColor(String status) => switch (status) {
    'active' => Colors.green.shade700,
    'trial' => Colors.blue.shade700,
    'grace_period' => Colors.orange.shade800,
    'expired' || 'suspended' => Colors.red.shade700,
    _ => AppColors.labelSecondary,
  };
}

class _SubscriptionPill extends StatelessWidget {
  const _SubscriptionPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: context.textStyle.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
