import 'package:presensi_mobile/l10n/language_picker.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../core/_core.dart';
import '../../../core/routers/auth_navigation.dart';
import '../../../injections.dart';
import '../../_presentation.dart';
import '../../widgets/intro/_intro.dart';

@RoutePage()
class IntroPage extends StatefulWidget {
  final OnLoginResultCallback? onLoginResult;
  const IntroPage({super.key, this.onLoginResult});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String description,
    required List<Widget> features,
    required int pageIndex,
  }) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 32 : 0,
          16,
          isTablet ? 32 : 0,
          24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  AppDimens.paddingLarge,
                ), // Reduced padding
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.labelPrimary.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo (moved inside card)
                    SizedBox(
                      height:
                          110, // Increased size for the logo inside the card
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: BrandWidget(),
                      ),
                    ),
                    const SizedBox(height: AppDimens.size2L),

                    // App Name / Title
                    HrText(
                      title,
                      style: context.textStyle.titleLarge?.copyWith(
                        // Smaller than headlineMedium
                        color: AppColors.labelPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: AppDimens.sizeS,
                    ), // Reduced from sizeM
                    // Simple description
                    HrText(
                      description,
                      style: context.textStyle.bodyMedium?.copyWith(
                        // Smaller than bodyLarge
                        color: AppColors.labelSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: AppDimens.size2L,
                    ), // Reduced from size4L
                    // Features list
                    ...features,

                    const SizedBox(
                      height: AppDimens.size2L,
                    ), // Reduced from size4L
                    // Start / Next button
                    AppButton(
                      onPressed: () {
                        if (pageIndex < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          openPantooLogin(context.router);
                        }
                      },
                      text: (pageIndex < 2
                          ? ('Selanjutnya').tr(context)
                          : ('Mulai Sekarang').tr(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GlobalInAppUpgradeCubit>()..checkForUpdate(),
      child: BlocListener<GlobalInAppUpgradeCubit, GlobalInAppUpgradeState>(
        listener: (_, state) async {
          if (state.status.isLoaded) {
            Fluttertoast.showToast(msg: (state.message!).trCurrent());
          } else if (state.status.isNotLoaded) {
            final answer = await AppModalBottom.handleError(
              context,
              state.failure,
            );
            if (state.result == AppUpdateResult.userDeniedUpdate ||
                state.result == AppUpdateResult.inAppUpdateFailed) {
              if (answer?.isYesOk ?? false) SystemNavigator.pop();
            }
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldPop = await AppModalBottom.handleWillPop(context);
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                // Background image
                Image.asset(
                  AppImages.geometricBg, // Changed to geometric background
                  fit: BoxFit.cover,
                  height: context.height,
                  width: context.width,
                ),
                // Gradient overlay for better readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.7),
                        AppColors.secondary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                // Content
                SafeArea(
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: LanguagePicker(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            // Slide 1
                            _buildCard(
                              context: context,
                              pageIndex: 0,
                              title: ('Presensi Mobile').tr(context),
                              description:
                                  ('Solusi absensi modern untuk perusahaan Anda')
                                      .tr(context),
                              features: [
                                FeatureItem(
                                  icon: Icons.access_time_rounded,
                                  title: ('Absensi Real-time').tr(context),
                                  subtitle:
                                      ('Catat kehadiran dengan GPS akurat').tr(
                                        context,
                                      ),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.analytics_rounded,
                                  title: ('Laporan Lengkap').tr(context),
                                  subtitle: ('Monitor produktivitas tim').tr(
                                    context,
                                  ),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.touch_app_rounded,
                                  title: ('Mudah Digunakan').tr(context),
                                  subtitle: ('Interface yang user-friendly').tr(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            // Slide 2: Requested by user (Presensi, HRMS, Sales, Delivery)
                            _buildCard(
                              context: context,
                              pageIndex: 1,
                              title: ('HRMS & Sales Terpadu').tr(context),
                              description:
                                  ('Sistem lengkap dengan berbagai fitur andalan.')
                                      .tr(context),
                              features: [
                                FeatureItem(
                                  icon: Icons.shopping_cart_checkout_rounded,
                                  title: ('Taking Order').tr(context),
                                  subtitle:
                                      ('Fitur manajemen order untuk tim sales')
                                          .tr(context),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.local_shipping_rounded,
                                  title: ('Checkpoint Pengantaran').tr(context),
                                  subtitle:
                                      ('Pantau rute dan pengantaran real-time')
                                          .tr(context),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.people_alt_rounded,
                                  title: ('Manajemen Presensi').tr(context),
                                  subtitle:
                                      ('Cuti, izin, dan shift dalam satu aplikasi')
                                          .tr(context),
                                ),
                              ],
                            ),
                            // Slide 3
                            _buildCard(
                              context: context,
                              pageIndex: 2,
                              title: ('Mulai Lebih Cepat').tr(context),
                              description:
                                  ('Tingkatkan produktivitas tim Anda sekarang juga.')
                                      .tr(context),
                              features: [
                                FeatureItem(
                                  icon: Icons.speed_rounded,
                                  title: ('Kinerja Cepat').tr(context),
                                  subtitle:
                                      ('Akses data di mana saja tanpa hambatan')
                                          .tr(context),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.security_rounded,
                                  title: ('Data Aman').tr(context),
                                  subtitle: ('Privasi dan keamanan terjamin')
                                      .tr(context),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.rocket_launch_rounded,
                                  title: ('Siap Digunakan').tr(context),
                                  subtitle:
                                      ('Login sekarang dan rasakan kemudahannya')
                                          .tr(context),
                                ),
                                SizedBox(height: AppDimens.sizeM),
                                FeatureItem(
                                  icon: Icons.location_on_outlined,
                                  title: ('Live Tracking Transparan').tr(
                                    context,
                                  ),
                                  subtitle:
                                      ('Lokasi hanya digunakan saat sesi kerja aktif dan setelah persetujuan Anda')
                                          .tr(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Page Indicators
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.paddingLargeX,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppColors.white
                                    : AppColors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
