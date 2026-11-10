import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/pages/approval_center/approval_center_page.dart';

enum HomeRequestKind { leave, overtime, attendance, reimbursement }

class HomeRequestSummary {
  final String id;
  final HomeRequestKind kind;
  final String title;
  final String status;
  final DateTime? date;
  final DateTime? submittedAt;
  const HomeRequestSummary({
    required this.id,
    required this.kind,
    required this.title,
    required this.status,
    this.date,
    this.submittedAt,
  });
}

class HomeRequestsResult {
  final List<HomeRequestSummary> requests;
  final int failedSources;
  const HomeRequestsResult(this.requests, {this.failedSources = 0});
}

/// The server is filtered by the signed-in user; rows are checked again before display.
class HomeRequestsLoader {
  final GetLeaveRequests leave;
  final GetOvertimeRequests overtime;
  final GetAttendanceRequests attendance;
  final GetMyReimbursements reimbursement;
  const HomeRequestsLoader({
    required this.leave,
    required this.overtime,
    required this.attendance,
    required this.reimbursement,
  });

  Future<HomeRequestsResult> load(String userId, DateTime month) async {
    if (userId.isEmpty) return const HomeRequestsResult([]);
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    final batches = await Future.wait([
      _batch(
        leave.call(
          GetLeaveRequestsParams(
            userId: userId,
            startDate: start,
            detailCuti: true,
            page: 0,
            limit: 3,
          ),
        ),
        (LeaveRequest value) => value.user.id != userId
            ? null
            : HomeRequestSummary(
                id: value.id,
                kind: HomeRequestKind.leave,
                title: value.category?.name ?? 'Cuti & izin',
                status: value.status.name,
                date: value.tanggalIzin,
                submittedAt: value.tanggalPengajuan,
              ),
      ),
      _batch(
        overtime.call(
          GetOvertimeRequestsParams(
            userId: userId,
            startDate: start,
            endDate: end,
            page: 0,
            limit: 3,
          ),
        ),
        (OvertimeRequest value) => value.user.id != userId
            ? null
            : HomeRequestSummary(
                id: value.id,
                kind: HomeRequestKind.overtime,
                title: 'Lembur',
                status: value.status.name,
                date: value.date,
                submittedAt: value.createdAt,
              ),
      ),
      _batch(
        attendance.call(
          GetAttendanceRequestsParams(
            userId: userId,
            startDate: start,
            endDate: end,
            page: 1,
            limit: 3,
          ),
        ),
        (AttendanceRequest value) => value.user?.id != userId
            ? null
            : HomeRequestSummary(
                id: value.id,
                kind: HomeRequestKind.attendance,
                title: 'Koreksi presensi',
                status: value.status.name,
                date: value.tanggalPresensi,
                submittedAt: value.createdAt,
              ),
      ),
      _batch(
        reimbursement.call(
          GetReimbursementsParams(
            userId: userId,
            startDate: start,
            endDate: end,
            page: 0,
            limit: 3,
          ),
        ),
        (Reimbursement value) => value.user?.id != userId
            ? null
            : HomeRequestSummary(
                id: value.id,
                kind: HomeRequestKind.reimbursement,
                title: value.judul ?? 'Reimbursement',
                status: value.statusReimbursement ?? value.status ?? '',
                date: value.tanggal,
                submittedAt: value.tanggalPengajuan ?? value.createdAt,
              ),
      ),
    ]);
    final requests = batches.expand((batch) => batch.requests).toList()
      ..sort(
        (a, b) => (b.submittedAt ?? b.date ?? DateTime(1970)).compareTo(
          a.submittedAt ?? a.date ?? DateTime(1970),
        ),
      );
    return HomeRequestsResult(
      List.unmodifiable(requests.take(3)),
      failedSources: batches.where((batch) => batch.failedSources > 0).length,
    );
  }

  Future<HomeRequestsResult> _batch<T>(
    Future<Either<Failure, List<T>>> request,
    HomeRequestSummary? Function(T) convert,
  ) async {
    try {
      final result = await request.timeout(const Duration(seconds: 20));
      return result.fold(
        (_) => const HomeRequestsResult([], failedSources: 1),
        (values) => HomeRequestsResult(
          values.map(convert).whereType<HomeRequestSummary>().toList(),
        ),
      );
    } catch (_) {
      return const HomeRequestsResult([], failedSources: 1);
    }
  }
}

class HomeRequestsSection extends StatefulWidget {
  final int refreshRevision;
  const HomeRequestsSection({super.key, this.refreshRevision = 0});
  @override
  State<HomeRequestsSection> createState() => _HomeRequestsSectionState();
}

