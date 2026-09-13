import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class HomeFeatureGrid extends StatefulWidget {
  final bool isLoading;
  const HomeFeatureGrid({super.key, this.isLoading = false});

  @override
  State<HomeFeatureGrid> createState() => _HomeFeatureGridState();
}

class _HomeFeatureGridState extends State<HomeFeatureGrid>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _lastPageCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appState = context.read<AppCubit>().state;
    final user = appState.user.data;
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;

    final features = [
      _Feature(
        icon: PhosphorIcons.calendarCheckFill,
        label: 'Presensi',
        color: const Color(0xFF10B981),
        bgColor: const Color(0xFF10B981),
        onTap: () => context.router.navigate(const AttendancePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.suitcaseFill,
        label: 'Cuti',
        color: AppColors.warning,
        bgColor: AppColors.warningBackground,
        onTap: () => context.router.push(const LeavePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clockFill,
        label: 'Lembur',
        color: const Color(0xFF14B8A6),
        bgColor: const Color(0xFF14B8A6),
        onTap: () => context.router.push(const OvertimePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.fingerprintFill,
        label: 'Gaji',
        color: const Color(0xFFF43F5E),
        bgColor: const Color(0xFFF43F5E),
        onTap: () => context.router.push(const PayrollPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clipboardTextFill,
        label: 'Request\nPresensi',
        color: const Color(0xFF10B981),
        bgColor: const Color(0xFF10B981),
        onTap: () => context.router.push(const AttendanceRequestPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clockCountdownFill,
        label: 'Shift',
        color: AppColors.warning,
        bgColor: AppColors.warningBackground,
        onTap: () => context.router.push(const ShiftPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.receiptFill,
        label: 'Reimbursement',
        color: const Color(0xFF14B8A6),
        bgColor: const Color(0xFF14B8A6),
        onTap: () => context.router.push(const ReimbursementPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.calendarDotsFill,
        label: 'Kalender Kerja',
        color: const Color(0xFFEAB308),
        bgColor: const Color(0xFFEAB308),
        onTap: () => context.router.push(const KalenderPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.usersThreeFill,
        label: 'Kegiatan &\nKehadiran',
        color: AppColors.primary,
        bgColor: AppColors.primaryLight,
        onTap: () => context.router.push(const ActivityPageRoute()),
      ),
      if (user?.hasPermission('kpi', action: 'view') ?? false)
        _Feature(
          icon: PhosphorIcons.targetFill,
          label: 'KPI',
          color: const Color(0xFF6366F1),
          bgColor: const Color(0xFF6366F1),
          onTap: () => context.router.push(const KpiPageRoute()),
        ),
      _Feature(
        icon: PhosphorIcons.megaphoneFill,
        label: 'Pengumuman',
        color: AppColors.danger,
        bgColor: AppColors.dangerBackground,
        onTap: () => context.router.push(const AnnouncementPageRoute()),
        hasBadge: true,
      ),
      _Feature(
        icon: PhosphorIcons.chartBarFill,
        label: 'Performa Sales',
        color: AppColors.info,
        bgColor: AppColors.infoBackground,
        onTap: () => context.router.push(const SalesDashboardPageRoute()),
      ),
      if (user?.hasPermission('sales_order', action: 'view') ?? false)
        _Feature(
          icon: PhosphorIcons.moneyFill,
          label: 'Piutang',
          color: const Color(0xFFEAB308),
          bgColor: const Color(0xFFEAB308),
          onTap: () => context.router.push(const PiutangPageRoute()),
        ),
      _Feature(
        icon: PhosphorIcons.packageFill,
        label: 'Katalog',
        color: const Color(0xFF8B5CF6),
        bgColor: const Color(0xFF8B5CF6),
        onTap: () => context.router.push(const ProductCatalogPageRoute()),
      ),
      if (user?.hasPermission('loan', action: 'view') ?? false)
        _Feature(
          icon: PhosphorIcons.moneyFill,
          label: 'Kasbon\n(Loan)',
          color: const Color(0xFF0EA5E9), // Light blue color for Loan
          bgColor: const Color(0xFF0EA5E9),
          onTap: () => context.router.push(const LoanPageRoute()),
        ),
      _Feature(
        icon: PhosphorIcons.storefrontFill,
        label: 'Outlet',
        color: const Color(0xFFF43F5E),
        bgColor: const Color(0xFFF43F5E),
        onTap: () => context.router.push(const ApotekPageRoute()),
      ),
      if (user?.hasPermission('sales_order', action: 'create') ?? false)
        _Feature(
          icon: PhosphorIcons.shoppingCartFill,
          label: 'Taking Order',
          color: const Color(0xFF06B6D4),
          bgColor: const Color(0xFF06B6D4),
          onTap: () => context.router.push(TakingOrderPageRoute()),
        ),
      _Feature(
        icon: PhosphorIcons.warningCircleFill,
        label: 'Incidental\nReport',
        color: AppColors.danger,
        bgColor: AppColors.dangerBackground,
        onTap: () => context.router.push(const IncidentalReportPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clipboardFill,
        label: 'Survey Saya',
        color: const Color(0xFF64748B),
        bgColor: const Color(0xFF64748B),
        onTap: () => context.router.push(const SurveyPageRoute()),
      ),
      if (user?.hasPermission('logbook', action: 'view') ?? false)
        _Feature(
          icon: PhosphorIcons.notebookFill,
          label: 'Logbook',
          color: const Color(0xFF475569),
          bgColor: const Color(0xFF475569),
          onTap: () => context.router.push(const LogbookPageRoute()),
        ),
      if (user?.hasPermission('sales_van_stock', action: 'view') ?? false)
        _Feature(
          icon: PhosphorIcons.truckFill,
          label: 'Van Stock',
          color: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFF8B5CF6),
          onTap: () => context.router.push(const VanStockPageRoute()),
        ),
    ];

    // Desktop uses three rows so the card follows its content without leaving
    // a large empty area. Mobile stays compact with two rows.
    final itemsPerPage = isDesktop ? 12 : 8;
    final pages = <List<_Feature>>[];
    for (var i = 0; i < features.length; i += itemsPerPage) {
      pages.add(
        features.sublist(
          i,
          i + itemsPerPage > features.length
              ? features.length
              : i + itemsPerPage,
        ),
      );
    }

    final safePage = pages.isEmpty
        ? 0
        : _currentPage.clamp(0, pages.length - 1);
    if (_lastPageCount != pages.length || safePage != _currentPage) {
      _lastPageCount = pages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_currentPage != safePage) {
          setState(() => _currentPage = safePage);
        }
        if (_pageController.hasClients &&
            _pageController.page?.round() != safePage) {
          _pageController.jumpToPage(safePage);
        }
      });
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: isDesktop ? 344 : 226,
        child: widget.isLoading
            ? GridView.builder(
                key: const ValueKey('home-feature-loading'),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 96,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemsPerPage,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppShimmer.circle(size: 52),
                      const SizedBox(height: 8),
                      AppShimmer.box(width: 44, height: 10),
                      const SizedBox(height: 4),
                      AppShimmer.box(width: 32, height: 10),
                    ],
                  );
                },
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: isDesktop ? 320 : 210,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: const {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                          PointerDeviceKind.stylus,
                        },
                      ),
                      child: PageView.builder(
                        key: const PageStorageKey('home-feature-pages'),
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        allowImplicitScrolling: true,
                        onPageChanged: (index) {
                          if (pages.isEmpty) return;
                          final nextPage = index.clamp(0, pages.length - 1);
                          if (_currentPage == nextPage) return;
                          setState(() {
                            _currentPage = nextPage;
                          });
                        },
                        itemCount: pages.length,
                        itemBuilder: (context, pageIndex) {
                          // Permission user dapat mengubah jumlah halaman
                          // ketika PageView masih menyelesaikan frame lama.
                          // Jangan pernah mengakses indeks dari snapshot lama.
                          if (pageIndex < 0 || pageIndex >= pages.length) {
                            return const SizedBox.shrink();
                          }
                          final pageItems = pages[pageIndex];
                          return GridView.builder(
                            key: ValueKey('home-feature-page-$pageIndex'),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 96,
                                ),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pageItems.length,
                            itemBuilder: (context, index) {
                              final f = pageItems[index];
                              return _buildFeatureItem(
                                context: context,
                                icon: f.icon,
                                label: f.label,
                                color: f.color,
                                bgColor: f.bgColor,
                                onTap: f.onTap,
                                hasBadge: f.hasBadge,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF0F8B6D)
                              : const Color(0xFF0F8B6D).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(child: Icon(icon, color: Colors.white, size: 24)),
              ),
              if (hasBadge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E1E1E),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final bool hasBadge;

  const _Feature({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
    this.hasBadge = false,
  });
}
