import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppModalDialog {
  AppModalDialog._();

  @Deprecated('Please use `AppModalBottom.hadleError` for showing error')
  static Future<AnswerState?> handleError(
    BuildContext context,
    String error, [
    String? code,
  ]) {
    final dialog =
        confirm(
          context: context,
          title: "Error",
          description: error,
          labelCancel: '',
          isDismiss: code?.isUnauthorized ?? false,
        ).then((value) async {
          if (code != null && value!.isYesOk) {
            ///
            // if (code.isUnauthorized) {
            //   SmartDialog.showLoading();
            //   await sl<LogoutCubit>().logout();
            //   SmartDialog.dismiss();
            //   context.router.pushAndPopUntil(const MainPageRoute(), predicate: (r) => true);
            // }
          }
        });

    return dialog;
  }

  @Deprecated('Please use `AppModalBottom.showConfirm` for showing error')
  static Future<AnswerState?> confirm({
    required BuildContext context,
    String? title = 'Info',
    String? description,
    Widget? content,
    bool? isDismiss = true,
    String? labelYesOk = 'Ok',
    String? labelCancel = 'Batal',
    Color? colorYesOk,
  }) {
    late List<Widget> structure = [];
    late List<Widget> action = [];

    structure.addAll([
      Text(title!, style: AppTextStyle.dialogTitle),
      const SizedBox(height: AppDimens.size3S),
    ]);
    if (description != null) {
      structure.add(Text(description, style: AppTextStyle.dialogDesc));
    }
    if (content != null) {
      structure.addAll([const SizedBox(height: AppDimens.sizeL), content]);
    }

    if (labelCancel!.isNotEmpty) {
      action.add(
        ElevatedButton(
          onPressed: () => context.router.pop<AnswerState>(AnswerState.cancel),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.fillTertiary,
            foregroundColor: AppColors.labelSecondary,
          ),
          child: Text(labelCancel),
        ),
      );
    }

    action.addAll([
      const SizedBox(width: AppDimens.size2M),
      ElevatedButton(
        onPressed: () => context.router.pop<AnswerState>(AnswerState.yesOk),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorYesOk ?? AppColors.primary,
        ),
        child: Text(labelYesOk!),
      ),
    ]);

    return showDialog<AnswerState>(
      context: context,
      barrierDismissible: isDismiss!,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: context.width / 1.2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.sizeXL,
                vertical: AppDimens.size2L,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusLargeX),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < structure.length; i++) structure[i],
                  const SizedBox(height: AppDimens.size2L),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: action.map((e) => e).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// date picker like `showDatePicker` but this component is custom
  static Future<DateTime?> datePicker(
    BuildContext context, {
    DateTime? initialDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: AppUtility.localeId(),
      builder: (context, child) => Theme(
        data: AppTheme.light().copyWith(
          dialogTheme: const DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.radiusLargeX),
              ),
            ),
          ),
        ),
        child: child!,
      ),
    );
  }
}

class ContentForm {
  final Widget content;
  final void Function()? onYesOk;
  final void Function()? cancel;

  ContentForm(this.content, this.onYesOk, this.cancel);
}