class _HomeRequestsSectionState extends State<HomeRequestsSection> {
  String? _userId;
  Future<HomeRequestsResult>? _requests;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = context.watch<AppCubit>().state.user.data?.id;
    if (_userId != id) {
      _userId = id;
      _requests = _load();
    }
  }

  @override
  void didUpdateWidget(covariant HomeRequestsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshRevision != widget.refreshRevision) {
      _requests = _load();
    }
  }

  Future<HomeRequestsResult>? _load() {
    final id = _userId;
    if (id == null || id.isEmpty) return null;
    return HomeRequestsLoader(
      leave: sl<GetLeaveRequests>(),
      overtime: sl<GetOvertimeRequests>(),
      attendance: sl<GetAttendanceRequests>(),
      reimbursement: sl<GetMyReimbursements>(),
    ).load(id, DateTime.now());
  }

  void _refresh() => setState(() => _requests = _load());

  Future<void> _open(HomeRequestKind kind) async {
    final PageRouteInfo route = switch (kind) {
      HomeRequestKind.leave => LeavePageRoute(),
      HomeRequestKind.overtime => OvertimePageRoute(),
      HomeRequestKind.attendance => AttendanceRequestPageRoute(),
      HomeRequestKind.reimbursement => ReimbursementPageRoute(),
    };
    await context.router.push(route);
    if (mounted) _refresh();
  }

  void _showRequests() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: HrText(
                    'Pengajuan Saya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                for (final item in const [
                  (HomeRequestKind.leave, 'Cuti & izin'),
                  (HomeRequestKind.overtime, 'Lembur'),
                  (HomeRequestKind.attendance, 'Koreksi presensi'),
                  (HomeRequestKind.reimbursement, 'Reimbursement'),
                ])
                  ListTile(
                    title: HrText(item.$2),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _open(item.$1);
                    },
                  ),
                ListTile(
                  title: const HrText('Tukar shift'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.router.push(ShiftPageRoute());
                  },
                ),
                ListTile(
                  title: const HrText('Pinjaman'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.router.push(const LoanPageRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: HrText(
                'Pengajuan Saya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: _showRequests,
              child: const HrText('Lihat semua'),
            ),
          ],
        ),
        Text(
          hrLocale(context).homeRequestsMonthlySummary(
            DateFormat(
              'MMMM yyyy',
              AppLanguageController.instance.effectiveLocale.languageCode,
            ).format(DateTime.now()),
          ),
          style: const TextStyle(fontSize: 12, color: AppColors.labelSecondary),
        ),
        const SizedBox(height: 12),
        FutureBuilder<HomeRequestsResult>(
          future: _requests,
          builder: (context, snapshot) {
            if (_requests == null ||
                snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: LinearProgressIndicator(minHeight: 2),
              );
            }
            final result = snapshot.data;
            final requests = result?.requests ?? const <HomeRequestSummary>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (requests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: HrText(
                      result == null || result.failedSources > 0
                          ? 'Ringkasan belum berhasil dimuat. Buka jenis pengajuan atau coba lagi.'
                          : 'Belum ada pengajuan bulan ini.',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.bodyText,
                      ),
                    ),
                  ),
                for (final request in requests)
                  _RequestRow(
                    request: request,
                    onTap: () => _open(request.kind),
                  ),
                if (result == null || result.failedSources > 0) ...[
                  if (requests.isNotEmpty)
                    const HrText(
                      'Sebagian jenis pengajuan belum berhasil dimuat.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const HrText('Coba lagi'),
                  ),
                ],
              ],
            );
          },
        ),
        const Divider(height: 24),
        Material(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => ApprovalCenterPage.open(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.fact_check_outlined,
                    size: 26,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HrText(
                          'Pusat Persetujuan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        HrText(
                          'Tinjau pengajuan sesuai kewenangan',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RequestRow extends StatelessWidget {
  final HomeRequestSummary request;
  final VoidCallback onTap;
  const _RequestRow({required this.request, required this.onTap});
  @override
  Widget build(BuildContext context) {
    hrLocale(context); // Rebuild formatted dates when the language changes.
    final status = request.status.toLowerCase();
    final (label, color) = switch (status) {
      'diterima' || 'approved' => ('Disetujui', AppColors.primary),
      'ditolak' || 'rejected' => ('Ditolak', AppColors.danger),
      'cancelled' || 'canceled' => ('Dibatalkan', AppColors.labelSecondary),
      'active' => ('Aktif', AppColors.info),
      'diajukan' || 'pending' => ('Menunggu', AppColors.warning),
      _ => ('Lihat status', AppColors.labelSecondary),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (request.date != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                        AppLanguageController
                            .instance
                            .effectiveLocale
                            .languageCode,
                      ).format(request.date!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: HrText(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.labelSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
