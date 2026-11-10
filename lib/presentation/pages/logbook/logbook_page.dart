import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

import 'bloc/logbook_cubit.dart';

@RoutePage()
class LogbookPage extends StatelessWidget {
  const LogbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        context.read<AppCubit>().getSetting();
        return LogbookCubit(remoteDatasource: sl<LogbookRemoteDatasource>())
          ..init();
      },
      child: const LogbookView(),
    );
  }
}

class LogbookView extends StatefulWidget {
  const LogbookView({super.key});

  @override
  State<LogbookView> createState() => _LogbookViewState();
}

class _LogbookViewState extends State<LogbookView> {
  String? _actionEntryId;

  // Categories remain explicit text; a neutral accent avoids arbitrary colors.
  Color _categoryColor(String? category) => AppColors.labelSecondary;

  String _formatDuration(int? minutes) {
    if (minutes == null || minutes == 0) return '0m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}j ${m}m';
    return '${m}m';
  }

  Future<void> _showAddLogbookSheet(
    BuildContext context, {
    LogbookEntry? entry,
  }) async {
    final cubit = context.read<LogbookCubit>();
    final appCubit = context.read<AppCubit>();
    final isEditing = entry != null;
    if (cubit.state.categories.isEmpty) {
      await cubit.fetchCategories();
    }
    if (!appCubit.state.setting.isSuccess) {
      await appCubit.getSetting();
    }
    if (!context.mounted) return;
    final setting = appCubit.state.setting.data;
    // If settings cannot be loaded yet, keep time fields flexible. The server
    // remains the source of truth and will enforce an enabled requirement.
    final requireTime = setting?.logbookRequireStartEndTime ?? false;
    final requireDescription = setting?.logbookRequireDescription ?? false;
    final requireCategory = setting?.logbookRequireCategory ?? false;
    final useDefaultTime = setting?.logbookUseDefaultTimeWhenEmpty ?? false;
    final defaultStartTime = setting?.logbookDefaultStartTime ?? '09:00';
    final defaultDurationMinutes = setting?.logbookDefaultDurationMinutes ?? 30;
    final defaultDuration =
        '${(defaultDurationMinutes ~/ 60).toString().padLeft(2, '0')}:${(defaultDurationMinutes % 60).toString().padLeft(2, '0')}';
    final titleController = TextEditingController(
      text: entry?.judulTugas ?? '',
    );
    final descController = TextEditingController(text: entry?.deskripsi ?? '');
    final categoryController = TextEditingController();
    final startController = TextEditingController(text: entry?.jamMulai ?? '');
    final endController = TextEditingController(text: entry?.jamSelesai ?? '');
    final sheetCategories = <String>[
      ...cubit.state.categories,
      if (entry?.kategoriTugas != null &&
          entry!.kategoriTugas!.isNotEmpty &&
          !cubit.state.categories.contains(entry.kategoriTugas))
        entry.kategoriTugas!,
    ];
    String? selectedCategory =
        entry?.kategoriTugas ??
        (sheetCategories.isNotEmpty ? sheetCategories.first : null);
    bool isAddingCategory = false;
    bool isSavingCategory = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                left: AppDimens.w20,
                right: AppDimens.w20,
                top: AppDimens.h20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + AppDimens.h20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.h16),
                    HrText(
                      isEditing ? 'Edit Logbook' : 'Tambah Logbook',
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelPrimary,
                      ),
                    ),
                    SizedBox(height: AppDimens.h16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: ('Judul Tugas *').tr(ctx),
                        hintText: ('Contoh: Menyusun laporan').tr(ctx),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(PhosphorIcons.notepad, size: 20),
                      ),
                    ),
                    SizedBox(height: AppDimens.h12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: InputDecoration(
                              labelText:
                                  ('Kategori Logbook${requireCategory ? ' *' : ''}')
                                      .tr(ctx),
                              hintText: (sheetCategories.isEmpty
                                  ? ('Kategori belum tersedia').tr(ctx)
                                  : ('Pilih kategori').tr(ctx)),
                              helperText: (sheetCategories.isEmpty
                                  ? (cubit.state.categoryError ??
                                        ('Tidak ada kategori aktif').tr(ctx))
                                  : null),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(PhosphorIcons.tag, size: 20),
                            ),
                            items: sheetCategories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: sheetCategories.isEmpty
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                          ),
                        ),
                        SizedBox(width: AppDimens.w8),
                        SizedBox(
                          width: 52,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isAddingCategory = !isAddingCategory;
                                if (!isAddingCategory) {
                                  categoryController.clear();
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Icon(
                              isAddingCategory
                                  ? PhosphorIcons.x
                                  : PhosphorIcons.plus,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isAddingCategory) ...[
                      SizedBox(height: AppDimens.h8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: categoryController,
                              autofocus: true,
                              enabled: !isSavingCategory,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: ('Nama Kategori Baru').tr(ctx),
                                hintText: ('Contoh: Meeting').tr(ctx),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimens.w8),
                          SizedBox(
                            width: 52,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isSavingCategory
                                  ? null
                                  : () async {
                                      final name = categoryController.text
                                          .trim();
                                      if (name.isEmpty) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          const SnackBar(
                                            content: HrText(
                                              'Nama kategori wajib diisi',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        isSavingCategory = true;
                                      });
                                      final created = await cubit.addCategory(
                                        name,
                                      );
                                      if (!ctx.mounted) return;
                                      setState(() {
                                        isSavingCategory = false;
                                        if (created != null) {
                                          if (!sheetCategories.contains(
                                            created,
                                          )) {
                                            sheetCategories.add(created);
                                          }
                                          selectedCategory = created;
                                          isAddingCategory = false;
                                          categoryController.clear();
                                        }
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isSavingCategory
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(PhosphorIcons.check, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: AppDimens.h12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: ('Mulai${requireTime ? ' *' : ''}').tr(
                                ctx,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(PhosphorIcons.clock, size: 20),
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: ctx,
                                initialTime: const TimeOfDay(
                                  hour: 9,
                                  minute: 0,
                                ),
                              );
                              if (time != null) {
                                startController.text =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.w8,
                          ),
                          child: Text(
                            '-',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: endController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: ('Selesai${requireTime ? ' *' : ''}')
                                  .tr(ctx),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(
                                PhosphorIcons.clockAfternoon,
                                size: 20,
                              ),
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: ctx,
                                initialTime: const TimeOfDay(
                                  hour: 17,
                                  minute: 0,
                                ),
                              );
                              if (time != null) {
                                endController.text =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (!requireTime && useDefaultTime) ...[
                      SizedBox(height: AppDimens.h8),
                      HrText(
                        'Jika waktu kosong, mulai pertama dari check-in/jadwal (fallback $defaultStartTime). Log berikutnya mulai dari selesai sebelumnya; durasi otomatis $defaultDuration.',
                        style: TextStyle(
                          color: AppColors.labelSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    SizedBox(height: AppDimens.h12),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: (requireDescription
                            ? ('Deskripsi *').tr(ctx)
                            : ('Deskripsi (Opsional)').tr(ctx)),
                        hintText: ('Detail pekerjaan...').tr(ctx),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Icon(PhosphorIcons.textAlignLeft, size: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.h20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final description = descController.text.trim();
                          final start = startController.text.trim();
                          final end = endController.text.trim();

                          String? validationMessage;
                          if (title.isEmpty) {
                            validationMessage = 'Judul tugas wajib diisi';
                          } else if (requireCategory &&
                              selectedCategory == null) {
                            validationMessage = 'Kategori tugas wajib dipilih';
                          } else if (requireTime &&
                              (start.isEmpty || end.isEmpty)) {
                            validationMessage =
                                'Jam mulai dan selesai wajib diisi';
                          } else if ((start.isEmpty) != (end.isEmpty)) {
                            validationMessage =
                                'Isi kedua jam atau kosongkan keduanya';
                          } else if (start.isNotEmpty &&
                              end.isNotEmpty &&
                              start.compareTo(end) > 0) {
                            validationMessage =
                                'Jam selesai tidak boleh sebelum jam mulai';
                          } else if (requireDescription &&
                              description.isEmpty) {
                            validationMessage = 'Deskripsi tugas wajib diisi';
                          }

                          if (validationMessage != null) {
                            await AppModalBottom.showDefault(
                              ctx,
                              emptyState: EmptyState.somethingWrong,
                              contentTitle: ('Informasi').tr(ctx),
                              contentSubtitle: validationMessage,
                              hasActionPop: true,
                              yesOkLabel: ('Tutup').tr(ctx),
                            );
                            return;
                          }
                          bool saved;
                          if (isEditing) {
                            saved = await cubit.updateLogbook(
                              id: entry.id,
                              judulTugas: title,
                              deskripsi: description,
                              kategoriTugas: selectedCategory,
                              jamMulai: start.isEmpty ? null : start,
                              jamSelesai: end.isEmpty ? null : end,
                            );
                          } else {
                            saved = await cubit.addLogbook(
                              judulTugas: title,
                              deskripsi: description,
                              kategoriTugas: selectedCategory,
                              jamMulai: start.isEmpty ? null : start,
                              jamSelesai: end.isEmpty ? null : end,
                            );
                          }
                          if (ctx.mounted && saved) Navigator.pop(ctx);
                        },
                        icon: Icon(
                          isEditing
                              ? PhosphorIcons.floppyDisk
                              : PhosphorIcons.plus,
                          size: 20,
                        ),
                        label: HrText(
                          isEditing ? 'Simpan Perubahan' : 'Simpan Logbook',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogbookCubit, LogbookState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: HrText(state.successMessage!),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.errorMessage != null) {
          AppModalBottom.showDefault(
            context,
            emptyState: EmptyState.somethingWrong,
            contentTitle: ('Informasi').tr(context),
            contentSubtitle: state.errorMessage!,
            hasActionPop: true,
            yesOkLabel: ('Tutup').tr(context),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<LogbookCubit>();
        final canViewEmployeeHistory = context.select<AppCubit, bool>(
          (appCubit) =>
              appCubit.state.user.data?.hasPermission(
                'logbook',
                action: 'view_report',
              ) ??
              false,
        );
        if (state.showingAllEmployees && !canViewEmployeeHistory) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted && cubit.state.showingAllEmployees) {
              cubit.setShowingAllEmployees(false);
            }
          });
        }

        return PopScope(
          canPop: !state.showingAllEmployees,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && state.showingAllEmployees) {
              cubit.setShowingAllEmployees(false);
            }
          },
          child: Scaffold(
            appBar: AppTopBar(
              title: (state.showingAllEmployees
                  ? ('Riwayat Logbook').tr(context)
                  : ('Logbook Harian').tr(context)),
              backgroundColor: AppColors.transparent,
              onBackTap: state.showingAllEmployees
                  ? () => cubit.setShowingAllEmployees(false)
                  : null,
              actions: null,
            ),
            floatingActionButton: state.showingAllEmployees
                ? null
                : FloatingActionButton(
                    onPressed: () => _showAddLogbookSheet(context),
                    backgroundColor: AppColors.primary,
                    child: Icon(PhosphorIcons.plus, color: Colors.white),
                  ),
            body: Column(
              children: [
                // Date Picker Bar
                _buildDateSelector(context, state, cubit),

                if (canViewEmployeeHistory && !state.showingAllEmployees)
                  _buildHistoryButton(context, cubit),

                // Content
                Expanded(
                  child: state.isLoading
                      ? _buildLoadingSkeleton(context)
                      : (state.showingAllEmployees
                            ? state.userSummaries.isEmpty
                            : state.logbooks.isEmpty)
                      ? _buildEmptyState(context, state.showingAllEmployees)
                      : _buildTimelineList(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryButton(BuildContext context, LogbookCubit cubit) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.w12,
        0,
        AppDimens.w12,
        AppDimens.h10,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => cubit.setShowingAllEmployees(true),
          icon: Icon(PhosphorIcons.usersThree, size: 19),
          label: const HrText('Buka Riwayat Logbook Karyawan'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.05),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
            padding: EdgeInsets.symmetric(vertical: AppDimens.h12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.r16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    LogbookState state,
    LogbookCubit cubit,
  ) {
    final dateStr = DateFormat(
      'EEEE, dd MMM yyyy',
      'id',
    ).format(state.selectedDate);
    final isToday =
        DateFormat('yyyy-MM-dd').format(state.selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Container(
      margin: EdgeInsets.all(AppDimens.w12),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w8,
        vertical: AppDimens.h8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              cubit.onDateChanged(
                state.selectedDate.subtract(const Duration(days: 1)),
              );
            },
            icon: Icon(
              PhosphorIcons.caretLeft,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  locale: Localizations.localeOf(context),
                );
                if (picked != null) {
                  cubit.onDateChanged(picked);
                }
              },
              child: Column(
                children: [
                  Text(
                    dateStr,
                    style: context.textStyle.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: HrText(
                        'Hari Ini',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final tomorrow = state.selectedDate.add(const Duration(days: 1));
              if (tomorrow.isBefore(
                DateTime.now().add(const Duration(days: 1)),
              )) {
                cubit.onDateChanged(tomorrow);
              }
            },
            icon: Icon(
              PhosphorIcons.caretRight,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppDimens.h12),
          padding: EdgeInsets.all(AppDimens.w16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.r12),
          ),
          child: Row(
            children: [
              Container(width: 60, height: 40, color: Colors.grey.shade200),
              SizedBox(width: AppDimens.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 14,
                      color: Colors.grey.shade200,
                    ),
                    SizedBox(height: AppDimens.h8),
                    Container(
                      width: 120,
                      height: 10,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool showingAllEmployees) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.notebook,
            size: AppDimens.w56,
            color: AppColors.labelSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppDimens.h12),
          HrText(
            showingAllEmployees
                ? 'Belum ada logbook karyawan'
                : 'Belum ada logbook hari ini',
            style: context.textStyle.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimens.h4),
          HrText(
            showingAllEmployees
                ? 'Tidak ada data pada tanggal ini'
                : 'Ketuk + untuk mencatat aktivitas',
            style: context.textStyle.bodySmall?.copyWith(
              color: AppColors.labelSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context, LogbookState state) {
    final logbooks = state.logbooks.toList()
      ..sort((a, b) => (a.jamMulai ?? '').compareTo(b.jamMulai ?? ''));

    // Summary
    final totalMinutes = state.showingAllEmployees
        ? state.userSummaries.fold<int>(
            0,
            (sum, summary) => sum + summary.totalDurasiMenit,
          )
        : logbooks.fold<int>(0, (sum, e) => sum + (e.durasiMenit ?? 0));
    final totalActivities = state.showingAllEmployees
        ? state.userSummaries.fold<int>(
            0,
            (sum, summary) => sum + summary.totalTask,
          )
        : logbooks.length;

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppDimens.w12,
        AppDimens.h4,
        AppDimens.w12,
        AppDimens.h10,
      ),
      padding: EdgeInsets.only(top: AppDimens.h12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEFF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppDimens.w16),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.h10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primary.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimens.r12),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.timer, size: 18, color: AppColors.primary),
                SizedBox(width: AppDimens.w8),
                HrText(
                  'Total: ${_formatDuration(totalMinutes)}',
                  style: context.textStyle.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                HrText(
                  '$totalActivities aktivitas',
                  style: context.textStyle.bodySmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppDimens.h8),

          Expanded(
            child: state.showingAllEmployees
                ? _buildGroupedHistoryList(context, state)
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        final cubit = context.read<LogbookCubit>();
                        if (!cubit.hasReachedMax && !cubit.isLoadingNext) {
                          cubit.fetchNextPage();
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                      itemCount:
                          logbooks.length +
                          (context.read<LogbookCubit>().isLoadingNext ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == logbooks.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final entry = logbooks[index];
                        final isLast =
                            index == logbooks.length - 1 &&
                            !context.read<LogbookCubit>().isLoadingNext;
                        return _buildTimelineItem(
                          context,
                          entry,
                          isLast,
                          state,
                          number: index + 1,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedHistoryList(BuildContext context, LogbookState state) {
    final summaries = state.userSummaries.toList()
      ..sort(
        (a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()),
      );
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppDimens.w12,
        0,
        AppDimens.w12,
        AppDimens.h12,
      ),
      itemCount: summaries.length,
      itemBuilder: (context, index) =>
          _buildEmployeeSummaryCard(context, summaries[index], state),
    );
  }

  Widget _buildEmployeeSummaryCard(
    BuildContext context,
    LogbookUserSummary summary,
    LogbookState state,
  ) {
    final name = summary.userName;
    final initial = name.isEmpty ? 'K' : name.substring(0, 1).toUpperCase();
    final isExpanded = state.expandedUserId == summary.userId;
    final isLoading = state.loadingUserIds.contains(summary.userId);
    final error = state.userLoadErrors[summary.userId];
    final entries = (state.userLogbooks[summary.userId] ?? []).toList()
      ..sort((a, b) => (a.jamMulai ?? '').compareTo(b.jamMulai ?? ''));

    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.h10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.25)
              : const Color(0xFFEDF0F3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                context.read<LogbookCubit>().toggleUserLogbooks(summary.userId),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.14),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyle.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.labelPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        HrText(
                          '${summary.totalTask} task · ${_formatDuration(summary.totalDurasiMenit)}',
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      PhosphorIcons.caretDown,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFEDF0F3)),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(child: HrText(error)),
                    TextButton(
                      onPressed: () => context
                          .read<LogbookCubit>()
                          .fetchUserLogbooks(summary.userId),
                      child: const HrText('Coba Lagi'),
                    ),
                  ],
                ),
              )
            else if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: HrText('Tidak ada task pada filter ini.'),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 2),
                child: Column(
                  children: [
                    for (var index = 0; index < entries.length; index++)
                      _buildTimelineItem(
                        context,
                        entries[index],
                        index == entries.length - 1,
                        state,
                        number: index + 1,
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    LogbookEntry entry,
    bool isLast,
    LogbookState state, {
    required int number,
  }) {
    final color = _categoryColor(entry.kategoriTugas);
    final cubit = context.read<LogbookCubit>();
    final canManage = !state.showingAllEmployees;
    final showActions = canManage && _actionEntryId == entry.id;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade200),
                  ),
              ],
            ),
          ),

          SizedBox(width: AppDimens.w8),

          // Card content
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: state.showingAllEmployees
                  ? () => _showLogbookDetailSheet(context, entry, number)
                  : null,
              child: Container(
                margin: EdgeInsets.only(bottom: AppDimens.h10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              entry.judulTugas,
                              style: context.textStyle.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.labelPrimary,
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (canManage) ...[
                            const SizedBox(width: 3),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: IconButton(
                                tooltip: (showActions
                                    ? ('Tutup aksi').tr(context)
                                    : ('Tampilkan aksi').tr(context)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                onPressed: () => setState(() {
                                  _actionEntryId = showActions
                                      ? null
                                      : entry.id;
                                }),
                                icon: Icon(
                                  PhosphorIcons.dotsThreeVertical,
                                  size: 19,
                                  color: AppColors.labelSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildCardMeta(
                            icon: PhosphorIcons.clock,
                            label:
                                '${entry.jamMulai ?? '--:--'}–${entry.jamSelesai ?? '--:--'}',
                          ),
                          _buildCardMeta(
                            icon: PhosphorIcons.timer,
                            label: _formatDuration(entry.durasiMenit),
                          ),
                          _buildCardMeta(
                            icon: PhosphorIcons.tag,
                            label:
                                (entry.kategoriTugas ??
                                ('Lainnya').tr(context)),
                            color: color,
                          ),
                        ],
                      ),
                      if (entry.deskripsi != null &&
                          entry.deskripsi!.isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(
                          entry.deskripsi!,
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
                            fontSize: 11,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (showActions) ...[
                        const SizedBox(height: 9),
                        Divider(height: 1, color: Colors.grey.shade100),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildActionButton(
                              icon: PhosphorIcons.pencilSimple,
                              label: ('Edit').tr(context),
                              color: AppColors.primary,
                              onTap: () =>
                                  _showAddLogbookSheet(context, entry: entry),
                            ),
                            SizedBox(width: AppDimens.w8),
                            _buildActionButton(
                              icon: PhosphorIcons.trash,
                              label: ('Hapus').tr(context),
                              color: AppColors.danger,
                              onTap: () =>
                                  _confirmDelete(context, cubit, entry),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogbookDetailSheet(
    BuildContext context,
    LogbookEntry entry,
    int number,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.judulTugas,
                            style: sheetContext.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.labelPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          HrText(
                            entry.userName ?? 'Karyawan',
                            style: sheetContext.textStyle.bodySmall?.copyWith(
                              color: AppColors.labelSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        sheetContext,
                        icon: PhosphorIcons.clock,
                        label: ('Waktu').tr(context),
                        value:
                            '${entry.jamMulai ?? '--:--'} – ${entry.jamSelesai ?? '--:--'}',
                      ),
                      _buildDetailRow(
                        sheetContext,
                        icon: PhosphorIcons.timer,
                        label: ('Durasi').tr(context),
                        value: _formatDuration(entry.durasiMenit),
                      ),
                      _buildDetailRow(
                        sheetContext,
                        icon: PhosphorIcons.tag,
                        label: ('Kategori').tr(context),
                        value: entry.kategoriTugas ?? 'Lainnya',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                if (entry.deskripsi?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 18),
                  HrText(
                    'Deskripsi Task',
                    style: sheetContext.textStyle.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.deskripsi!.trim(),
                    style: sheetContext.textStyle.bodyMedium?.copyWith(
                      color: AppColors.labelSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.primary),
          const SizedBox(width: 9),
          SizedBox(
            width: 70,
            child: HrText(
              label,
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardMeta({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final foreground = color ?? AppColors.labelSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: foreground),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: HrText(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            HrText(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    LogbookCubit cubit,
    LogbookEntry entry,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const HrText('Hapus Logbook?'),
        content: const HrText('Data yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const HrText('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.deleteLogbookEntry(entry.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const HrText('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
