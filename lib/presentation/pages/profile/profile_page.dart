import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  final LoginUserEntity? loginUser;
  final Function(bool? value)? onChanged;
  const ProfilePage({super.key, this.loginUser, this.onChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showEmployeeIdCard(
    UserEntity? user, {
    String? fallbackName,
    String? fallbackInstitutionName,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _EmployeeIdCard(
              user: user,
              fallbackName: fallbackName,
              fallbackInstitutionName: fallbackInstitutionName,
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Material(
                color: Colors.black.withValues(alpha: .08),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Tutup',
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserGetDataCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserPostCubit>()),
        BlocProvider(create: (context) => sl<UserPostImageCubit>()),
        BlocProvider(create: (context) => sl<LoginSignOutCubit>()),
      ],
      child: Scaffold(
        body: BlocBuilder<UserGetDataCubit, UserGetDataState>(
          builder: (ctxUser, stateData) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: AppDimens.size8X * 3,
                  title: const Text('Profile'),
                  actions: [
                    IconButton(
                      tooltip: 'Tampilkan kartu identitas',
                      onPressed: () {
                        final appUser = context
                            .read<AppCubit>()
                            .state
                            .user
                            .data;
                        _showEmployeeIdCard(
                          stateData.data?.user,
                          fallbackName: appUser?.name,
                          fallbackInstitutionName:
                              appUser?.organization?.namaInstansi,
                        );
                      },
                      icon: const Icon(Icons.badge_outlined),
                    ),
                  ],
                  pinned: true,
                  backgroundColor: AppColors.transparent,
                  flexibleSpace: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(AppDimens.radiusLargeX),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          BlocBuilder<AppCubit, AppState>(
                            builder: (context, appState) {
                              final photo = appState
                                  .user
                                  .data
                                  ?.avatar
                                  ?.url
                                  .resolvedApiUri
                                  .toString();
                              if (photo == null || photo.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(
                                    AppDimens.radiusLargeX,
                                  ),
                                ),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 14,
                                    sigmaY: 14,
                                  ),
                                  child: Image.network(
                                    photo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(AppDimens.radiusLargeX),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withValues(alpha: .56),
                                  AppColors.secondary.withValues(alpha: .56),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: AppDimens.size5X,
                            ),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BlocConsumer<
                                    UserPostImageCubit,
                                    UserPostImageState
                                  >(
                                    listener: (_, state) {
                                      if (state.typeState.isLoading) {
                                        SmartDialog.showLoading();
                                      } else if (state.typeState.isLoaded) {
                                        SmartDialog.dismiss();
                                        Fluttertoast.showToast(
                                          msg: state.message!,
                                        );
                                        ctxUser
                                            .read<UserGetDataCubit>()
                                            .getData();
                                        context
                                            .read<AppCubit>()
                                            .getCurrentUser();
                                        widget.onChanged!(true);
                                      } else if (state.typeState.isNotLoaded) {
                                        SmartDialog.dismiss();
                                        if (state.failed!) {
                                          Fluttertoast.showToast(
                                            msg: state.message!,
                                          );
                                        } else {
                                          AppModalBottom.handleError(
                                            context,
                                            state.failure!,
                                          );
                                        }
                                      } else {
                                        SmartDialog.dismiss();
                                      }
                                    },
                                    builder: (ctxAvatar, _) {
                                      return BlocBuilder<
                                        UserGetLocalCubit,
                                        UserGetLocalState
                                      >(
                                        builder: (context, state) {
                                          return BlocBuilder<
                                            AppCubit,
                                            AppState
                                          >(
                                            builder: (context, appState) {
                                              return AvatarProfile(
                                                compact: true,
                                                photo: appState
                                                    .user
                                                    .data
                                                    ?.avatar
                                                    ?.url
                                                    .resolvedApiUri
                                                    .toString(),
                                                name:
                                                    state.data?.user?.name ??
                                                    'Anonim',
                                                role: state
                                                    .data
                                                    ?.user
                                                    ?.divisiId
                                                    ?.namaDivisi
                                                    ?.divisiTypeNamed,
                                                hasDelete:
                                                    AppUtility.nullHandler(
                                                      stateData
                                                          .data
                                                          ?.user
                                                          ?.urlFoto,
                                                      fallback: state
                                                          .data
                                                          ?.user
                                                          ?.urlFoto,
                                                    ).isNotEmpty,
                                                isLoading:
                                                    state.status.isLoading,
                                                onChange:
                                                    (
                                                      AvatarAnswerState? answer,
                                                    ) {
                                                      if (answer!.isCamera) {
                                                        ctxAvatar
                                                            .read<
                                                              UserPostImageCubit
                                                            >()
                                                            .update(
                                                              ImageSource
                                                                  .camera,
                                                            );
                                                      } else if (answer
                                                          .isGallery) {
                                                        ctxAvatar
                                                            .read<
                                                              UserPostImageCubit
                                                            >()
                                                            .update(
                                                              ImageSource
                                                                  .gallery,
                                                            );
                                                      } else {
                                                        ctxAvatar
                                                            .read<
                                                              UserPostImageCubit
                                                            >()
                                                            .delete();
                                                      }
                                                    },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ), // AppDimens.paddingMedium.hSpace,
                                  const _ProfileSubscriptionBadge(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildMenuSection(stateData.data?.user),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuSection(UserEntity? user) {
    return SliverToBoxAdapter(
      child: Container(
        color: context.theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(AppDimens.w16),
              padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ItemHeaderProfile(title: 'Umum'),
                  ItemListProfile(
                    icon: Icons.person_rounded,
                    title: 'Profil Pengguna',
                    description: 'Kelola informasi pribadi dan data diri Anda',
                    onTap: () =>
                        context.router.navigate(const ProfileUserPageRoute()),
                  ),
                  ItemListProfile(
                    icon: Icons.qr_code_2_rounded,
                    title: 'Kartu Identitas & QR Kegiatan',
                    description:
                        'Tampilkan QR untuk dipindai petugas presensi kegiatan',
                    onTap: () => _showEmployeeIdCard(user),
                  ),
                  ItemListProfile(
                    icon: Icons.account_circle_rounded,
                    title: 'Pengaturan Akun',
                    description: 'Ubah password dan pengaturan keamanan akun',
                    onTap: () => context.router.navigate(
                      const ProfileAccountPageRoute(),
                    ),
                  ),
                  ItemListProfile(
                    icon: Icons.delete_forever_rounded,
                    title: 'Hapus Akun',
                    description: 'Permintaan penghapusan akun Anda dari sistem',
                    onTap: () => AppUtility.launchLink(
                      'https://app.pantoo.id/request-delete-account',
                    ),
                  ),
                  ItemListProfile(
                    icon: Icons.business_rounded,
                    title: 'Detail Perusahaan',
                    description:
                        'Informasi lengkap tentang perusahaan tempat bekerja',
                    onTap: () =>
                        context.router.navigate(const ProfileOfficePageRoute()),
                  ),
                  ItemListProfile(
                    icon: Icons.directions_bike_rounded,
                    title: 'Kendaraan',
                    description:
                        'Daftar kendaraan yang terdaftar untuk perjalanan dinas',
                    onTap: () => context.router.navigate(
                      const ProfileInventoryPageRoute(),
                    ),
                  ),
                  ItemListProfile(
                    icon: Icons.sync_rounded,
                    title: 'Sinkronisasi Data',
                    description:
                        'Lihat daftar data offline yang belum terkirim ke server',
                    onTap: () =>
                        context.router.navigate(const ProfileSyncPageRoute()),
                  ),
                  const ItemHeaderProfile(title: 'Pusat Bantuan'),
                  ItemListProfile(
                    icon: Icons.phone_rounded,
                    title: 'Hubungi Kami',
                    description: 'Chat langsung dengan tim customer service',
                    onTap: () => AppUtility.launchLink(kUrlWA),
                  ),
                  ItemListProfile(
                    icon: Icons.help_rounded,
                    title: 'Bantuan',
                    description: 'Panduan penggunaan aplikasi dan FAQ',
                    onTap: () => AppUtility.launchLink(kUrlHelpDesk),
                  ),
                  ItemListProfile(
                    icon: Icons.security_rounded,
                    title: 'Kebijakan Privasi',
                    description: 'Ketentuan dan kebijakan privasi aplikasi',
                    onTap: () => AppUtility.launchLink(kUrlKebijakanPrivasi),
                  ),
                  const ItemListProfile(
                    typeItem: ItemTypeProfile.text,
                    icon: Icons.info_rounded,
                    title: 'Versi Aplikasi',
                    description:
                        'Informasi versi aplikasi yang sedang digunakan',
                  ),
                  BlocConsumer<LoginSignOutCubit, LoginSignOutState>(
                    listener: (context, state) {
                      if (state.status.isLoading) {
                        SmartDialog.showLoading();
                      } else if (state.status.isLoaded ||
                          state.status.isNotLoaded) {
                        SmartDialog.dismiss();
                        context.router.pushAndPopUntil(
                          IntroPageRoute(),
                          predicate: (r) => true,
                        );
                      }
                    },
                    builder: (ctxLog, state) => ItemListProfile(
                      icon: Icons.logout_rounded,
                      title: 'Keluar',
                      description: 'Keluar dari akun pada perangkat ini',
                      onTap: state.status.isLoading
                          ? null
                          : () async {
                              final answer = await AppModalBottom.showConfirm(
                                context,
                                contentSubtitle: kMsgBackApp,
                                yesOkLabel: 'Keluar',
                              );
                              if (!ctxLog.mounted) return;
                              if (answer != null && answer.isYesOk) {
                                ctxLog.read<LoginSignOutCubit>().logout();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
            AppDimens.paddingLargeX.hSpace,
          ],
        ),
      ),
    );
  }
}

class _EmployeeIdCard extends StatefulWidget {
  const _EmployeeIdCard({
    required this.user,
    this.fallbackName,
    this.fallbackInstitutionName,
  });

  final UserEntity? user;
  final String? fallbackName;
  final String? fallbackInstitutionName;

  @override
  State<_EmployeeIdCard> createState() => _EmployeeIdCardState();
}

class _EmployeeIdCardState extends State<_EmployeeIdCard> {
  late Future<String> _qrToken;
  Timer? _qrRefreshTimer;

  @override
  void initState() {
    super.initState();
    _qrToken = _loadQrToken();
    _qrRefreshTimer = Timer.periodic(const Duration(minutes: 4), (_) {
      if (mounted) setState(() => _qrToken = _loadQrToken());
    });
  }

  @override
  void dispose() {
    _qrRefreshTimer?.cancel();
    super.dispose();
  }

  Future<String> _loadQrToken() async {
    final response = await sl<GraphQlService>().query(
      query: r'''query GetMyEventQrToken { GetMyEventQrToken }''',
    );
    final token = response['GetMyEventQrToken']?.toString() ?? '';
    if (token.isEmpty) throw StateError('Token QR tidak tersedia');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    final employeeNumber = widget.user?.noIdentitas?.trim();
    final userInstitutionName = widget.user?.instansiId?.namaInstansi?.trim();
    final fallbackInstitutionName = widget.fallbackInstitutionName?.trim();
    final institutionName = userInstitutionName?.isNotEmpty == true
        ? userInstitutionName
        : fallbackInstitutionName;
    final userName = widget.user?.name?.trim();
    final fallbackName = widget.fallbackName?.trim();
    final displayName = userName?.isNotEmpty == true
        ? userName!
        : fallbackName?.isNotEmpty == true
        ? fallbackName!
        : null;
    final employeeFallback = institutionName?.isNotEmpty == true
        ? 'Karyawan $institutionName'
        : 'Karyawan';
    final displayId = employeeNumber?.isNotEmpty == true
        ? employeeNumber!
        : widget.user?.id ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'KARTU IDENTITAS',
            style: context.textStyle.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            displayName ?? employeeFallback,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.titleMedium?.copyWith(
              color: AppColors.grey.shade900,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.user?.divisiId?.namaDivisi ?? 'Karyawan',
            style: context.textStyle.bodySmall?.copyWith(
              color: AppColors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: $displayId',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.labelMedium?.copyWith(
              color: AppColors.grey.shade800,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FutureBuilder<String>(
                future: _qrToken,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return QrImageView(data: snapshot.data!, size: 220);
                  }
                  return SizedBox(
                    width: 220,
                    height: 220,
                    child: Center(
                      child: snapshot.hasError
                          ? IconButton(
                              tooltip: 'Muat ulang QR',
                              onPressed: () =>
                                  setState(() => _qrToken = _loadQrToken()),
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: AppColors.danger,
                              ),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Tunjukkan QR ini kepada petugas kegiatan.',
              style: context.textStyle.labelSmall?.copyWith(
                color: AppColors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSubscriptionBadge extends StatefulWidget {
  const _ProfileSubscriptionBadge();

  @override
  State<_ProfileSubscriptionBadge> createState() =>
      _ProfileSubscriptionBadgeState();
}

class _ProfileSubscriptionBadgeState extends State<_ProfileSubscriptionBadge> {
  Future<Map<String, dynamic>?>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _loadSubscription();
  }

  Future<Map<String, dynamic>?> _loadSubscription() async {
    final response = await sl<GraphQlService>().query(
      query: r'''query GetSubscriptionStatus {
        GetSubscriptionStatus { subscription_status package_name days_remaining }
      }''',
    );
    return response['GetSubscriptionStatus'] as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _subscription,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildPill(
            context,
            label: snapshot.hasError
                ? 'Langganan tidak tersedia'
                : 'Memuat langganan...',
            color: AppColors.primary,
          );
        }
        final data = snapshot.data!;
        final rawStatus =
            data['subscription_status']?.toString().toLowerCase() ?? 'trial';
        final status = switch (rawStatus) {
          'active' => 'Aktif',
          'trial' => 'Trial',
          'grace_period' => 'Masa Tenggang',
          'expired' => 'Berakhir',
          'suspended' => 'Ditangguhkan',
          _ => rawStatus.toUpperCase(),
        };
        final color = switch (rawStatus) {
          'active' => Colors.green.shade700,
          'trial' => Colors.blue.shade700,
          'grace_period' => Colors.orange.shade800,
          'expired' || 'suspended' => Colors.red.shade700,
          _ => AppColors.white,
        };
        final packageName = data['package_name']?.toString() ?? status;
        final days = data['days_remaining']?.toString();
        final label = days == null || days == '0'
            ? '$packageName · $status'
            : '$packageName · $status ($days hari)';

        return _buildPill(context, label: label, color: color);
      },
    );
  }

  Widget _buildPill(
    BuildContext context, {
    required String label,
    required Color color,
  }) => Container(
    margin: const EdgeInsets.only(top: AppDimens.paddingSmall),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: Colors.white.withValues(alpha: .4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bookmark, size: 16, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: context.textStyle.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
