import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final Widget? title;
  final List<Widget>? actions;
  final double? radius;
  final bool centerTitle;
  final Widget? leading;
  final double? leadingWidth;

  const AppBarWidget({
    super.key,
    this.titleText,
    this.actions,
    this.radius,
    this.centerTitle = true,
    this.title,
    this.leading,
    this.leadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      elevation: 0,
      leading:
          leading ??
          (canPop
              ? Center(
                  child: AppTopBarActionButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                )
              : null),
      leadingWidth: leadingWidth ?? (canPop ? 56.0 : null),
      backgroundColor: AppColors.transparent,
      centerTitle: centerTitle,
      title:
          title ??
          Text(
            titleText ?? '',
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radius ?? 24.0),
          ),
          image: const DecorationImage(
            image: AssetImage(AppImages.geometricBg),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
