import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';

const _menuIconFiles = <String, String>{
  'Presensi': 'attendance',
  'Cuti': 'leave',
  'Lembur': 'overtime',
  'Gaji': 'payroll',
  'Request\nPresensi': 'attendance_request',
  'Shift': 'shift',
  'Reimbursement': 'reimbursement',
  'Kalender Kerja': 'calendar',
  'Kegiatan &\nKehadiran': 'activity',
  'KPI': 'kpi',
  'Pengumuman': 'announcement',
  'Performa Sales': 'sales',
  'Piutang': 'receivables',
  'Katalog': 'catalog',
  'Kasbon\n(Loan)': 'loan',
  'Outlet': 'outlet',
  'Taking Order': 'order',
  'Incidental\nReport': 'incident',
  'Survey Saya': 'survey',
  'Logbook': 'logbook',
  'Van Stock': 'van_stock',
};

class HomeFeatureGrid extends StatefulWidget {
  const HomeFeatureGrid({super.key});

  @override
  State<HomeFeatureGrid> createState() => _HomeFeatureGridState();
}

class _HomeFeatureGridState extends State<HomeFeatureGrid> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;

    final features = [
      _Feature(
        icon: PhosphorIcons.calendarCheck,
        label: 'Presensi',
        onTap: () => context.router.navigate(const AttendancePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.suitcase,
        label: 'Cuti',
        onTap: () => context.router.push(LeavePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clock,
        label: 'Lembur',
        onTap: () => context.router.push(OvertimePageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.wallet,
        label: 'Gaji',
        onTap: () => context.router.push(PayrollPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clipboardText,
        label: 'Request\nPresensi',
        onTap: () => context.router.push(AttendanceRequestPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clockCountdown,
        label: 'Shift',
        onTap: () => context.router.push(ShiftPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.receipt,
        label: 'Reimbursement',
        onTap: () => context.router.push(ReimbursementPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.calendarDots,
        label: 'Kalender Kerja',
        onTap: () => context.router.push(const KalenderPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.usersThree,
        label: 'Kegiatan &\nKehadiran',
        onTap: () => context.router.push(const ActivityPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.target,
        label: 'KPI',
        onTap: () => context.router.push(const KpiPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.megaphone,
        label: 'Pengumuman',
        onTap: () => context.router.push(const AnnouncementPageRoute()),
        hasBadge: true,
      ),
      _Feature(
        icon: PhosphorIcons.chartBar,
        label: 'Performa Sales',
        onTap: () => context.router.push(const SalesDashboardPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.money,
        label: 'Piutang',
        onTap: () => context.router.push(const PiutangPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.package,
        label: 'Katalog',
        onTap: () => context.router.push(const ProductCatalogPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.money,
        label: 'Kasbon\n(Loan)',
        onTap: () => context.router.push(const LoanPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.storefront,
        label: 'Outlet',
        onTap: () => context.router.push(const ApotekPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.shoppingCart,
        label: 'Taking Order',
        onTap: () => context.router.push(TakingOrderPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.warningCircle,
        label: 'Incidental\nReport',
        onTap: () => context.router.push(const IncidentalReportPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.clipboard,
        label: 'Survey Saya',
        onTap: () => context.router.push(const SurveyPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.notebook,
        label: 'Logbook',
        onTap: () => context.router.push(const LogbookPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.truck,
        label: 'Van Stock',
        onTap: () => context.router.push(const VanStockPageRoute()),
      ),
    ];

    final itemsPerPage = isDesktop ? 12 : 8;
    final pages = <List<_Feature>>[
      for (var start = 0; start < features.length; start += itemsPerPage)
        features.sublist(
          start,
          (start + itemsPerPage).clamp(0, features.length),
        ),
    ];

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isDesktop ? 320 : 208,
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
                itemCount: pages.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, pageIndex) {
                  final pageFeatures = pages[pageIndex];
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 96,
                        ),
                    itemCount: pageFeatures.length,
                    itemBuilder: (context, index) {
                      final feature = pageFeatures[index];
                      return _buildFeatureItem(
                        context: context,
                        icon: feature.icon,
                        label: feature.label,
                        onTap: feature.onTap,
                        hasBadge: feature.hasBadge,
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
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String label,
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/menu/${_menuIconFiles[label]}.png',
                    width: 52,
                    height: 52,
                    cacheWidth: 156,
                    cacheHeight: 156,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) =>
                        Icon(icon, color: AppColors.primary, size: 26),
                  ),
                ),
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
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.labelPrimary,
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
  final VoidCallback onTap;
  final bool hasBadge;

  const _Feature({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasBadge = false,
  });
}
