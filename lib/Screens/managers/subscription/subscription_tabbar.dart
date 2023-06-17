import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/managers/subscription/subscription_manager.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_text.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

import '../../../models/enums.dart';

class SubscriptionsTabBarView extends StatefulWidget {
  const SubscriptionsTabBarView({super.key});

  @override
  State<SubscriptionsTabBarView> createState() =>
      _SubscriptionsTabBarViewState();
}

class _SubscriptionsTabBarViewState extends State<SubscriptionsTabBarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: SubscriptionPlan.values.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Manage Subscription"),
            bottom: TabBar(
                indicatorPadding: const EdgeInsets.all(0.0),
                indicatorWeight: 4.0,
                labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                indicator: ShapeDecoration(
                    shape: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    gradient: AppColors.appGradientColor),
                controller: _tabController,
                tabs: SubscriptionPlan.values
                    .map(
                      (e) => Container(
                          alignment: Alignment.center,
                          color: AppColors.whiteColor,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.sp, top: 14.sp),
                            child: GradientText(
                                e.name.replaceFirst(
                                    e.name[0], e.name[0].toUpperCase()),
                                gradient: AppColors.appGradientColor,
                                style: GetTextTheme.sf16_medium),
                          )),
                    )
                    .toList())),
        body: TabBarView(controller: _tabController, children: [
          SubscriptionManager(plan: SubscriptionPlan.hourly.name),
          SubscriptionManager(plan: SubscriptionPlan.daily.name),
          SubscriptionManager(plan: SubscriptionPlan.monthly.name),
        ]));
  }
}
