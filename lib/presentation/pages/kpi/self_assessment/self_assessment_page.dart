import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'bloc/self_assessment_cubit.dart';
import 'bloc/self_assessment_state.dart';

@RoutePage()
class SelfAssessmentPage extends StatelessWidget {
  final String id;
  const SelfAssessmentPage({super.key, @PathParam('id') required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SelfAssessmentCubit>()..init(id),
      child: const SelfAssessmentView(),
    );
  }
}

class SelfAssessmentView extends StatelessWidget {
  const SelfAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelfAssessmentCubit, SelfAssessmentState>(
      listenWhen: (p, c) => p.submitState != c.submitState,
      listener: (context, state) {
        state.submitState.whenOrNull(
          failure: (f) {
            AppSnackbar.showError(context, f.message);
          },
          success: (_) {
            AppSnackbar.showSuccess(context, 'Berhasil menyimpan penilaian');
            context.router.maybePop();
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          appBar: AppBar(title: const Text('Self Assessment')),
          body: state.detailState.when(
            initial: () => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (f) => _buildLoadFailure(
              context,
              f.message,
              () => context.read<SelfAssessmentCubit>().init(
                context.read<SelfAssessmentCubit>().state.assignmentId,
              ),
            ),
            success: (data) {
              final isReadonly = !const {
                'draft',
                'data_collection',
                'self_review',
              }.contains(data.status);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, data),
                          const SizedBox(height: 24),
                          ...data.scores?.map((score) {
                                if (score.indicator == null ||
                                    (score.indicator?.id?.isEmpty ?? true)) {
                                  return const SizedBox();
                                }
                                return _buildIndicatorItem(
                                  context,
                                  score,
                                  isReadonly,
                                );
                              }).toList() ??
                              [],
                          const SizedBox(height: 16),
                          Text(
                            'Catatan Global',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AppTextField(
                            initialValue: state.globalComment,
                            hintText:
                                'Tambahkan catatan keseluruhan (opsional)',
                            maxLines: 3,
                            readOnly: isReadonly,
                            onChanged: isReadonly
                                ? null
                                : (val) => context
                                      .read<SelfAssessmentCubit>()
                                      .updateGlobalComment(val),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isReadonly)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: AppButton(
                          text: 'Kirim Penilaian',
                          isLoading: state.submitState.isLoading,
                          onPressed: () => _confirmSubmit(context, data),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.template?.namaTemplate ?? '-',
            style: context.textStyle.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Periode: ${data.periodeLabel ?? '-'}',
            style: context.textStyle.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorItem(BuildContext context, score, bool isReadonly) {
    final indicator = score.indicator!;
    final state = context.watch<SelfAssessmentCubit>().state;
    final indicatorId = indicator.id ?? '';
    final hasRating = state.ratings.containsKey(indicatorId);
    final rating = (state.ratings[indicatorId] ?? 3.0)
        .clamp(1.0, 5.0)
        .toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                indicator.category?.namaKategori ?? 'Uncategorized',
                style: context.textStyle.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              indicator.namaIndikator ?? '-',
              style: context.textStyle.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (indicator.deskripsi != null && indicator.deskripsi!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  indicator.deskripsi!,
                  style: context.textStyle.bodySmall?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Bobot',
                    '${score.bobot ?? 0}%',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Target',
                    '${score.target ?? 0} ${indicator.satuan ?? ''}',
                  ),
                ),
                if (score.autoData != null && score.autoData!.isNotEmpty)
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Aktual',
                      '${score.nilaiAktual ?? 0}',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Penilaian Anda',
              style: context.textStyle.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.round().toString(),
              onChanged: isReadonly
                  ? null
                  : (val) {
                      context.read<SelfAssessmentCubit>().updateRating(
                        indicatorId,
                        val,
                      );
                    },
            ),
            Center(
              child: Text(
                hasRating
                    ? '${rating.round()} / 5'
                    : 'Geser untuk memberi nilai',
                style: context.textStyle.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: hasRating ? null : 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              initialValue: state.comments[indicatorId] ?? '',
              hintText: 'Catatan (Opsional)',
              maxLines: 2,
              readOnly: isReadonly,
              onChanged: isReadonly
                  ? null
                  : (val) => context.read<SelfAssessmentCubit>().updateComment(
                      indicatorId,
                      val,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSubmit(BuildContext context, dynamic assignment) async {
    final cubit = context.read<SelfAssessmentCubit>();
    final indicatorIds = (assignment.scores ?? [])
        .map((score) => score.indicator?.id)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    final missingRatings = indicatorIds.where(
      (id) => !cubit.state.ratings.containsKey(id),
    );
    if (indicatorIds.isEmpty) {
      AppSnackbar.showError(context, 'Indikator KPI belum tersedia.');
      return;
    }
    if (missingRatings.isNotEmpty) {
      AppSnackbar.showError(
        context,
        'Semua indikator harus diberi nilai sebelum dikirim.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kirim penilaian?'),
        content: const Text(
          'Pastikan seluruh nilai sudah benar. Setelah dikirim, penilaian akan masuk ke tahap review manager.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Periksa Lagi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await cubit.submit();
  }

  Widget _buildLoadFailure(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyle.bodySmall?.copyWith(color: AppColors.grey),
        ),
        Text(
          value,
          style: context.textStyle.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
