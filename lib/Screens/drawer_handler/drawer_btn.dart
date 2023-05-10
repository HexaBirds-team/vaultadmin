// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class DrawerButtonView extends StatelessWidget {
  String text, image;
  bool pop;
  Function? callback;
  DrawerButtonView(
      {Key? key,
      required this.text,
      required this.callback,
      required this.image,
      this.pop = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback == null
          ? null
          : () {
              pop ? Scaffold.of(context).closeDrawer() : null;
              callback!();
            },
      title: Text(text, style: GetTextTheme.sf16_regular),
      leading: ImageGradient(
        image: image,
        gradient: AppColors.appGradientColor,
        height: 24.sp,
        width: 24.sp,
      ),
    );
  }
}

class AccountBtnView extends StatelessWidget {
  String text, image;
  bool pop;
  Function? callback;
  int counts;
  bool enableBorder;
  AccountBtnView(
      {Key? key,
      required this.text,
      required this.callback,
      required this.image,
      this.pop = true,
      this.counts = 0,
      this.enableBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: WidgetDecoration.containerDecoration_1(context,
          enableShadow: false, enableBorder: enableBorder),
      child: ListTile(
        tileColor: AppColors.whiteColor,
        onTap: callback == null
            ? null
            : () {
                pop ? Scaffold.of(context).closeDrawer() : null;
                callback!();
              },
        title: Text(text, style: GetTextTheme.sf16_bold),
        leading: Image.asset(image, width: 30, height: 30),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            counts == 0
                ? const SizedBox()
                : Container(
                    alignment: Alignment.center,
                    height: 26,
                    width: 26,
                    decoration:
                        WidgetDecoration.circularContainerDecoration_1(context)
                            .copyWith(
                                color: AppColors.primary1.withOpacity(0.2)),
                    child:
                        Text(counts.toString(), style: GetTextTheme.sf16_bold),
                  ),
            counts == 0 ? const SizedBox() : AppServices.addWidth(10.w),
            const Icon(Icons.keyboard_arrow_right_rounded,
                color: AppColors.primary1),
          ],
        ),
      ),
    );
  }
}
