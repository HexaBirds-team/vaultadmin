import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final notifications = db.getNotifications;
    return Scaffold(
        appBar:
            customAppBar(context: context, title: const Text("Notifications")),
        body: notifications.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppIcons.emptyIcon,
                      height: 70.sp,
                    ),
                    AppServices.addHeight(10.h),
                    Text("No Data Found", style: GetTextTheme.sf18_bold),
                    Text("There are not any notifications yet.",
                        style: GetTextTheme.sf14_regular)
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  final data = notifications[i];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp)
                        .copyWith(top: 15.sp),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.sp),
                      padding: EdgeInsets.only(bottom: 10.h),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColors.greyColor))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(TextSpan(
                                  text: data.title,
                                  style: GetTextTheme.sf16_bold,
                                  children: [
                                    TextSpan(
                                        text: " ${data.msg}",
                                        style: GetTextTheme.sf16_regular)
                                  ])),
                              AppServices.addHeight(5.h),
                              Text(CheckTimeAgo(data.time).timeAgo(),
                                  style: GetTextTheme.sf12_regular)
                            ],
                          )),
                          AppServices.addWidth(15.w),
                          Container(
                            alignment: Alignment.center,
                            height: 45.sp,
                            width: 45.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.appGradientColor),
                            child: Text(data.notificationType[0],
                                style: GetTextTheme.sf22_bold
                                    .copyWith(color: AppColors.whiteColor)),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
  }
}
