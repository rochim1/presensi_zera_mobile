import 'package:flutter/material.dart';

/// Please wrap on top [Scaffold] Widget
class UnfocuserForm extends StatelessWidget {
  final Widget child;

  const UnfocuserForm({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
