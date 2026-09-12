import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ItemCardConsignment extends StatelessWidget {
  final TasksEntity? tasks;

  const ItemCardConsignment({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
      child: Container(
        color: AppColors.bgSecondary,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.lightBlue,
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DestinationItem(
                    isRight: false,
                    name: tasks?.aktivitas?.from?.name,
                    time: tasks?.aktivitas?.startTime?.toDateTime?.toHHmm,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMediumX,
                      ),
                      // width: AppDimens.widthIcon,
                      height: AppDimens.size4L,
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: _SeparatorWidget(),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: _DotWidget(isRight: false),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: _DotWidget(isRight: true),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.size2S,
                                horizontal: AppDimens.size3S,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMediumX,
                                ),
                              ),
                              child: const Icon(
                                Icons.directions_bike_rounded,
                                size: AppDimens.size3M,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _DestinationItem(
                    isRight: true,
                    name: tasks?.aktivitas?.destination?.name,
                    time: tasks?.aktivitas?.completedTime?.toDateTime?.toHHmm,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Column(
                children: [
                  ListComponentWidget(
                    label: 'Kendaraan',
                    value: tasks
                        ?.inventaris
                        ?.jenisKendaraan
                        ?.toJenisKendaraan
                        ?.toName,
                  ),
                  const Divider(),
                  ListComponentWidget(
                    label: 'Status',
                    value: tasks?.aktivitas?.statusTask?.toStatusTask?.toName,
                    textColor:
                        tasks?.aktivitas?.statusTask?.toStatusTask?.toColor,
                  ),
                  const Divider(),
                  ListComponentWidget(
                    label: 'Waktu Realita',
                    value: tasks?.aktivitas?.estimasiWaktuTempuh?.toTimeSecond,
                  ),
                  const Divider(),
                  ListComponentWidget(
                    label: 'Waktu Estimasi',
                    value: tasks?.aktivitas?.estimasiWaktuGmaps?.toTimeSecond,
                  ),
                  const Divider(),
                  ListComponentWidget(
                    label: 'Jarak Estimasi',
                    value:
                        tasks?.aktivitas?.distanceFromAttendance?.toKilometer,
                  ),
                  const Divider(),
                  ListComponentWidget(
                    label: 'Biaya Estimasi',
                    value: tasks?.aktivitas?.estimasiBiayaPerTask?.toCurrency,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotWidget extends StatelessWidget {
  final bool isRight;

  const _DotWidget({required this.isRight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.size4S,
      height: AppDimens.size4S,
      decoration: BoxDecoration(
        color: isRight ? AppColors.lightBlue : AppColors.secondary,
        shape: BoxShape.circle,
        border: isRight
            ? Border.all(width: 2, color: AppColors.secondary)
            : null,
      ),
    );
  }
}

class _DestinationItem extends StatelessWidget {
  final String? time;
  final String? name;
  final bool isRight;

  const _DestinationItem({
    required this.isRight,
    required this.time,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.destination,
      child: Column(
        crossAxisAlignment: isRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            isRight ? 'Sampai' : 'Dari',
            textAlign: isRight ? TextAlign.right : TextAlign.left,
            style: context.textStyle.bodySmall!.copyWith(
              letterSpacing: 0.5,
              color: AppColors.labelSecondary,
            ),
          ),
          Text(
            time ?? '-',
            textAlign: isRight ? TextAlign.right : TextAlign.left,
            style: context.textStyle.titleLarge!.copyWith(
              color: AppColors.secondary,
            ),
          ),
          Text(
            name ?? '-',
            textAlign: isRight ? TextAlign.right : TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.bodyMedium!.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeparatorWidget extends StatelessWidget {
  const _SeparatorWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.secondary),
              ),
            );
          }),
        );
      },
    );
  }
}
