import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TextFieldTagsCustom extends StatelessWidget {
  final TextfieldTagsController<String>? controller;
  final String title;
  final String tooltip;
  final String hint;
  final List<String>? initialTags;
  final TextInputType? inputType;
  final Validator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const TextFieldTagsCustom({
    super.key,
    this.controller,
    required this.title,
    required this.hint,
    this.initialTags,
    this.validator,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.maxLength = 225,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) _TitleBuilder(title: title, tooltip: tooltip),
        if (title.isNotEmpty) AppDimens.size3S.hSpace,
        TextFieldTags<String>(
          textfieldTagsController:
              controller ?? TextfieldTagsController<String>(),
          initialTags: initialTags,
          textSeparators: const [',', '.', ' '],
          validator: validator,
          inputFieldBuilder: (context, dynamic values) {
            return TextFormField(
              controller: values.textEditingController,
              focusNode: values.focusNode,
              keyboardType: inputType,
              inputFormatters:
                  inputFormatters ??
                  [LengthLimitingTextInputFormatter(maxLength)],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey.shade100,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: values.tags.isNotEmpty ? 'Masukan lagi' : hint,
                errorText: values.error,
                helperText: 'Boleh di kosongkan',
                helperStyle: context.textStyle.bodySmall!.copyWith(
                  color: AppColors.blue,
                ),
                contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
                prefixIconConstraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1,
                ),
                prefixIcon: values.tags.isNotEmpty
                    ? _ChipBuilder(
                        onTagDelete: values.onTagDelete,
                        sc: values.scrollController,
                        tags: values.tags,
                      )
                    : null,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: values.onChanged,
              onFieldSubmitted: values.onSubmitted,
            );
          },
        ),
      ],
    );
  }
}

class _TitleBuilder extends StatelessWidget {
  const _TitleBuilder({required this.title, required this.tooltip});

  final String title;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    if (tooltip.isEmpty) return Text(title, textAlign: TextAlign.left);

    return Row(
      children: [
        Text(title, textAlign: TextAlign.left),
        AppDimens.size2S.wSpace,
        Tooltip(
          message: tooltip,
          preferBelow: true,
          verticalOffset: AppDimens.size2M,
          child: const Icon(
            Icons.help_outline_rounded,
            color: AppColors.secondary,
            size: AppDimens.size3M,
          ),
        ),
      ],
    );
  }
}

class _ChipBuilder extends StatelessWidget {
  final void Function(String) onTagDelete;
  final ScrollController sc;
  final List<String> tags;

  const _ChipBuilder({
    required this.onTagDelete,
    required this.sc,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: sc,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((String tag) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.radiusLargeX),
              ),
              color: AppColors.secondary,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(tag, style: const TextStyle(color: AppColors.white)),
                AppDimens.size2S.wSpace,
                InkWell(
                  child: Icon(
                    Icons.cancel,
                    size: AppDimens.size2M,
                    color: AppColors.grey.shade100,
                  ),
                  onTap: () {
                    onTagDelete(tag);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
