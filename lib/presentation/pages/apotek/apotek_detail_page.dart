import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../widgets/apotek/apotek_detail_tabs.dart';

@RoutePage()
class ApotekDetailPage extends StatefulWidget {
  final ApotekEntity? apotek;

  const ApotekDetailPage({super.key, required this.apotek});

  @override
  State<ApotekDetailPage> createState() => _ApotekDetailPageState();
}

class _ApotekDetailPageState extends State<ApotekDetailPage> with SingleTickerProviderStateMixin {
  late Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? _mapCtrl;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void onMapCreate(BuildContext context, GoogleMapController ctrl) {
    final lat = double.parse(widget.apotek?.latitude ?? kDefaultLat);
    final long = double.parse(widget.apotek?.longitude ?? kDefaultLong);

    mapController.complete(ctrl);
    _mapCtrl = ctrl;

    mapController.future.then((value) {
      value.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 15),
        ),
      );
      Throttle.throttle(kThrMap, kDurationMapLoad, () {
        context.read<GlobalMapCubit>().updateTarget(LatLng(lat, long));
      });
    });
  }

  @override
  void dispose() {
    _mapCtrl?.dispose();
    _tabController.dispose();
    super.dispose();
    mapController = Completer();
    Debounce.cancel(kThrMap);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.apotek == null) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Detail Outlet'),
        body: const Center(child: Text('Data Outlet tidak ditemukan')),
      );
    }

    final apotek = widget.apotek!;

    return BlocProvider(
      create: (context) => sl<GlobalMapCubit>()..getPermissionStatus(),
      child: BlocConsumer<GlobalMapCubit, GlobalMapState>(
        listener: (context, state) {
          if (state.typeState.isNotLoaded) {
            Fluttertoast.showToast(msg: state.message!);
            if (!state.isLocationGranted) {
              context.router.pop();
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgSecondary,
            appBar: AppTopBar(
              title: 'Detail Outlet',
              backgroundColor: AppColors.white,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.fromLTRB(
                        AppDimens.paddingMediumX,
                        AppDimens.paddingSmall,
                        AppDimens.paddingMediumX,
                        AppDimens.paddingMediumX,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.storefrontFill,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: AppDimens.w16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apotek.namaApotik ?? 'Outlet Tanpa Nama',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.labelPrimary,
                                  ),
                                ),
                                SizedBox(height: AppDimens.h4),
                                Row(
                                  children: [
                                    AppChip(
                                      label: apotek.tipeOutlet ?? 'Umum',
                                      color: AppColors.blue,
                                      borderRadius: AppDimens.r8,
                                    ),
                                    SizedBox(width: AppDimens.w8),
                                    AppChip(
                                      label: 'Aktif',
                                      color: AppColors.green,
                                      borderRadius: AppDimens.r8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      child: Container(
                        color: AppColors.white,
                        child: AppTabBar(
                          isScrollable: true,
                          currentIndex: _tabController.index,
                          tabs: const [
                            'Identitas',
                            'Lokasi',
                            'Piutang',
                            'Hutang',
                            'Barang MSL',
                            'Riwayat Order',
                            'Statistik',
                          ],
                          onTap: (index) {
                            _tabController.animateTo(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  ApotekDetailIdentitasTab(apotek: apotek),
                  ApotekDetailLokasiTab(
                    apotek: apotek,
                    position: state.targetPosition ?? LatLng(double.parse(kDefaultLat), double.parse(kDefaultLong)),
                    address: state.address?.toApotekAddress() ?? '',
                    isLoading: state.typeState.isLoading,
                    onMapCreated: (controller) => onMapCreate(context, controller),
                  ),
                  const ApotekDetailEmptyTab(title: 'Piutang'),
                  const ApotekDetailEmptyTab(title: 'Hutang'),
                  const ApotekDetailEmptyTab(title: 'Barang MSL'),
                  const ApotekDetailEmptyTab(title: 'Riwayat Order'),
                  ApotekDetailStatistikTab(apotek: apotek),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  static const double _height = 48.0;

  const _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) => true;
}
