import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class ListComponentWidget extends StatelessWidget {
  final String label;
  final String? value;
  final Color? textColor;
  final bool hasBackground;
  final Color? background;
  final double letterSpacing;
  final bool multiLine;
  final bool isLoaded;
  final double fontSize;
  final bool isShowTooltip;
  final bool? boldLabel;
  final void Function()? onTap;

  const ListComponentWidget({
    super.key,
    required this.label,
    required this.value,
    this.textColor,
    this.hasBackground = false,
    this.background,
    this.letterSpacing = 1.0,
    this.multiLine = false,
    this.isLoaded = true,
    this.fontSize = 14,
    this.isShowTooltip = false,
    this.boldLabel = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !hasBackground
            ? Text(
                label,
                style: TextStyle(
                  color: boldLabel!
                      ? AppColors.labelPrimary
                      : AppColors.grey.shade700,
                  fontWeight: boldLabel! ? FontWeight.w500 : null,
                  fontSize: boldLabel! ? 14 : 13,
                ),
              )
            : Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
        const SizedBox(width: AppDimens.paddingLargeX),
        !hasBackground
            ? isLoaded
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        decoration: hasBackground
                            ? BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(20),
                              )
                            : null,
                        padding: hasBackground
                            ? const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              )
                            : null,
                        child: isShowTooltip
                            ? Tooltip(
                                message: value ?? '',
                                child: Text(
                                  value?.isEmptyStrip ?? '-',
                                  maxLines: (multiLine) ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: hasBackground
                                        ? Colors.white
                                        : textColor,
                                    fontSize: hasBackground ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: hasBackground
                                        ? letterSpacing
                                        : 0,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: onTap,
                                child: Text(
                                  value?.isEmptyStrip ?? '-',
                                  maxLines: (multiLine) ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: onTap == null
                                        ? hasBackground
                                              ? Colors.white
                                              : textColor
                                        : AppColors.blue,
                                    fontSize: hasBackground ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: hasBackground
                                        ? letterSpacing
                                        : 0,
                                  ),
                                ),
                              ),
                      ),
                    )
                  : const Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SpinIndicatorText(),
                      ),
                    )
            : isLoaded
            ? Container(
                alignment: Alignment.centerRight,
                decoration: hasBackground
                    ? BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                padding: hasBackground
                    ? const EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                    : null,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value?.isEmptyStrip ?? '-',
                    maxLines: (multiLine) ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: onTap == null
                          ? hasBackground
                                ? Colors.white
                                : textColor
                          : AppColors.blue,
                      fontSize: hasBackground ? 12 : fontSize,
                      fontWeight: FontWeight.w500,
                      letterSpacing: hasBackground ? letterSpacing : 0,
                    ),
                  ),
                ),
              )
            : const SpinIndicatorText(),
      ],
    );
  }
}
