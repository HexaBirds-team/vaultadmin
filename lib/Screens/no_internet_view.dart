import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/splash.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.noInternetPng,
                  height: 200.h, fit: BoxFit.cover),
              AppServices.addHeight(15.h),
              Text("Whoops!!", style: GetTextTheme.sf24_bold),
              AppServices.addHeight(3.h),
              Text(
                  "No Internet connection was found. Check your connection or try again.",
                  textAlign: TextAlign.center,
                  style: GetTextTheme.sf14_medium),
              AppServices.addHeight(35.h),
              ButtonOneExpanded(
                  onPressed: () {
                    AppServices.pushAndRemove(const SplashScreen(), context);
                  },
                  btnText: "Try Again")
            ],
          ),
        ),
      ),
    );
  }
}
