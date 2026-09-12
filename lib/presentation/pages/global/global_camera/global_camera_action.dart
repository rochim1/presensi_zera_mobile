part of 'global_camera_page.dart';

class GlobalCameraAction extends StatelessWidget {
  final Function() onCapture;
  final Function()? onFlashMode;
  final Function() onSaved;
  final Function() onClosed;
  final Function()? onPickerImage;
  final String info;

  const GlobalCameraAction({
    super.key,
    required this.onCapture,
    required this.onFlashMode,
    required this.onSaved,
    required this.onClosed,
    required this.info,
    this.onPickerImage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCameraCubit, GlobalCameraState>(
      builder: (context, state) {
        return SizedBox(
          height: AppDimens.heightActionCamera,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: onFlashMode != null || onPickerImage != null
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!state.cameraState.isSuccess && onPickerImage != null)
                    Visibility(
                      visible: onPickerImage != null,
                      child: IconButton(
                        icon: const Icon(Icons.image_rounded),
                        color: AppColors.white,
                        iconSize: AppDimens.size2L,
                        onPressed: onPickerImage,
                      ),
                    )
                  else
                    AppDimens.size4XL.wSpace,
                  IconBottomCamera(
                    isTakingPicture: state.cameraState.isSuccess,
                    onCapture: onCapture,
                    onSave: onSaved,
                    onClose: onClosed,
                  ),
                  if (!state.cameraState.isSuccess && onFlashMode != null)
                    Visibility(
                      visible: onFlashMode != null,
                      child: IconButton(
                        icon: Icon(
                          state.flashMode!.isOff
                              ? Icons.flash_off_rounded
                              : Icons.flash_on_rounded,
                        ),
                        color: AppColors.white,
                        iconSize: AppDimens.size2L,
                        onPressed: onFlashMode,
                      ),
                    )
                  else
                    AppDimens.size4XL.wSpace,
                ],
              ),
              //! Information
              const SizedBox(height: AppDimens.size4M),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: AppDimens.size4M,
                    color: AppColors.white,
                  ),
                  AppDimens.size3S.wSpace,
                  Text(
                    info,
                    style: context.textStyle.bodySmall!.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
