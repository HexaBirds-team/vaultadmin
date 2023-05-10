import 'package:flutter/material.dart';

import '../helpers/base_getters.dart';
import '../helpers/style_sheet.dart';

class ButtonOneExpanded extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final Function? onPressed;
  final dynamic btnText;
  final bool btnTextWithIcon;
  final Color btnColor;
  final Color btnTextClr;
  final bool disableGradient;
  final bool enableColor;
  final bool btnTextColor;
  final bool showBorder;

  const ButtonOneExpanded(
      {Key? key,
      required this.onPressed,
      required this.btnText,
      this.borderRadius,
      this.width,
      this.height = 44.0,
      this.gradient = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0336FF), Color(0xffE384FF)]),
      this.btnTextWithIcon = false,
      this.btnColor = AppColors.whiteColor,
      this.btnTextClr = AppColors.whiteColor,
      this.disableGradient = false,
      this.enableColor = false,
      this.btnTextColor = false,
      this.showBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(8);
    return Container(
      width: width,
      height: 45,
      decoration: BoxDecoration(
          gradient: disableGradient ? null : gradient,
          borderRadius: borderRadius,
          border: showBorder
              ? Border.all(color: AppColors.blackColor.withOpacity(0.2))
              : null),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: enableColor ? btnColor : Colors.transparent,
            shadowColor: enableColor ? btnColor : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            fixedSize: Size(AppServices.getScreenWidth(context), 45)),
        onPressed: onPressed == null ? null : () => onPressed!(),
        child: btnTextWithIcon
            ? btnText
            : Text(
                btnText,
                style: GetTextTheme.sf18_regular.copyWith(
                  color: btnTextColor ? btnTextClr : AppColors.whiteColor,
                ),
              ),
      ),
    );
  }
}
