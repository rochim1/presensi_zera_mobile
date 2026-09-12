import 'package:flutter/material.dart';

import 'package:presensi_mobile/core/_core.dart';

class TextFieldSwitchButton extends StatelessWidget {
  final String? title;
  final String label;
  final Function(bool value) onChanged;
  final bool? initialValue;

  const TextFieldSwitchButton({
    super.key,
    this.title,
    required this.label,
    required this.onChanged,
    this.initialValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, textAlign: TextAlign.left),
        if (title != null) const SizedBox(height: AppDimens.size3S),
        SwitchListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(label),
          value: initialValue!,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
