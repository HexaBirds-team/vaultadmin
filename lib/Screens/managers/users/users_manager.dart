import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/user_profile_view.dart';
import 'package:valt_security_admin_panel/controllers/widget_creator.dart';

import '../../../../helpers/style_sheet.dart';
import '../../../controllers/app_data_controller.dart';
import '../../../controllers/app_settings_controller.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';

class AllUserManagerView extends StatefulWidget {
  const AllUserManagerView({super.key});

  @override
  State<AllUserManagerView> createState() => _AllUserManagerViewState();
}

class _AllUserManagerViewState extends State<AllUserManagerView> {
  /* Firebase Instance */
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppSettingsController>(context);
    final database = Provider.of<AppDataController>(context);
    final userList = database.getAllUsers;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users", style: GetTextTheme.sf20_regular),
      ),
      body: SafeArea(
          child: userList.isEmpty
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
                      Text("There are no new users available.",
                          style: GetTextTheme.sf14_regular)
                    ],
                  ),
                )
              : GridView.builder(
                  itemCount: userList.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5.w,
                      crossAxisSpacing: 5.h),
                  itemBuilder: (context, i) {
                    final user = userList[i];
                    return InkWell(
                      onTap: () => AppServices.pushTo(
                          context, UserProfileView(user: user)),
                      child: Container(
                        decoration:
                            WidgetDecoration.containerDecoration_1(context),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 60.sp,
                              width: 60.sp,
                              decoration: WidgetDecoration
                                  .circularContainerDecoration_1(context),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200.r),
                                  child: WidgetImplimentor().addNetworkImage(
                                      url: user.image, fit: BoxFit.cover)),
                            ),
                            AppServices.addHeight(10.h),
                            Text(user.username,
                                style: GetTextTheme.sf16_regular),
                            Text(user.phone, style: GetTextTheme.sf12_regular)
                          ],
                        ),
                      ),
                    );
                  })),
    );
  }
}
