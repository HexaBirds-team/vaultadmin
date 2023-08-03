import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

import '../../../helpers/style_sheet.dart';
import '../../components/expanded_btn.dart';
import '../../components/loaders/full_screen_loader.dart';
import '../../controllers/auth_controller.dart';
import '../../helpers/base_getters.dart';

class AdminRequestManagerView extends StatefulWidget {
  const AdminRequestManagerView({Key? key}) : super(key: key);

  @override
  State<AdminRequestManagerView> createState() =>
      _AdminRequestManagerViewState();
}

class _AdminRequestManagerViewState extends State<AdminRequestManagerView> {
  final _authController = AuthController();

  Future<bool> rebuild() async {
    if (!mounted) return false;
    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final requests = db.getAllProviders
        .where((e) => e.isApproved == GuardApprovalStatus.pending)
        .toList();
    return Scaffold(
        appBar: customAppBar(
            autoLeading: true,
            context: context,
            title: const Text("Manage Requests"),
            action: [
              requests.isEmpty
                  ? const SizedBox()
                  : PopupMenuButton(
                      initialValue: "",
                      onSelected: (value) => _authController.approveAllProfile(
                          requests.toList(), context),
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: "approveAll",
                                child: Text("Approve All")),
                          ],
                      icon: Icon(Icons.more_vert, size: 25.sp))
            ]),
        body: Stack(
          children: [
            requests.isEmpty
                ? RefreshIndicator.adaptive(
                    onRefresh: () =>
                        FirebaseController(context).getGuardsList(),
                    child: ListView(
                      // shrinkWrap: true,
                      children: [
                        AppServices.addHeight(
                            AppServices.getScreenHeight(context) * 0.25),
                        AppServices.getEmptyIcon(
                            "There are no pending requests for new joinee.",
                            "No Data Found")
                      ],
                    ),
                  )
                : RefreshIndicator.adaptive(
                    onRefresh: () =>
                        FirebaseController(context).getGuardsList(),
                    child: ListView.builder(
                        itemCount: requests.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          final profile = requests[i];

                          return InkWell(
                            onTap: () => AppServices.pushTo(context,
                                GuardProfileView(providerDetails: profile)),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 5.h),
                              padding: EdgeInsets.all(10.sp),
                              decoration:
                                  WidgetDecoration.containerDecoration_1(
                                      context,
                                      enableShadow: true),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            child: Image.network(
                                                profile.profileImage,
                                                fit: BoxFit.cover),
                                            //   CachedNetworkImage(
                                            // imageUrl:
                                            //     profile.profileImage,
                                            // fit: BoxFit.cover,
                                            // placeholder: (context, url) =>
                                            //     BoxShimmerView())
                                          )),
                                      AppServices.addWidth(15.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(profile.name,
                                                style: GetTextTheme.sf18_bold),
                                            AppServices.addHeight(5.h),
                                            Text(profile.address,
                                                style:
                                                    GetTextTheme.sf12_regular),
                                            AppServices.addHeight(5.h),
                                            Text(
                                                "qualification : ${profile.qualification}",
                                                style: GetTextTheme.sf14_bold
                                                    .copyWith(
                                                        color: AppColors
                                                            .primary1)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider()),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: SizedBox(
                                              child: ButtonOneExpanded(
                                                  showBorder: true,
                                                  onPressed: () =>
                                                      FancyDialogController()
                                                          .rejectGuardDialog(
                                                        context,
                                                        () async =>
                                                            await _authController
                                                                .rejectProfile(
                                                                    profile.uid,
                                                                    profile,
                                                                    context),
                                                      ).show(),
                                                  btnText: "Reject",
                                                  enableColor: true,
                                                  disableGradient: true,
                                                  btnColor:
                                                      AppColors.whiteColor,
                                                  btnTextColor: true,
                                                  btnTextClr:
                                                      AppColors.primary1))),
                                      AppServices.addWidth(10.w),
                                      Expanded(
                                          child: SizedBox(
                                              child: ButtonOneExpanded(
                                                  onPressed: () =>
                                                      FancyDialogController()
                                                          .approveGuardDialog(
                                                              context,
                                                              () async {
                                                        await _authController
                                                            .approveProfile(
                                                                profile.uid,
                                                                profile,
                                                                context);
                                                        await _authController
                                                            .approveDocuments(
                                                                profile.uid);
                                                      }).show(),
                                                  btnText: "Approve"))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
            db.appLoading ? const FullScreenLoader() : const SizedBox()
          ],
        ));
  }
}
