import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldDropdown<T> extends StatelessWidget {
  final String title;
  final String? hint;
  final Key? dropdownKey;
  final List<T> items;
  final T? selectedItem;
  final Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final bool Function(T selected, T? val)? compareFn;
  final Color? colorTitle;
  final bool? disable;
  final String? Function(T?)? validator;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final DropdownSuffixProps? dropdownButtonProps;
  final bool required;

  const TextFieldDropdown({
    super.key,
    required this.title,
    this.hint,
    this.dropdownKey,
    required this.items,
    this.selectedItem,
    required this.itemAsString,
    this.onChanged,
    this.colorTitle,
    this.compareFn,
    this.disable = false,
    this.validator,
    this.itemBuilder,
    this.dropdownButtonProps,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.size2S),
          child: RichText(
            text: TextSpan(
              text: title,
              style: AppTextStyle.fieldLabel.copyWith(
                color: colorTitle ?? AppColors.labelPrimary,
              ),
              children: [
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyle.fieldLabel.copyWith(
                      color: AppColors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
        AppDimens.size3S.hSpace,
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: IgnorePointer(
            ignoring: disable!,
            child: DropdownSearch<T>(
              key: dropdownKey,
              compareFn: compareFn,
              popupProps: PopupProps.menu(
                showSearchBox: false,
                fit: FlexFit.loose,
                itemBuilder: itemBuilder,
                menuProps: MenuProps(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
              ),
              items: (filter, loadProps) => items,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(hintText: hint),
              ),
              itemAsString: itemAsString,
              onChanged: onChanged,
              selectedItem: selectedItem,
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}
