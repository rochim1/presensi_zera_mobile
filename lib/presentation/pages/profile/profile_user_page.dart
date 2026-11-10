import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ProfileUserPage extends StatelessWidget {
  const ProfileUserPage({super.key});

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String _calculateTenure(DateTime joinDate) {
    final today = DateTime.now();
    int years = today.year - joinDate.year;
    int months = today.month - joinDate.month;
    int days = today.day - joinDate.day;

    if (days < 0) {
      months--;
      // Get last day of previous month
      final prevMonthDate = DateTime(today.year, today.month, 0);
      days += prevMonthDate.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final parts = <String>[];
    if (years > 0) {
      parts.add('$years Tahun');
    }
    if (months > 0) {
      parts.add('$months Bulan');
    }
    if (parts.isEmpty) {
      return 'Baru bergabung';
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserGetDataCubit>()..getData()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppTopBar(title: ('Profil Pengguna').tr(context)),
        body: BlocBuilder<UserGetDataCubit, UserGetDataState>(
          builder: (ctxUser, stateData) {
            return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
              builder: (context, stateLocal) {
                final user = stateData.data?.user ?? stateLocal.data?.user;

                // Gender display
                final genderVal = user?.gender?.toUpperCase() ?? '';
                final genderDisplay = genderVal == 'L'
                    ? 'Laki-laki'
                    : (genderVal == 'P' ? 'Perempuan' : '-');

                // Status display
                final statusVal = user?.status?.toUpperCase() ?? '';
                final statusDisplay = statusVal == 'ACTIVE'
                    ? 'Aktif'
                    : (statusVal == 'RESIGN'
                          ? 'Resign'
                          : (statusVal == 'DELETED' ? 'Dihapus' : '-'));

                // Identity type display
                final identityTypeDisplay =
                    user?.identityType?.toUpperCase() ?? 'KTP';

                // Age calculation
                final birthDateTime = user?.dateOfBirth?.toDateTime;
                final ageDisplay = birthDateTime != null
                    ? '${_calculateAge(birthDateTime)} Tahun'
                    : '-';

                // Tenure calculation
                final joinDateTime = user?.dateJoin?.toDateTime;
                final tenureDisplay = joinDateTime != null
                    ? _calculateTenure(joinDateTime)
                    : '-';

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Identitas Diri
                        AppCard(
                          showHeaderDivider: true,
                          header: HrText(
                            'Identitas Diri',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          content: Column(
                            children: [
                              _buildFieldRow(
                                context,
                                ('Nama Lengkap').tr(context),
                                user?.name ?? '-',
                              ),
                              _buildFieldRow(
                                context,
                                ('Username').tr(context),
                                user?.username ?? '-',
                              ),
                              _buildFieldRow(
                                context,
                                ('Email').tr(context),
                                user?.email ?? '-',
                              ),
                              _buildFieldRow(
                                context,
                                ('Jenis Kelamin').tr(context),
                                genderDisplay.tr(context),
                              ),
                              _buildFieldRow(
                                context,
                                ('No. Telepon').tr(context),
                                AppUtility.nullHandler(
                                  user?.telpNumber,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                ('Tanggal Lahir').tr(context),
                                AppUtility.nullHandler(
                                  user?.dateOfBirth?.toDateTime?.yMMMMd,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(context, 'Umur', ageDisplay),
                              _buildFieldRow(
                                context,
                                'Tipe Identitas',
                                identityTypeDisplay,
                              ),
                              _buildFieldRow(
                                context,
                                'No. Identitas',
                                AppUtility.nullHandler(
                                  user?.noIdentitas,
                                  fallback: '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingMedium.hSpace,

                        // Card 2: Alamat & Domisili
                        AppCard(
                          showHeaderDivider: true,
                          header: HrText(
                            'Alamat & Domisili',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          content: Column(
                            children: [
                              _buildFieldRow(
                                context,
                                ('Alamat KTP').tr(context),
                                AppUtility.nullHandler(
                                  user?.address,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                'Domisili',
                                AppUtility.nullHandler(
                                  user?.domisili,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                'Kode Pos',
                                AppUtility.nullHandler(
                                  user?.posCode,
                                  fallback: '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingMedium.hSpace,

                        // Card 3: Pekerjaan & Status
                        AppCard(
                          showHeaderDivider: true,
                          header: HrText(
                            'Pekerjaan & Status',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          content: Column(
                            children: [
                              _buildFieldRow(
                                context,
                                'Perusahaan',
                                AppUtility.nullHandler(
                                  user?.instansiId?.namaInstansi,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                ('Divisi').tr(context),
                                AppUtility.nullHandler(
                                  user?.divisiId?.namaDivisi,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                ('Tanggal Bergabung').tr(context),
                                AppUtility.nullHandler(
                                  user?.dateJoin?.toDateTime?.yMMMMd,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                'Lama Bergabung',
                                tenureDisplay,
                              ),
                              _buildFieldRow(
                                context,
                                ('Tanggal Resign').tr(context),
                                AppUtility.nullHandler(
                                  user?.dateResign?.toDateTime?.yMMMMd,
                                  fallback: '-',
                                ),
                              ),
                              _buildFieldRow(
                                context,
                                ('Status Karyawan').tr(context),
                                statusDisplay,
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingLarge.hSpace,
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: HrText(
              title,
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ' :  ',
            style: context.textStyle.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textStyle.bodyMedium?.copyWith(
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
