import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'app_input_label.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.items = const [],
    this.asyncItems,
    this.selectedItem,
    this.onChanged,
    this.itemAsString,
    this.isRequired = false,
    this.showSearchBox = false,
    required this.compareFn,
    this.filterFn,
    this.dropdownBuilder,
    this.itemBuilder,
    this.enabled = true,
  });

  final String? label;
  final String? hintText;
  final String? errorText;
  final List<T> items;
  final DropdownSearchOnFind<T>? asyncItems;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemAsString;
  final bool isRequired;
  final bool showSearchBox;
  final bool Function(T, T) compareFn;
  final bool Function(T, String)? filterFn;
  final DropdownSearchBuilder<T>? dropdownBuilder;
  final DropdownSearchPopupItemBuilder<T>? itemBuilder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppInputLabel(label: label!, isRequired: isRequired),
          SizedBox(height: AppDimens.h4),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.shade100,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownSearch<T>(
            enabled: enabled,
            items: asyncItems ?? (f, s) => items,
            selectedItem: selectedItem,
            onChanged: onChanged,
            compareFn: compareFn,
            filterFn: filterFn,
            itemAsString: itemAsString,
            dropdownBuilder: dropdownBuilder,
            decoratorProps: DropDownDecoratorProps(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                errorText: errorText,
                hintText: hintText,
                hintStyle: context.textStyle.bodyMedium?.copyWith(
                  color: AppColors.labelSecondary.withValues(alpha: 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMediumX,
                  vertical: AppDimens.paddingMediumX,
                ),
                filled: true,
                fillColor: enabled ? AppColors.white : AppColors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: BorderSide(
                    color: AppColors.grey.shade200,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: const BorderSide(
                    color: AppColors.danger,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  borderSide: const BorderSide(
                    color: AppColors.danger,
                    width: 2,
                  ),
                ),
              ),
            ),
            popupProps: PopupProps.modalBottomSheet(
              showSearchBox: showSearchBox,
              fit: FlexFit.loose,
              showSelectedItems: true,
              searchDelay: const Duration(milliseconds: 800),
              loadingBuilder: (context, searchProps) => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimens.paddingLarge,
                  ),
                  child: CircularProgressIndicator(),
                ),
              ),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              modalBottomSheetProps: ModalBottomSheetProps(
                backgroundColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimens.radiusLarge),
                  ),
                ),
              ),
              itemBuilder:
                  itemBuilder ??
                  (context, item, isDisabled, isSelected) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMediumX,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.06)
                                  : AppColors.white,
                            ),
                            child: ListTile(
                              selected: isSelected,
                              title: Text(
                                itemAsString?.call(item) ?? item.toString(),
                                style: context.textStyle.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.labelPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      color: AppColors.grey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.4)
                                : AppColors.dividerLight,
                          ),
                        ],
                      ),
                    );
                  },
              title: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingMediumX,
                  AppDimens.paddingMediumX,
                  AppDimens.paddingMediumX,
                  0,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: AppDimens.paddingMediumX),
                    Text(
                      'Pilih ${label ?? "Opsi"}',
                      style: context.textStyle.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.paddingMediumX),
                    const Divider(height: 1, color: AppColors.dividerLight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
