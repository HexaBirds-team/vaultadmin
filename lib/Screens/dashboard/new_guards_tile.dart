// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/widget_creator.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class NewGuardsTile extends StatelessWidget {
  ProvidersInformationClass profile;
  bool isPopUpButton;
  Function onApprove;
  Function onReject;

  NewGuardsTile(
      {super.key,
      required this.profile,
      this.isPopUpButton = true,
      required this.onApprove,
      required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.sp),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 0.8.sp,
            child: InkWell(
              onTap: () => AppServices.pushTo(
                  context, GuardProfileView(providerDetails: profile)),
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
                        child: WidgetImplimentor().addNetworkImage(
                            url: profile.profileImage, fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.sp, vertical: 5.sp),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(profile.name,
                                textAlign: TextAlign.center,
                                style: GetTextTheme.sf16_bold),
                            AppServices.addHeight(3.h),
                            Text(profile.phone,
                                textAlign: TextAlign.center,
                                style: GetTextTheme.sf14_medium),
                            AppServices.addHeight(3.h),
                            Text(profile.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GetTextTheme.sf14_regular),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ),
          isPopUpButton
              ? Positioned(
                  top: 8.sp,
                  right: 8.sp,
                  child: Container(
                    width: 30.sp,
                    height: 30.sp,
                    decoration: BoxDecoration(
                        color: AppColors.blackColor.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: PopupMenuButton(
                        iconSize: 20.sp,
                        padding: const EdgeInsets.all(0),
                        color: AppColors.whiteColor,
                        onSelected: (value) async {
                          if (value == "approve") {
                            onApprove();
                          } else {
                            onReject();
                          }
                        },
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                  value: "approve", child: Text("Approve")),
                              const PopupMenuItem(
                                  value: "reject", child: Text("Reject")),
                            ]),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
