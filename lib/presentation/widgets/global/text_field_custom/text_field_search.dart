import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldSearch extends StatelessWidget {
  final void Function(String value)? onChanged;

  final String hint;

  const TextFieldSearch({super.key, this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey.shade100, width: 1),
          borderRadius: BorderRadius.circular(AppDimens.sizeXL),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(AppDimens.sizeXL),
        ),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.size2S,
        ),
        isDense: true,
      ),
    );
  }
}
