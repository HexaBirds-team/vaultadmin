// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/user_profile_view.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class NewUsersTile extends StatelessWidget {
  UserInformationClass profile;

  NewUsersTile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.sp),
      child: AspectRatio(
        aspectRatio: 0.7,
        child: InkWell(
          onTap: () =>
              AppServices.pushTo(context, UserProfileView(user: profile)),
          child: Container(
            decoration: WidgetDecoration.containerDecoration_1(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.35.sp,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r)),
                      child: Image.network(profile.image, fit: BoxFit.cover)
                      // CachedNetworkImage(
                      //     imageUrl: profile.image,
                      //     fit: BoxFit.cover,
                      //     placeholder: (context, url) => BoxShimmerView())
                      // WidgetImplimentor().addNetworkImage(
                      // url: profile.image, fit: BoxFit.cover),
                      ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(profile.username,
                            textAlign: TextAlign.center,
                            style: GetTextTheme.sf16_bold),
                        AppServices.addHeight(3.h),
                        Text(profile.phone,
                            textAlign: TextAlign.center,
                            style: GetTextTheme.sf14_medium)
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
