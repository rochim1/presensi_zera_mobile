import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppModalBottom {
  AppModalBottom._();

  static Widget _responsiveSheet(BuildContext context, Widget child) {
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width >= 600
              ? 480
              : double.infinity,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLargeX),
          ),
          child: child,
        ),
      ),
    );
  }

  static Future<AnswerState?> handleError(
    BuildContext context,
    Failure? failure, {
    List<String>? richText,
    bool? ignoreUnauthorized = false,
  }) async {
    final modal = await showConfirm(
      context,
      contentTitle: 'Informasi',
      contentSubtitle:
          '${sl<FlavorConfig>().env?.isDev ?? false ? '[${failure!.code}]\n' : ''}${failure!.message.rich(richText)}',
      isDismissible: !(failure.code.isUnauthorized),
      emptyState: EmptyState.somethingWrong,
      action: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.router.pop<AnswerState>(AnswerState.yesOk),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.fillTertiary,
              foregroundColor: AppColors.labelPrimary,
            ),
            child: const Text('Tutup'),
          ),
        ),
      ],
    );

    if (!ignoreUnauthorized!) {
      if (failure.code.isUnauthorized) {
        SmartDialog.showLoading();
        await sl<LoginSignOutCubit>().logout();
        SmartDialog.dismiss();
        if (!context.mounted) return modal;
        context.router.pushAndPopUntil(
          IntroPageRoute(),
          predicate: (r) => true,
        );
      }
    }

    return modal;
  }

  /// handle back button pressed to exit app or back to previous
  static Future<bool> handleWillPop(
    BuildContext context, {
    String? contentSubtitle,
    bool? isExitApp = true,
  }) async {
    final answer = await showConfirm(
      context,
      contentSubtitle: contentSubtitle ?? kMsgBackApp,
      yesOkLabel: 'Saya Yakin',
      isDismissible: true,
    );

    if (answer?.isYesOk ?? false) {
      if (isExitApp!) {
        SystemNavigator.pop();
      }
      return true;
    } else {
      return false;
    }
  }

  /// modal bottom default for notif information
  static Future<AnswerState?> showDefault(
    BuildContext context, {
    EmptyState emptyState = EmptyState.successfully,
    String? title,
    required String contentTitle,
    required String contentSubtitle,
    bool hasActionPop = false,
    String? yesOkLabel = 'Kembali',
    bool isDismissible = true,
    Color? buttonColor,
  }) async {
    Widget buildContent(BuildContext sheetContext) {
      return _ModalBottomView(
        title: title,
        emptyState: emptyState,
        contentTitle: contentTitle,
        contentSubtitle: contentSubtitle,
        action: [
          if (hasActionPop)
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    sheetContext.router.pop<AnswerState>(AnswerState.yesOk),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor ?? AppColors.fillTertiary,
                  foregroundColor: buttonColor != null
                      ? AppColors.white
                      : AppColors.labelPrimary,
                ),
                child: Text(yesOkLabel!),
              ),
            ),
        ],
      );
    }

    if (MediaQuery.sizeOf(context).width >= 600) {
      return showModalBottomSheet<AnswerState>(
        context: context,
        barrierColor: AppColors.modalBarrier,
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(maxWidth: 480),
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        builder: (sheetContext) => ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLargeX),
          ),
          child: buildContent(sheetContext),
        ),
      );
    }

    return showCupertinoModalBottomSheet<AnswerState>(
      context: context,
      barrierColor: AppColors.modalBarrier,
      topRadius: const Radius.circular(AppDimens.radiusLargeX),
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) {
        return _responsiveSheet(context, buildContent(context));
      },
    );
  }

  /// modal bottom confirmation
  static Future<AnswerState?> showConfirm(
    BuildContext context, {
    EmptyState emptyState = EmptyState.confirmation,
    String? title,
    String contentTitle = 'Konfirmasi',
    required String contentSubtitle,
    String cancelLabel = 'Batal',
    String yesOkLabel = 'Ya',
    ButtonStyle? cancelStyle,
    ButtonStyle? yesOkStyle,
    bool isDismissible = false,
    List<Widget>? action,
  }) async {
    Widget buildContent(BuildContext sheetContext) {
      return _ModalBottomView(
        title: title,
        emptyState: emptyState,
        action:
            action ??
            [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      sheetContext.router.pop<AnswerState>(AnswerState.cancel),
                  style:
                      cancelStyle ??
                      ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fillTertiary,
                        foregroundColor: AppColors.labelPrimary,
                      ),
                  child: Text(cancelLabel),
                ),
              ),
              const SizedBox(width: AppDimens.paddingMediumX),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      sheetContext.router.pop<AnswerState>(AnswerState.yesOk),
                  style:
                      yesOkStyle ??
                      ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                      ),
                  child: Text(yesOkLabel),
                ),
              ),
            ],
        contentTitle: contentTitle,
        contentSubtitle: contentSubtitle,
      );
    }

    if (MediaQuery.sizeOf(context).width >= 600) {
      return showModalBottomSheet<AnswerState>(
        context: context,
        barrierColor: AppColors.modalBarrier,
        backgroundColor: Colors.transparent,
        constraints: const BoxConstraints(maxWidth: 480),
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        builder: (sheetContext) => ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusLargeX),
          ),
          child: buildContent(sheetContext),
        ),
      );
    }

    return showCupertinoModalBottomSheet<AnswerState>(
      context: context,
      barrierColor: AppColors.modalBarrier,
      topRadius: const Radius.circular(AppDimens.radiusLargeX),
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) {
        return _responsiveSheet(context, buildContent(context));
      },
    );
  }

  /// modal bottom for detail item
  static Future<AnswerState?> showDetail(
    BuildContext context, {
    required String title,

    /// example you can use `ItemCardWidget`
    required Widget content,
    String cancelLabel = 'Batalkan',
    String yesOkLabel = 'Ubah',
    ButtonStyle? cancelStyle,
    ButtonStyle? yesOkStyle,
    bool isDismissible = true,
    bool? actionNull = false,
  }) async {
    return showCupertinoModalBottomSheet<AnswerState>(
      context: context,
      barrierColor: AppColors.modalBarrier,
      topRadius: const Radius.circular(AppDimens.radiusLargeX),
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) {
        return _responsiveSheet(
          context,
          _ModalBottomDetailView(
            title: title,
            content: content,
            action: actionNull ?? true
                ? null
                : [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            context.router.pop<AnswerState>(AnswerState.cancel),
                        style:
                            cancelStyle ??
                            ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightRed,
                              foregroundColor: AppColors.red,
                            ),
                        child: Text(cancelLabel),
                      ),
                    ),
                    const SizedBox(width: AppDimens.paddingMediumX),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            context.router.pop<AnswerState>(AnswerState.yesOk),
                        style:
                            yesOkStyle ??
                            ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightBlue,
                              foregroundColor: AppColors.blue,
                            ),
                        child: Text(yesOkLabel),
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }

  /// modal bottom for detail item
  static Future<AvatarAnswerState?> showActionAvatar(
    BuildContext context, {
    String title = 'Ubah gambar',
    bool isDismissible = true,
    bool hasDelete = false,
  }) async {
    return showCupertinoModalBottomSheet<AvatarAnswerState>(
      context: context,
      barrierColor: AppColors.modalBarrier,
      topRadius: const Radius.circular(AppDimens.radiusLargeX),
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) {
        return _responsiveSheet(
          context,
          _ModalBottomDetailView(
            title: title,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButtonCustom(
                  label: 'Kamera',
                  icon: const Icon(Icons.camera_alt_rounded),
                  color: AppColors.labelPrimary,
                  onTap: () => context.router.pop<AvatarAnswerState>(
                    AvatarAnswerState.camera,
                  ),
                ),
                IconButtonCustom(
                  label: 'Galeri',
                  icon: const Icon(Icons.collections_rounded),
                  color: AppColors.labelPrimary,
                  onTap: () => context.router.pop<AvatarAnswerState>(
                    AvatarAnswerState.gallery,
                  ),
                ),
                if (hasDelete)
                  IconButtonCustom(
                    label: 'Hapus',
                    icon: const Icon(Icons.delete_rounded),
                    color: AppColors.labelPrimary,
                    onTap: () => context.router.pop<AvatarAnswerState>(
                      AvatarAnswerState.delete,
                    ),
                  ),
              ],
            ),
            action: const [],
          ),
        );
      },
    );
  }
}

