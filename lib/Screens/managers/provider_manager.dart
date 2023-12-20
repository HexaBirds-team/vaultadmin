import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

import '../../../helpers/style_sheet.dart';
import '../../components/provider_tile.dart';
import '../../helpers/base_getters.dart';
import '../GuardAccount/guard_profile.dart';

class AdminProviderManager extends StatefulWidget {
  const AdminProviderManager({super.key});

  @override
  State<AdminProviderManager> createState() => _AdminProviderManagerState();
}

class _AdminProviderManagerState extends State<AdminProviderManager> {
  String filteredValue = "all";
  filterProviders(AppDataController db) {
    final providersList = db.getAllProviders
        .where((e) => e.isApproved != GuardApprovalStatus.pending)
        .toList();
    switch (filteredValue) {
      case "approved":
        return providersList
            .where((element) =>
                (element.isApproved == GuardApprovalStatus.approved) &&
                !element.isBlocked)
            .toList();
      case "rejected":
        return providersList
            .where((element) =>
                (element.isApproved == GuardApprovalStatus.rejected) &&
                !element.isBlocked)
            .toList();
      case "objection":
        return providersList
            .where((element) =>
                (element.isApproved == GuardApprovalStatus.objection) &&
                !element.isBlocked)
            .toList();
      case "blocked":
        return providersList.where((element) => element.isBlocked).toList();

      default:
        return providersList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final providersList = filterProviders(db);
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Providers", style: GetTextTheme.sf20_regular),
        actions: [
          PopupMenuButton(
              initialValue: filteredValue,
              onSelected: (v) => setState(() => filteredValue = v),
              icon: const Icon(Icons.filter_alt),
              itemBuilder: (context) => [
                    const PopupMenuItem(value: "all", child: Text("All")),
                    ...GuardApprovalStatus.values.where((element) {
                      return element.name != GuardApprovalStatus.pending.name;
                    }).map((e) {
                      var text = e.name.split("");
                      text[0] = text[0].toUpperCase();

                      return PopupMenuItem(
                          value: e.name, child: Text(text.join()));
                    }).toList(),
                    const PopupMenuItem(
                        value: "blocked", child: Text("Blocked"))
                  ])
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          AppServices.addHeight(10.h),
          Expanded(
            child: SizedBox(
              child: providersList.isEmpty
                  ? Center(
                      child: AppServices.getEmptyIcon(
                          "There are no data of any guard.", "No Data Found"))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      itemCount: providersList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        final provider = providersList[i];
                        return InkWell(
                            onTap: () => AppServices.pushTo(context,
                                GuardProfileView(providerDetails: provider)),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp).copyWith(top: 0),
                              child: ProviderTile(
                                  provider: provider,
                                  color: provider.isApproved ==
                                          GuardApprovalStatus.rejected
                                      ? AppColors.redColor.withOpacity(0.05)
                                      : AppColors.whiteColor),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          AppServices.addHeight(5.h),
                    ),
            ),
          ),
        ],
      )),
    );
  }
}
