import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

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
      _Feature(
        icon: PhosphorIcons.notebookFill,
        label: 'Logbook',
        color: const Color(0xFF475569),
        bgColor: const Color(0xFF475569),
        onTap: () => context.router.push(const LogbookPageRoute()),
      ),
      _Feature(
        icon: PhosphorIcons.truckFill,
        label: 'Van Stock',
        color: const Color(0xFF8B5CF6),
        bgColor: const Color(0xFF8B5CF6),
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
                        color: feature.color,
                        bgColor: feature.bgColor,
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
