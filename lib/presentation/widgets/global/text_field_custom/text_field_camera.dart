import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TextFieldCamera extends StatefulWidget {
  final String? title;
  final Color? colorTitle;
  final String? helperText;
  final CameraLensDirection cameraLensDirection;
  final bool? multipleFile;
  final Function(List<XFile>? files)? onUpload;
  final bool required;

  const TextFieldCamera({
    super.key,
    this.title,
    this.helperText,
    required this.cameraLensDirection,
    this.colorTitle,
    this.multipleFile = false,
    required this.onUpload,
    this.required = false,
  });

  @override
  State<TextFieldCamera> createState() => _TextFieldCameraState();
}

class _TextFieldCameraState extends State<TextFieldCamera> {
  late List<XFile>? xfile;

  @override
  void initState() {
    super.initState();
    xfile = <XFile>[XFile(''), XFile('')];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.size2S),
            child: RichText(
              text: TextSpan(
                text: widget.title,
                style: context.textStyle.bodySmall?.copyWith(
                  color: widget.colorTitle ?? AppColors.labelPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  if (widget.required == true)
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
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  context.router
                      .push(
                        GlobalCameraPageRoute(
                          cameraLensDirection: widget.cameraLensDirection,
                        ),
                      )
                      .then((value) {
                        if (value != null) {
                          setState(() => xfile!.first = value as XFile);

                          widget.onUpload!(xfile);
                        }
                      });
                },
                child: Container(
                  height: AppDimens.size8X,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context
                          .theme
                          .inputDecorationTheme
                          .enabledBorder!
                          .borderSide
                          .color,
                      width: context
                          .theme
                          .inputDecorationTheme
                          .enabledBorder!
                          .borderSide
                          .width,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    color: context.theme.inputDecorationTheme.fillColor,
                  ),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      if (xfile!.first.path.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMedium,
                          ),
                          child: Image.file(
                            File(xfile!.first.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: xfile!.first.path.isNotEmpty
                              ? AppColors.labelSecondaryDark
                              : AppColors.labelSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppDimens.sizeM.wSpace,
            //! second widget
            Expanded(
              child: InkWell(
                onTap: () {
                  context.router
                      .push(
                        GlobalCameraPageRoute(
                          cameraLensDirection: widget.cameraLensDirection,
                        ),
                      )
                      .then((value) {
                        if (value != null) {
                          setState(() => xfile!.last = value as XFile);
                          widget.onUpload!(xfile);
                        }
                      });
                },
                child: Container(
                  height: AppDimens.size8X,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context
                          .theme
                          .inputDecorationTheme
                          .enabledBorder!
                          .borderSide
                          .color,
                      width: context
                          .theme
                          .inputDecorationTheme
                          .enabledBorder!
                          .borderSide
                          .width,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    color: context.theme.inputDecorationTheme.fillColor,
                  ),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      if (xfile!.last.path.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMedium,
                          ),
                          child: Image.file(
                            File(xfile!.last.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: (xfile!.last.path.isNotEmpty)
                              ? AppColors.labelSecondaryDark
                              : AppColors.labelSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: AppDimens.size2S),
          RichText(
            text: TextSpan(
              text: '* ',
              style: context.textStyle.labelSmall!.copyWith(
                letterSpacing: 0.25,
                color: AppColors.red,
              ),
              children: [
                TextSpan(
                  text: widget.helperText!,
                  style: context.textStyle.labelSmall!.copyWith(
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
