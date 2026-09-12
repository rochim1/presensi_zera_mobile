import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class TextFieldDropdownSearch<T> extends StatelessWidget {
  final Key? dropdownKey;
  final String? title;
  final List<T> items;
  final String? hintSearch;
  final String Function(T)? itemAsString;
  final Function(T?)? onChanged;
  final bool Function(T selected, T? val)? compareFn;
  final T? selectedItem;
  final String? hint;
  final bool Function(T?)? itemDisabledFn;
  final String? Function(T?)? validator;
  final Color? colorTitle;
  final Function()? onAdd;
  final String? addTooltip;
  final bool required;
  final Future<List<T>> Function(String)? asyncItems;

  const TextFieldDropdownSearch({
    super.key,
    this.dropdownKey,
    this.title,
    required this.items,
    this.hintSearch = 'Cari sesuatu...',
    this.itemAsString,
    this.onChanged,
    this.compareFn,
    this.selectedItem,
    this.hint,
    this.itemDisabledFn,
    this.validator,
    this.colorTitle,
    this.onAdd,
    this.addTooltip = 'Tambah baru',
    this.required = false,
    this.asyncItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.size2S),
            child: RichText(
              text: TextSpan(
                text: title!,
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
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownSearch<T>(
                key: dropdownKey,
                items: asyncItems != null
                    ? (filter, loadProps) => asyncItems!(filter)
                    : (filter, loadProps) => items,
                compareFn: (item, selectedItem) =>
                    compareFn!(item!, selectedItem),
                itemAsString: (item) => itemAsString!(item!),
                onChanged: onChanged,
                selectedItem: selectedItem,
                validator: validator,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  disabledItemFn: itemDisabledFn,
                  fit: FlexFit.loose,
                  menuProps: MenuProps(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                  // dropdown_search renders its default ListTile inside a
                  // decorated menu surface. Flutter 3.29+ asserts because
                  // the tile's ink splash would be painted behind it. Supply
                  // a Material surface for each item instead.
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return Material(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: .06)
                          : AppColors.white,
                      child: ListTile(
                        enabled: !isDisabled,
                        selected: isSelected,
                        title: Text(
                          itemAsString?.call(item) ?? item.toString(),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                    );
                  },
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxHeight: AppDimens.size2XL,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 0.0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      hintText: hintSearch,
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: AppColors.labelSecondary,
                    ),
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: const TextStyle(fontSize: AppDimens.size3M),
                  decoration: InputDecoration(hintText: hint),
                ),
              ),
            ),
            if (onAdd != null) ...[
              AppDimens.size3M.wSpace,
              ButtonAddCustom(tooltip: addTooltip, onTap: onAdd!),
            ],
          ],
        ),
      ],
    );
  }
}
