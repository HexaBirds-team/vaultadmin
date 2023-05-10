import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../helpers/style_sheet.dart';
import '../../components/provider_tile.dart';
import '../../controllers/app_functions.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/icons_and_images.dart';
import '../GuardAccount/guard_profile.dart';

class AdminProviderManager extends StatefulWidget {
  const AdminProviderManager({super.key});

  @override
  State<AdminProviderManager> createState() => _AdminProviderManagerState();
}

class _AdminProviderManagerState extends State<AdminProviderManager> {
  int guardsLength = 0;
  bool isGuardFetch = true;

  Query getUrl() {
    final path =
        database.ref("Providers").orderByChild("isApproved").equalTo(true);
    return path;
  }

  @override
  void initState() {
    super.initState();
    getGuardsLength();
  }

  getGuardsLength() async {
    final path = await database
        .ref("Providers")
        .orderByChild("isApproved")
        .equalTo(true)
        .once();

    if (!mounted) return;
    setState(() {
      guardsLength = path.snapshot.children.length;
      isGuardFetch = false;
    });
    return path.snapshot.children.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Providers", style: GetTextTheme.sf20_regular),
      ),
      body: SafeArea(
          child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(child: SearchField()),
          //       AppServices.addWidth(10.w),
          //       Container(
          //           decoration: WidgetDecoration.containerDecoration_1(context),
          //           child: IconButton(
          //               onPressed: () {}, icon: const Icon(Icons.filter_alt)))
          //     ],
          //   ),
          // ),
          AppServices.addHeight(10.h),
          Expanded(
            child: SizedBox(
                child: Stack(
              children: [
                FirebaseAnimatedList(
                    shrinkWrap: true,
                    defaultChild: const OnViewLoader(),
                    query: getUrl(),
                    itemBuilder: (context, snapshot, animation, i) {
                      if (i > 0) {
                        isGuardFetch = true;
                      }
                      if (i == 0 && isGuardFetch == true) {
                        getGuardsLength();
                      }
                      ProvidersInformationClass provider =
                          ProvidersInformationClass.fromUser(
                              snapshot.value as Map<Object?, Object?>,
                              snapshot.key.toString());
                      return InkWell(
                          onTap: () => AppServices.pushTo(context,
                              GuardProfileView(providerDetails: provider)),
                          child: Padding(
                            padding: EdgeInsets.all(10.sp).copyWith(top: 0),
                            child: ProviderTile(provider: provider),
                          ));
                    }),
                guardsLength == 0
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
                            Text("No Data Found",
                                style: GetTextTheme.sf18_bold),
                            Text("There are no new approved joinee.",
                                style: GetTextTheme.sf14_regular)
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            )
                // providersList.isEmpty
                //     ? Center(
                //         child: Container(
                //           width: AppServices.getScreenWidth(context),
                //           padding: EdgeInsets.all(25.sp),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Image.asset(AppImages.emptyImage, width: 130.w),
                //               Text("No Result Found",
                //                   style: GetTextTheme.sf22_regular),
                //             ],
                //           ),
                //         ),
                //       )
                //     : ListView.separated(
                //         padding: EdgeInsets.symmetric(horizontal: 10.sp),
                //         itemCount: providersList.length,
                //         shrinkWrap: true,
                //         itemBuilder: (context, i) {
                //           final provider = providersList[i];
                //           return
                //         },
                //         separatorBuilder: (BuildContext context, int index) =>
                //             AppServices.addHeight(5.h),
                //       ),
                ),
          ),
        ],
      )),
    );
  }
}
