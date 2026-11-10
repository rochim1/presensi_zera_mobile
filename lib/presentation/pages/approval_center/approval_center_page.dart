import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

/// One entry point; each destination retains its own filters and approval rules.
@RoutePage()
class ApprovalCenterPage extends StatefulWidget {
  const ApprovalCenterPage({super.key});

  static Future<void> open(BuildContext context) =>
      context.router.push(const ApprovalCenterPageRoute());

  @override
  State<ApprovalCenterPage> createState() => _ApprovalCenterPageState();
}

class _ApprovalCenterPageState extends State<ApprovalCenterPage> {
  String? _userId;
  Future<ApprovalAccess>? _access;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.watch<AppCubit>().state.user.data?.id;
    if (userId != _userId) {
      _userId = userId;
      _access = userId == null || userId.isEmpty
          ? null
          : ApprovalAccess.load(userId, sl<TestWorkflowUserUseCase>());
    }
  }

  void _retry() {
    final userId = _userId;
    if (userId == null || userId.isEmpty) return;
    setState(() {
      _access = ApprovalAccess.load(userId, sl<TestWorkflowUserUseCase>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: ('Pusat Persetujuan').tr(context),
        centerTitle: false,
        subtitle: ('Kelola persetujuan sesuai kewenangan Anda').tr(context),
      ),
      body: FutureBuilder<ApprovalAccess>(
        future: _access,
        builder: (context, snapshot) {
          if (_access == null) {
            return const Center(
              child: HrText('Informasi akun belum tersedia.'),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final access = snapshot.data;
          final allowed = access?.modules ?? const <ApprovalRequestType>{};
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const HrText(
                'Tinjau pengajuan sesuai kewenangan Anda. Setiap jenis memiliki antrean dan filter sendiri.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.bodyText,
                ),
              ),
              const SizedBox(height: 24),
              if (snapshot.hasError || access == null || access.hasFailure) ...[
                const HrText(
                  'Sebagian akses belum berhasil diperiksa. Coba lagi untuk memperbarui daftar.',
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const HrText('Coba lagi'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (allowed.any(
                (type) => type != ApprovalRequestType.payroll_batch,
              )) ...[
                const _SectionTitle('Pengajuan operasional'),
                const SizedBox(height: 12),
                if (allowed.contains(ApprovalRequestType.cuti))
                  _Destination(
                    'Cuti & izin',
                    'Tinjau tanggal, durasi, dan tahap persetujuan',
                    PhosphorIcons.suitcase,
                    () => LeavePageRoute(initialApproval: true),
                  ),
                if (allowed.contains(ApprovalRequestType.request_presensi))
                  _Destination(
                    'Koreksi presensi',
                    'Periksa pengajuan perubahan kehadiran',
                    PhosphorIcons.clipboardText,
                    () => AttendanceRequestPageRoute(initialApproval: true),
                  ),
                if (allowed.contains(ApprovalRequestType.lembur))
                  _Destination(
                    'Lembur',
                    'Periksa waktu tambahan dan alasannya',
                    PhosphorIcons.clock,
                    () => OvertimePageRoute(initialApproval: true),
                  ),
                if (allowed.contains(ApprovalRequestType.reimbursement))
                  _Destination(
                    'Reimbursement',
                    'Periksa nominal dan bukti pengeluaran',
                    PhosphorIcons.receipt,
                    () => ReimbursementPageRoute(initialApproval: true),
                  ),
                if (allowed.contains(ApprovalRequestType.shift_swap))
                  _Destination(
                    'Tukar shift',
                    'Periksa pertukaran jadwal karyawan',
                    PhosphorIcons.arrowsClockwise,
                    () => ShiftPageRoute(initialApproval: true),
                  ),
              ],
              if (allowed.contains(ApprovalRequestType.payroll_batch)) ...[
                const SizedBox(height: 16),
                const _SectionTitle('Payroll'),
                const SizedBox(height: 8),
                const HrText(
                  'Antrean payroll dipisahkan dari pengajuan harian agar peninjauan periode dan batch tetap fokus.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.labelSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _Destination(
                  'Persetujuan payroll',
                  'Buka batch, periode, dan rincian payroll',
                  PhosphorIcons.wallet,
                  () => const PayrollPageRoute(
                    children: [ApprovalPayrollPageRoute()],
                  ),
                ),
              ],
              if (allowed.isEmpty && access != null && !access.hasFailure)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: HrText(
                    'Belum ada jenis persetujuan yang ditugaskan kepada Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.5),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ApprovalAccess {
  final Set<ApprovalRequestType> modules;
  final bool hasFailure;
  const ApprovalAccess(this.modules, {this.hasFailure = false});

  static Future<ApprovalAccess> load(
    String userId,
    TestWorkflowUserUseCase useCase,
  ) async {
    const types = [
      ApprovalRequestType.cuti,
      ApprovalRequestType.request_presensi,
      ApprovalRequestType.lembur,
      ApprovalRequestType.reimbursement,
      ApprovalRequestType.shift_swap,
      ApprovalRequestType.payroll_batch,
    ];
    final results = await Future.wait(
      types.map((type) async {
        try {
          final result = await useCase
              .call(
                TestWorkflowUserParams(module: type.name, testUserId: userId),
              )
              .timeout(const Duration(seconds: 20));
          return result.fold(
            (_) => (type: type, allowed: false, failed: true),
            (response) => (
              type: type,
              allowed:
                  response.levels?.any(
                    (level) => level.userIsApprover == true,
                  ) ??
                  false,
              failed: false,
            ),
          );
        } catch (_) {
          return (type: type, allowed: false, failed: true);
        }
      }),
    );
    return ApprovalAccess({
      for (final result in results)
        if (result.allowed) result.type,
    }, hasFailure: results.any((result) => result.failed));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => HrText(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}

class _Destination extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final PageRouteInfo Function() destination;
  const _Destination(this.title, this.subtitle, this.icon, this.destination);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: AppColors.primary),
        title: HrText(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: HrText(
            subtitle,
            style: const TextStyle(fontSize: 12, height: 1.5),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () => context.router.push(destination()),
      ),
    ),
  );
}
