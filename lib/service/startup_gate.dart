import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:presensi_mobile/service/startup_metrics.dart';

/// Render a responsive first frame before loading storage and native services.
/// The application only receives control once its dependencies are ready.
/// Keep this first tree independent of Material themes, routes and animations:
/// the actual app creates those once its dependencies have been initialized.
class StartupGate extends StatefulWidget {
  const StartupGate({super.key, required this.initialize, this.firstFrame});
  final Future<Widget> Function() initialize;
  // Tests have no engine rasterizer; production waits for the engine signal.
  final Future<void>? firstFrame;

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  Widget? _app;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    StartupMetrics.mark('loading_tree_created');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // endOfFrame only waits for the framework pipeline. Native startup must
      // wait until the engine has actually rasterized our loading screen.
      await (widget.firstFrame ??
          (kIsWeb
              ? Future<void>.value()
              : WidgetsBinding.instance.waitUntilFirstFrameRasterized));
      if (!mounted) return;
      StartupMetrics.mark('loading_rasterized');
      try {
        final app = await widget.initialize();
        if (mounted) setState(() => _app = app);
      } catch (error, stack) {
        debugPrint('Startup initialization failed: $error\n$stack');
        if (mounted) setState(() => _failed = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      _app ??
      MediaQuery.fromView(
        view: View.of(context),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ColoredBox(
            color: const Color(0xFFF7FAFA),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _failed
                        ? 'Zera belum dapat dibuka. Tutup lalu buka kembali aplikasi. Data tersimpan tidak dihapus.'
                        : 'Menyiapkan Zera…',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF173D3A),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
