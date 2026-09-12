import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/app_button.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final bool isDismissible;
  final bool enableDrag;
  final EdgeInsetsGeometry? padding;
  final WidgetBuilder? actionsBuilder;
  final VoidCallback? onClose;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.isDismissible = true,
    this.enableDrag = true,
    this.padding,
    this.actionsBuilder,
    this.onClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Widget? title,
    List<Widget>? actions,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    EdgeInsetsGeometry? padding,
    WidgetBuilder? actionsBuilder,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      barrierColor: AppColors.modalBarrier,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width >= 600
                ? 480
                : double.infinity,
          ),
          child: AppBottomSheet(
            title: title,
            actions: actions,
            actionsBuilder: actionsBuilder,
            isDismissible: isDismissible,
            enableDrag: enableDrag,
            padding: padding,
            onClose: onClose,
            child: child,
          ),
        ),
      ),
    ).whenComplete(() {
      if (onClose != null) onClose();
    });
  }

  static Future<void> showSuccess({
    required BuildContext context,
    String? message,
    String? titleText,
    String? buttonText,
    VoidCallback? onConfirm,
  }) {
    return show<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/common/successfully.svg',
            width: AppDimens.w160,
            height: AppDimens.h160,
          ),
          SizedBox(height: AppDimens.h24),
          Text(
            titleText ?? 'Berhasil!',
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.labelPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimens.h12),
          Text(
            message ?? 'Permintaan Anda telah berhasil diproses.',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButtonNew(
          text: buttonText ?? 'Tutup',
          variant: AppButtonNewVariant.tertiary,
          style: AppButtonNewStyle.ghost,
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm();
          },
        ),
      ],
    );
  }

  static Future<void> showError({
    required BuildContext context,
    String? message,
    String? titleText,
    String? buttonText,
    VoidCallback? onConfirm,
  }) {
    return show<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/common/something_wrong.svg',
            width: AppDimens.w160,
            height: AppDimens.h160,
          ),
          SizedBox(height: AppDimens.h24),
          Text(
            titleText ?? 'Ups!',
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.labelPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimens.h12),
          Text(
            message ?? 'Terjadi kesalahan saat memproses permintaan Anda.',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButtonNew(
          text: buttonText ?? 'Tutup',
          variant: AppButtonNewVariant.danger,
          style: AppButtonNewStyle.ghost,
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return IntrinsicHeight(
      child: Container(
        padding: padding != null
            ? padding!.add(EdgeInsets.only(bottom: bottomInset + viewInsets))
            : EdgeInsets.fromLTRB(
                AppDimens.w16,
                AppDimens.h16,
                AppDimens.w16,
                AppDimens.h16 + bottomInset + viewInsets,
              ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.r24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle for drag
            if (enableDrag) ...[
              Center(
                child: Container(
                  width: AppDimens.w40,
                  height: AppDimens.h4,
                  decoration: BoxDecoration(
                    color: AppColors.labelSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimens.r2),
                  ),
                ),
              ),
              SizedBox(height: AppDimens.h16),
            ],

            // Title section
            if (title != null) ...[
              Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelPrimary,
                      ),
                      child: title!,
                    ),
                  ),
                  if (isDismissible)
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColors.labelSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
              SizedBox(height: AppDimens.h16),
            ],

            // Content
            Flexible(child: child),

            // Actions section
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: AppDimens.h20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: AppDimens.w12,
                children: actions!.map((e) => Expanded(child: e)).toList(),
              ),
            ] else if (actionsBuilder != null) ...[
              SizedBox(height: AppDimens.h20),
              actionsBuilder!(context),
            ],
          ],
        ),
      ),
    );
  }
}
