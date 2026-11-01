import 'package:flutter/material.dart';
import 'package:presensi_mobile/presentation/widgets/pantoo_launch_screen.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/service/startup_metrics.dart';

/// An unloaded attendance lookup must not look like an absent attendance.
class SessionRestoreGate extends StatefulWidget {
  const SessionRestoreGate({
    super.key,
    required this.state,
    required this.onRetry,
    required this.child,
  });

  final AppState state;
  final VoidCallback onRetry;
  final Widget child;

  @override
  State<SessionRestoreGate> createState() => _SessionRestoreGateState();
}

class _SessionRestoreGateState extends State<SessionRestoreGate> {
  String? _userId;
  bool _mountedHome = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    if (state.user.isInitial) {
      _userId = null;
      _mountedHome = false;
    } else if (state.user.isSuccess && state.user.data?.id != _userId) {
      _userId = state.user.data?.id;
      _mountedHome = false;
    }
    final attendance = state.activeAttendance;
    final failed =
        state.user.isError ||
        state.sessionRestore.isError ||
        (attendance.isError && attendance.failure is! NotFoundFailure);
    final waiting =
        state.user.isInitial ||
        state.user.isLoading ||
        attendance.isInitial ||
        attendance.isLoading ||
        state.sessionRestore.isInitial ||
        state.sessionRestore.isLoading;
    final ready = !waiting && !failed;
    if (ready && !_mountedHome) {
      _mountedHome = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) StartupMetrics.homeReady();
      });
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        // Preserve Home cubits/requests during refresh; an account change gets a
        // new subtree so another employee can never inherit their local state.
        if (_mountedHome)
          Offstage(
            offstage: !ready,
            child: KeyedSubtree(key: ValueKey(_userId), child: widget.child),
          ),
        if (!ready)
          if (!failed)
            const PantooLaunchScreen()
          else
            Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Data akun atau presensi belum dapat dimuat. Periksa koneksi lalu coba lagi.',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: widget.onRetry,
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
