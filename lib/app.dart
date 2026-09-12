import 'package:auto_route/auto_route.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

bool _isHandlingUnauthorized = false;
bool _isHandlingConnectionError = false;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;
  late final AutoRouterDelegate _routerDelegate;
  late final RouteInformationParser<Object> _routeInformationParser;
  late final RouteInformationProvider _routeInformationProvider;
  late final ThemeData _lightTheme;

  @override
  void initState() {
    super.initState();
    _lightTheme = AppTheme.light();
    _appRouter = AppRouter(
      auth: sl<AppGuard>(),
      navigatorKey: ChuckerFlutter.navigatorKey,
    );
    _routerDelegate = AutoRouterDelegate(
      _appRouter,
      navigatorObservers: () => [
        FlutterSmartDialog.observer,
        FirebaseAnalyticsObserver(analytics: fa),
      ],
    );
    _routeInformationParser = _appRouter.defaultRouteParser();
    _routeInformationProvider = _appRouter.routeInfoProvider();

    sl<FlavorConfig>().onUnauthorized = () async {
      if (_isHandlingUnauthorized) return;
      _isHandlingUnauthorized = true;

      // Logout and disconnect websocket
      await sl<LoginSignOutCubit>().logout();
      // Navigate to login page
      _appRouter.pushAndPopUntil(LoginPageRoute(), predicate: (_) => false);

      _isHandlingUnauthorized = false;
    };

    sl<FlavorConfig>().onConnectionError = (message) async {
      if (FlavorConfig.isProduction()) return;
      if (_isHandlingConnectionError) return;
      _isHandlingConnectionError = true;
      SmartDialog.show(
        clickMaskDismiss: true,
        builder: (ctx) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 56,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Koneksi Gagal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            SmartDialog.dismiss();
                            await sl<LoginSignOutCubit>().logout();
                            _appRouter.pushAndPopUntil(
                              LoginPageRoute(),
                              predicate: (_) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => SmartDialog.dismiss(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
      // Delay to avoid spamming the modal if multiple requests fail at the same time
      await Future.delayed(const Duration(seconds: 2));
      _isHandlingConnectionError = false;
    };
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    final isTablet = logicalSize.shortestSide >= 600;
    final isLandscape = logicalSize.width > logicalSize.height;

    // Most legacy cards use ScreenUtil's .w/.h/.r dimensions. Scaling those
    // values from a phone-sized design canvas makes every card, padding,
    // avatar, and icon oversized on tablets (especially in landscape). Use
    // the actual canvas there so these dimensions behave like the fixed sizes
    // used by the newer Leave page.
    final adaptiveDesignSize = isTablet || isLandscape
        ? logicalSize
        : const Size(411, 731);

    return ScreenUtilInit(
      designSize: adaptiveDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: _routeInformationParser,
        routeInformationProvider: _routeInformationProvider,
        routerDelegate: _routerDelegate,
        theme: _lightTheme,
        title: sl<FlavorConfig>().values!.appName!,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id'), Locale('en')],
        builder: FlutterSmartDialog.init(
          loadingBuilder: (String value) => const LoadingIndicatorWidget(),
          builder: (_, child) => ResponsiveBreakpoints.builder(
            child: BlocProvider(
              create: (_) => sl<AppCubit>()..init(),
              // Android 15/16 draws the app edge-to-edge. Keep every route's
              // footer above the system navigation area, including legacy
              // forms whose bottomNavigationBar does not wrap itself in a
              // SafeArea. Descendant SafeAreas consume the same inset, so it
              // does not create double bottom padding.
              child: SafeArea(
                top: false,
                maintainBottomViewPadding: true,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
        ),
      ),
    );
  }
}
