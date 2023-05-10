import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/pop_ups/update_subscription_dialog.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../components/gradient_components/gradient_image.dart';
import '../../../components/loaders/on_view_loader.dart';
import '../../../controllers/app_functions.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';

class SubscriptionManager extends StatefulWidget {
  String plan;
  SubscriptionManager({super.key, required this.plan});

  @override
  State<SubscriptionManager> createState() => _SubscriptionManagerState();
}

class _SubscriptionManagerState extends State<SubscriptionManager> {
  getSubscriptionUrl() {
    final path =
        database.ref("Subscriptions").orderByChild("plan").equalTo(widget.plan);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FirebaseAnimatedList(
            padding: EdgeInsets.only(top: 15.h),
            shrinkWrap: true,
            defaultChild: const OnViewLoader(),
            query: getSubscriptionUrl(),
            itemBuilder: (context, snapshot, animation, i) {
              SubscriptionClass data = SubscriptionClass.fromSubscription(
                  snapshot.value as Map<Object?, Object?>,
                  snapshot.key.toString());
              return ListTile(
                title: Text(
                    data.type
                        .replaceFirst(data.type[0], data.type[0].toUpperCase()),
                    style: GetTextTheme.sf16_medium),
                subtitle: Text.rich(TextSpan(
                    text: "Subscription Amount : ",
                    style: GetTextTheme.sf16_regular,
                    children: [
                      TextSpan(
                          text:
                              "${AppServices.getCurrencySymbol}${data.amount}",
                          style: GetTextTheme.sf16_bold)
                    ])),
                leading: Container(
                  padding: EdgeInsets.all(15.sp),
                  decoration: BoxDecoration(
                      gradient: AppColors.appGradientColor,
                      shape: BoxShape.circle),
                  child: Text(
                      data.type[0].replaceFirst(
                          data.type[0], data.type[0].toUpperCase()),
                      style: GetTextTheme.sf18_medium
                          .copyWith(color: AppColors.whiteColor)),
                ),
                trailing: IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            UpdateSubscriptionDialog(data: data)),
                    splashRadius: 20.sp,
                    icon: ImageGradient(
                        image: AppIcons.editIcon,
                        gradient: AppColors.appGradientColor)),
              );
            }));
  }
}
