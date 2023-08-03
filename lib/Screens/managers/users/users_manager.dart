import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/user_profile_view.dart';

import '../../../../helpers/style_sheet.dart';
import '../../../controllers/app_data_controller.dart';
import '../../../helpers/base_getters.dart';

class AllUserManagerView extends StatefulWidget {
  const AllUserManagerView({super.key});

  @override
  State<AllUserManagerView> createState() => _AllUserManagerViewState();
}

class _AllUserManagerViewState extends State<AllUserManagerView> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDataController>(context);
    final userList = database.getAllUsers;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users", style: GetTextTheme.sf20_regular),
      ),
      body: SafeArea(
          child: userList.isEmpty
              ? AppServices.getEmptyIcon(
                  "There are no new users available.", "No Data Found")
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
                                  child: Image.network(user.image, fit: BoxFit.cover))
                                  // WidgetImplimentor().addNetworkImage(
                                  //     url: user.image, fit: BoxFit.cover)),
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