class _ModalBottomView extends StatelessWidget {
  final String? title;
  final String contentTitle;
  final String contentSubtitle;
  final EmptyState emptyState;
  final List<Widget>? action;

  const _ModalBottomView({
    this.title,
    required this.contentTitle,
    required this.contentSubtitle,
    required this.emptyState,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimens.radiusLargeX),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingMediumX),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.start,
                  style: context.textStyle.titleLarge,
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppUtility.handleEmptyState(emptyState),
                    width: MediaQuery.sizeOf(context).width >= 600
                        ? 104
                        : AppDimens.emptyStateSize.width,
                    height: MediaQuery.sizeOf(context).width >= 600
                        ? 104
                        : AppDimens.emptyStateSize.height,
                  ),
                  const SizedBox(height: AppDimens.sizeL),
                  Text(
                    contentTitle,
                    textAlign: TextAlign.center,
                    style: context.textStyle.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.size3S),
                  Text(
                    contentSubtitle,
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyMedium!.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.sizeL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: action!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalBottomDetailView extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? action;

  const _ModalBottomDetailView({
    required this.title,
    required this.content,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimens.radiusLargeX),
        topRight: Radius.circular(AppDimens.radiusLargeX),
      ),
      child: SafeArea(
        bottom: action != null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: AppDimens.paddingMedium),
              width: AppDimens.sizeXL,
              height: AppDimens.size2S,
              decoration: BoxDecoration(
                color: AppColors.labelSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textStyle.titleMedium?.copyWith(
                      color: AppColors.labelPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),

                  AppDimens.paddingLarge.hSpace,

                  content,

                  // action buttons section
                  if (action != null && action?.isNotEmpty == true) ...[
                    const SizedBox(height: AppDimens.paddingLarge),

                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),

                    const SizedBox(height: AppDimens.paddingLarge),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: action!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
