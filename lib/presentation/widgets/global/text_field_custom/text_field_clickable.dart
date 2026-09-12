import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldClickable extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final Function() onTap;

  const TextFieldClickable({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, textAlign: TextAlign.left),
        if (title.isNotEmpty) const SizedBox(height: AppDimens.size3S),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.grey.shade100,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.grey, width: 1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              ),
              labelStyle: const TextStyle(color: AppColors.grey),
              floatingLabelStyle: const TextStyle(color: AppColors.grey),
              hintStyle: const TextStyle(color: AppColors.grey),
              hintText: hint,
              contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
            ),
            enabled: false,
          ),
        ),
      ],
    );
  }
}
