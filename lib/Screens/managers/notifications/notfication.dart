import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationManagerState();
}

class _NotificationManagerState extends State<NotificationsView> {
  int notificationsLength = 0;
  bool isNotificationFetch = true;

  Query getQuery() {
    final path =
        database.ref("Notifications").orderByChild("receiver").equalTo("Admin");
    return path;
  }

  getNotificationsLength() async {
    final path = await database
        .ref("Notifications")
        .orderByChild("receiver")
        .equalTo("Admin")
        .once();

    if (!mounted) return;
    setState(() {
      notificationsLength = path.snapshot.children.length;
      isNotificationFetch = false;
    });
    return path.snapshot.children.length;
  }

  @override
  void initState() {
    super.initState();
    getNotificationsLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            customAppBar(context: context, title: const Text("Notifications")),
        body: Stack(
          children: [
            SafeArea(
                child: FirebaseAnimatedList(
                    // defaultChild: const OnViewLoader(),
                    shrinkWrap: true,
                    query: getQuery(),
                    itemBuilder: (context, snapshot, animation, i) {
                      if (i > 0) {
                        isNotificationFetch = true;
                      }
                      if (i == 0 && isNotificationFetch == true) {
                        getNotificationsLength();
                      }
                      NotificationModel data =
                          NotificationModel.fromNotification(
                              snapshot.value as Map<Object?, Object?>,
                              snapshot.key.toString());
                      return Padding(
                        padding: EdgeInsets.all(20.sp),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.sp),
                          padding: EdgeInsets.only(bottom: 10.h),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: AppColors.greyColor))),
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
                    })),
            notificationsLength == 0
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
                : const SizedBox()
          ],
        ));
  }
}
