import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';
import 'hr_translation_lookup.dart';
import 'app_language_controller.dart';

// Legacy standalone widgets without app delegates keep their Indonesian default.
AppLocalizations hrLocale(BuildContext context) =>
    AppLocalizations.of(context) ?? lookupAppLocalizations(const Locale('id'));

/// Localize the period before inserting it into the attendance clock label.
String hrAttendanceClockLabel(DateTime time, AppLocalizations locale) {
  final period = switch (time.hour) {
    >= 5 && < 10 => locale.clockPeriodMorning,
    >= 10 && < 15 => locale.clockPeriodMidday,
    >= 15 && < 18 => locale.clockPeriodAfternoon,
    _ => locale.clockPeriodNight,
  };
  return locale.attendanceClockLabel(period);
}

extension HrLocalizedString on String {
  String tr(BuildContext context) => translateHrText(this, hrLocale(context));

  /// Global toasts can outlive their originating page after an async operation.
  String trCurrent() => translateHrText(
    this,
    lookupAppLocalizations(AppLanguageController.instance.effectiveLocale),
  );
}

/// Enum labels describe UI choices; model names and free-text choices are data.
String hrOptionLabel(Object? option, String label, BuildContext context) =>
    option is Enum ? label.tr(context) : label;

/// Explicitly used for UI copy only. Keep Text for names, chat, and user input.
/// Rendering at build time allows const widgets to respond to locale changes.
class HrText extends StatelessWidget {
  const HrText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.signIn = false,
  });
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final String? semanticsIdentifier;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool signIn;
  @override
  Widget build(BuildContext context) {
    final l = hrLocale(context);
    final translated = signIn && data == 'Masuk'
        ? l.signInAction
        : translateHrText(data, l);
    return Text(
      translated,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler:
          textScaler ??
          (textScaleFactor == null
              ? null
              : TextScaler.linear(textScaleFactor!)),
      maxLines: maxLines,
      semanticsLabel: semanticsLabel == null
          ? null
          : translateHrText(semanticsLabel!, l),
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
