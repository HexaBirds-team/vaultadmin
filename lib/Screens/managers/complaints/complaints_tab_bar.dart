import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/managers/complaints/complaints_manager.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_text.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../models/enums.dart';

class ComplaintsTabBarView extends StatefulWidget {
  const ComplaintsTabBarView({super.key});

  @override
  State<ComplaintsTabBarView> createState() => _ComplaintsTabBarViewState();
}

class _ComplaintsTabBarViewState extends State<ComplaintsTabBarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: ComplaintStatus.values.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Manage complaints"),
            bottom: TabBar(
                indicatorPadding: const EdgeInsets.all(0.0),
                indicatorWeight: 4.0,
                labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                indicator: ShapeDecoration(
                    shape: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    gradient: AppColors.appGradientColor),
                controller: _tabController,
                tabs: ComplaintStatus.values
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
          ComplaintsManager(status: ComplaintStatus.pending.name),
          ComplaintsManager(status: ComplaintStatus.processing.name),
          ComplaintsManager(status: ComplaintStatus.resolved.name),
          ComplaintsManager(status: ComplaintStatus.cancelled.name),
        ]));
  }
}
