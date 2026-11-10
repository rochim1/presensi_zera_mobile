import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/widgets.dart';

/// A shared surface while startup or the first authenticated route is pending.
class PantooLaunchScreen extends StatelessWidget {
  const PantooLaunchScreen({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFF7FAFA),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Image.asset(
          'assets/images/brand_logo.png',
          width: 160,
          height: 200,
          fit: BoxFit.contain,
          semanticLabel: ('Pantoo HR').tr(context),
        ),
      ),
    ),
  );
}
