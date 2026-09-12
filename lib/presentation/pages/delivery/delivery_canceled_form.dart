import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

@RoutePage()
class DeliveryCanceledForm extends StatefulWidget {
  final TasksEntity? tasks;

  const DeliveryCanceledForm({super.key, required this.tasks});

  @override
  State<DeliveryCanceledForm> createState() => _DeliveryCanceledFormState();
}

class _DeliveryCanceledFormState extends State<DeliveryCanceledForm> {
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController alasanController = TextEditingController();
  late JenisPembatalan? jenisPembatalan = JenisPembatalan.other;
  PlatformFile? pathAttachment;

  @override
  void dispose() {
    super.dispose();
    Throttle.cancelAll();
    Debounce.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<TasksPostCanceledCubit>()),
      ],
      child: UnfocuserForm(
        child: Scaffold(
          appBar: const AppTopBar(title: 'Batalkan Kunjungan'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: Column(
              children: [
                    BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                      builder: (_, usrState) {
                        final task = widget.tasks;
                        return Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: Stream.periodic(
                                  const Duration(seconds: 1),
                                  (i) => i,
                                ),
                                builder: (context, snapshot) {
                                  return DeliveryCardWidget(
                                    title: 'Pembatalan Kunjungan',
                                    titleTime: 'Waktu dibatalkan',
                                    dateNow: DateTime.now().toEEEdMMMy,
                                    timeNow: DateTime.now().toHHmmss,
                                    isLoading: false,
                                    addreass: null,
                                  );
                                },
                              ),
                              if (task != null) ...[
                                AppDimens.size3M.hSpace,
                                DeliveryTaskItemCard(task: task),
                              ],
                              AppDimens.size4M.hSpace,
                              Container(
                                padding: const EdgeInsets.all(AppDimens.paddingMedium),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  border: Border.all(color: Colors.orange.shade200),
                                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange.shade800, size: 20),
                                    const SizedBox(width: AppDimens.paddingSmall),
                                    Expanded(
                                      child: Text(
                                        'Jika membatalkan kunjungan, maka BBM / Reimburse transport tidak akan dihitung.',
                                        style: context.textStyle.bodySmall?.copyWith(
                                          color: Colors.orange.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppDimens.size4M.hSpace,
                              Text(
                                'Detail Pembatalan',
                                style: context.textStyle.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AppDimens.size3M.hSpace,
                              TextFieldRadio(
                                title: 'Jenis Pembatalan',
                                colorTitle: AppColors.labelSecondary,
                                initialValue: jenisPembatalan?.index,
                                isRequired: true,
                                contentValue: const [
                                  'Salah memilih Kunjungan',
                                  'Lainnya',
                                ],
                                leftFlex: true,
                                onChanged: (value) {
                                  if (value == 0) {
                                    jenisPembatalan =
                                        JenisPembatalan.wrongSelected;
                                    alasanController = TextEditingController(
                                      text: 'Salah memilih Kunjungan',
                                    );
                                  } else if (value == 1) {
                                    jenisPembatalan = JenisPembatalan.other;
                                    alasanController = TextEditingController(
                                      text: '',
                                    );
                                  }
                                  setState(() {});
                                },
                              ),
                              AppDimens.size3M.hSpace,
                              TextFieldAttachment(
                                title: 'File Pendukung',
                                hint: 'Upload File Optional',
                                initFile: pathAttachment,
                                colorTitle: AppColors.labelSecondary,
                                onUpload: (List<PlatformFile>? files) {
                                  if (files!.isEmpty) {
                                    pathAttachment = null;
                                  } else {
                                    pathAttachment = files.first;
                                  }
                                },
                              ),
                              if (jenisPembatalan?.isOther ?? false) ...[
                                AppDimens.size3M.hSpace,
                                TextFieldBasic(
                                  controller: alasanController,
                                  title: 'Alasan',
                                  colorTitle: AppColors.labelSecondary,
                                  hint: 'Masukan Alasan Pembatalan',
                                  required: true,
                                  multiline: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return kEmptyValidator.rich(['Alasan']);
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildConfirmButton() {
    return BlocConsumer<TasksPostCanceledCubit, TasksPostCanceledState>(
      listener: (context, state) async {
        if (state.status.isLoaded) {
          await AppModalBottom.showDefault(
            context,
            contentTitle: 'Pembatalan Kunjungan Berhasil',
            contentSubtitle:
                'Anda baru saja membatalkan kunjungan untuk ${widget.tasks?.aktivitas?.apotikId?.namaApotik ?? ''}',
            hasActionPop: true,
          );

          if (!context.mounted) return;
          context.router.pop<bool>(true);
        } else if (state.status.isNotLoaded) {
          await AppModalBottom.handleError(context, state.failure);
        }
      },
      builder: (context, state) {
        return AppButton(
          onPressed: () {
            if (state.status.isLoading) return;

            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              final params = TasksCanceledParamsEntity(
                statusTask: StatusTask.cancel.toKey,
                canceledTime: DateTime.now().toIso8601String(),
                isLembur: context.read<AppCubit>().state.isOvertimeActive,
                alasan: alasanController.text,
                jenisPembatalan: jenisPembatalan?.toKey,
                taskId: widget.tasks?.id,
                aktivitasId: widget.tasks?.aktivitas?.id,
                lokasi: const LocationEntity(
                  longitude: '0',
                  latitude: '0',
                ),
                fotoPendukung: GlobalImageParamsEntity(
                  file: AppUtility.toMultipartFile(pathAttachment?.path),
                  path: pathAttachment?.path,
                  name: pathAttachment?.name,
                ),
              );

              Debounce.debounce(kDebForm, kDurSubmit, () async {
                context.read<TasksPostCanceledCubit>().postCanceled(params);
              });
            }
          },
          isLoading: state.status.isLoading,
          text: 'Konfirmasi',
        );
      },
    );
  }
}
