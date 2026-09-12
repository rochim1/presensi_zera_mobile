import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class DeliveryDetailPage extends StatefulWidget {
  final TasksEntity? tasks;

  const DeliveryDetailPage({super.key, required this.tasks});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  late Completer<GoogleMapController> mapController = Completer();
  late TextEditingController noteController;

  void onMapCreate(BuildContext ctxMap, GoogleMapController ctrl) {
    final lat = double.parse(
      widget.tasks?.aktivitas?.destination?.latitude ?? kDefaultLat,
    );
    final long = double.parse(
      widget.tasks?.aktivitas?.destination?.longitude ?? kDefaultLong,
    );

    mapController.complete(ctrl);

    mapController.future.then((value) {
      value.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 15),
        ),
      );
      Throttle.throttle(kThrMap, kDurationMapLoad, () {
        ctxMap.read<GlobalMapCubit>().updateTarget(LatLng(lat, long));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.tasks?.aktivitas?.note);
  }

  @override
  void dispose() {
    super.dispose();
    Debounce.cancel(kThrMap);
    mapController = Completer();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalMapCubit>()..getPermissionStatus(),
        ),
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
      ],
      child: BlocConsumer<GlobalMapCubit, GlobalMapState>(
        listener: (context, mapState) {
          if (mapState.typeState.isLoaded) {
            if (mapState.isLocationGranted) {
              log.i(mapState.address!.toString());
            }
          }
          if (mapState.typeState.isNotLoaded) {
            Fluttertoast.showToast(msg: mapState.message!);
            if (!mapState.isLocationGranted) {
              context.router.pop();
            }
          }
        },
        builder: (ctxMap, mapState) {
          return Scaffold(
            appBar: const AppTopBar(title: 'Detail Kunjungan'),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    child: MapViewWidget(
                      initialCameraPosition: CameraPosition(
                        target: mapState.targetPosition!,
                      ),
                      onMapCreated: (controller) =>
                          onMapCreate(ctxMap, controller),
                      position: mapState.targetPosition!,
                    ),
                  ),
                  AppDimens.size3M.hSpace,
                  BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                    builder: (_, usrState) {
                      final task = widget.tasks;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DeliveryCardWidget(
                            title: 'Kunjungan',
                            titleTime:
                                widget
                                        .tasks
                                        ?.aktivitas
                                        ?.statusTask
                                        ?.toStatusTask
                                        ?.isDone ??
                                    false
                                ? 'Waktu kunjungan'
                                : 'Waktu dibatalkan',
                            dateNow: widget
                                .tasks
                                ?.taskDateDone
                                ?.toDateTime
                                ?.toEEEdMMMy,
                            timeNow: widget
                                .tasks
                                ?.aktivitas
                                ?.completedTime
                                ?.toDateTime
                                ?.toHHmmss,
                            isLoading: mapState.typeState.isLoading,
                            addreass: mapState.address?.toString(),
                          ),

                          if (task != null) ...[
                            AppDimens.size3M.hSpace,
                            if (task.aktivitas?.isCompletedByOther ??
                                false) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  AppDimens.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusMedium,
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFFDBA74),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.supervisor_account_outlined,
                                      color: Color(0xFFC2410C),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Kunjungan ini dikerjakan oleh ${task.aktivitas?.completedByName ?? 'admin lain'}.',
                                        style: const TextStyle(
                                          color: Color(0xFF9A3412),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppDimens.size3M.hSpace,
                            ],
                            DeliveryTaskItemCard(task: task),

                            if (task.aktivitas?.noReferensi?.isNotEmpty ??
                                false) ...[
                              AppDimens.size3M.hSpace,
                              Text(
                                'No Referensi / Faktur / DO',
                                style: context.textStyle.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AppDimens.size1X.hSpace,
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: task.aktivitas!.noReferensi!
                                    .map(
                                      (ref) => Chip(
                                        label: Text(
                                          ref,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],

                            if ((task.aktivitas?.orderValue ?? 0) > 0) ...[
                              AppDimens.size3M.hSpace,
                              Text(
                                'Nominal Transaksi/Penagihan',
                                style: context.textStyle.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AppDimens.size1X.hSpace,
                              Text(
                                'Rp ${task.aktivitas!.orderValue!.toInt().textDecimalDigit}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ],

                          AppDimens.size3M.hSpace,
                          Text(
                            'Bukti Kunjungan',
                            style: context.textStyle.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (widget.tasks?.aktivitas?.fotoPlakat?.isNotEmpty ??
                              false) ...[
                            AppDimens.size3M.hSpace,
                            TextFieldImageView(
                              title: usrState.isMarketing
                                  ? 'Foto Plakat Lokasi'
                                  : 'Foto Bukti',
                              fileName: widget
                                  .tasks
                                  ?.aktivitas
                                  ?.fotoPlakat
                                  ?.first
                                  .filename,
                              base64String: widget
                                  .tasks
                                  ?.aktivitas
                                  ?.fotoPlakat
                                  ?.first
                                  .base64,
                            ),
                            if ((widget.tasks?.aktivitas?.fotoPlakat?.length ??
                                    0) ==
                                2) ...[
                              AppDimens.sizeM.hSpace,
                              TextFieldImageView(
                                fileName: widget
                                    .tasks
                                    ?.aktivitas
                                    ?.fotoPlakat
                                    ?.last
                                    .filename,
                                base64String: widget
                                    .tasks
                                    ?.aktivitas
                                    ?.fotoPlakat
                                    ?.last
                                    .base64,
                              ),
                            ],
                          ],
                          if (widget.tasks?.aktivitas?.fotoBukti?.isNotEmpty ??
                              false) ...[
                            AppDimens.size3M.hSpace,
                            TextFieldImageView(
                              title: usrState.isMarketing
                                  ? 'Foto Pendukung / Nota'
                                  : 'Foto Stample',
                              fileName: widget
                                  .tasks
                                  ?.aktivitas
                                  ?.fotoBukti
                                  ?.first
                                  .filename,
                              base64String: widget
                                  .tasks
                                  ?.aktivitas
                                  ?.fotoBukti
                                  ?.first
                                  .base64,
                            ),
                            if ((widget.tasks?.aktivitas?.fotoBukti?.length ??
                                    0) ==
                                2) ...[
                              AppDimens.sizeM.hSpace,
                              TextFieldImageView(
                                fileName: widget
                                    .tasks
                                    ?.aktivitas
                                    ?.fotoBukti
                                    ?.last
                                    .filename,
                                base64String: widget
                                    .tasks
                                    ?.aktivitas
                                    ?.fotoBukti
                                    ?.last
                                    .base64,
                              ),
                            ],
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
