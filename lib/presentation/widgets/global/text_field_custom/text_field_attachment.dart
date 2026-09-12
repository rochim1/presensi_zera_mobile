import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class TextFieldAttachment extends StatelessWidget {
  final String? title;
  final String hint;
  final Color? colorTitle;

  /// please use 'AttachmentType.document`, for camera not define
  final AttachmentType? attachmentType;
  final bool? multipleFile;
  final PlatformFile? initFile;
  final List<String>? extensions;

  /// default FileType.any
  final FileType? type;
  final Function(List<PlatformFile>? files)? onUpload;

  final bool required;

  const TextFieldAttachment({
    super.key,
    this.title,
    required this.hint,
    this.attachmentType = AttachmentType.document,
    this.colorTitle,
    this.extensions,
    this.type = FileType.custom,
    this.initFile,
    this.multipleFile = false,
    this.required = false,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GlobalAttachmentCubit>()..initial(initFile),
      child: BlocConsumer<GlobalAttachmentCubit, GlobalAttachmentState>(
        listener: (context, state) {
          if (state.typeState.isLoaded) {
            onUpload!(state.files);
          }
          if (state.typeState.isNotLoaded) {
            Fluttertoast.showToast(msg: state.failure!.message);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: AppDimens.size2S),
                  child: RichText(
                    text: TextSpan(
                      text: title,
                      style: context.textStyle.bodySmall?.copyWith(
                        color: colorTitle ?? AppColors.labelPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
              ],
              if (title != null) const SizedBox(height: AppDimens.size3S),
              (state.typeState.isLoaded)
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.files!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () =>
                              context.read<GlobalAttachmentCubit>().uploadFile(
                                multipleFile,
                                extensions ?? AppUtility.listExtensions,
                                type,
                              ),
                          child: ListItemAttachment(
                            fileName: state.files![index].name,
                            onDelete: () {
                              context.read<GlobalAttachmentCubit>().deleteFiles(
                                state.files!.first,
                              );
                              onUpload!(state.files);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppDimens.paddingMedium),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () =>
                              context.read<GlobalAttachmentCubit>().uploadFile(
                                multipleFile,
                                extensions ?? AppUtility.listExtensions,
                                type,
                              ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.sizeM,
                              horizontal: AppDimens.size3S,
                            ),
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
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusMedium,
                              ),
                              color:
                                  context.theme.inputDecorationTheme.fillColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  hint,
                                  style: context
                                      .theme
                                      .inputDecorationTheme
                                      .hintStyle!
                                      .copyWith(fontSize: AppDimens.size3M),
                                ),
                                Icon(
                                  Icons.file_present_rounded,
                                  color: AppColors.labelSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }
}
