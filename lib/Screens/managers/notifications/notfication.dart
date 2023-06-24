import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<int> index = [];
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final notifications = db.getNotifications;
    return Scaffold(
        appBar:
            customAppBar(context: context, title: const Text("Notifications")),
        body: notifications.isEmpty
            ? AppServices.getEmptyIcon(
                "You have no notification right now. Please come back later.",
                "No Notifications Yet",
                image: AppImages.noNotificationImage)
            : ListView.builder(
                itemCount: notifications.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  final data = notifications[i];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                    ),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      child: ExpansionTile(
                        subtitle: index.any((element) => element == i)
                            ? null
                            : Text(
                                data.msg,
                                maxLines: 2,
                              ),
                        onExpansionChanged: (v) {
                          if (v) {
                            index.add(i);
                          } else {
                            (index.remove(i));
                          }
                          setState(() {});
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(data.title,
                                  style: GetTextTheme.sf18_medium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            AppServices.addWidth(5.w),
                            Text(
                              CheckTimeAgo(data.time).timeAgo(),
                              style: GetTextTheme.sf14_regular
                                  .copyWith(color: AppColors.greyColor),
                            )
                          ],
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        expandedAlignment: Alignment.centerLeft,
                        leading:
                            Image.asset(AppIcons.documentsIcon, width: 28.w),
                        children: [
                          Text(
                            data.msg,
                            textAlign: TextAlign.start,
                          ),
                          AppServices.addHeight(10.h)
                        ],
                      ),
                    ),
                  );
                }));
  }
}
