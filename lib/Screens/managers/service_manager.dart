// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_icon.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/pop_ups/add_service_dialog.dart';
import 'package:valt_security_admin_panel/components/pop_ups/edit_service_dialog.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../components/expanded_btn.dart';
import '../../controllers/stream_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class ServiceManager extends StatefulWidget {
  const ServiceManager({Key? key}) : super(key: key);

  @override
  State<ServiceManager> createState() => _ServiceManagerState();
}

class _ServiceManagerState extends State<ServiceManager> {
  final dataStreamer = AppDataStreamer();

  late StreamSubscription<DatabaseEvent> ref;

  getServiceUrl() {
    final path = database.ref("Services");
    return path;
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          autoLeading: true,
          context: context,
          title: const Text("Manage Services"),
          action: [
            IconButton(
                onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => StatefulBuilder(
                        builder: (context, state) => const AddServiceDialog())),
                icon: const Icon(Icons.add))
          ]),
      body: SafeArea(
          child: FirebaseAnimatedList(
              shrinkWrap: true,
              defaultChild: const OnViewLoader(),
              query: getServiceUrl(),
              itemBuilder: (context, snapshot, animation, i) {
                ServiceClass data = ServiceClass.fromService(
                    snapshot.value as Map<Object?, Object?>,
                    snapshot.key.toString());
                return ListTile(
                  title: Text(data.name, style: GetTextTheme.sf18_medium),
                  leading: Container(
                    padding: EdgeInsets.all(15.sp),
                    decoration: BoxDecoration(
                        gradient: AppColors.appGradientColor,
                        shape: BoxShape.circle),
                    child: Text(data.name[0],
                        style: GetTextTheme.sf20_bold
                            .copyWith(color: AppColors.whiteColor)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  EditServiceDialog(service: data)),
                          splashRadius: 20.sp,
                          icon: ImageGradient(
                              image: AppIcons.editIcon,
                              gradient: AppColors.appGradientColor)),
                      IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        side: BorderSide.none),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              "Are you sure you want to delete this service?",
                                              style: GetTextTheme.sf18_bold),
                                          AppServices.addHeight(10.h),
                                          loading
                                              ? const Center(
                                                  child: OnViewLoader())
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: ButtonOneExpanded(
                                                          onPressed: () =>
                                                              AppServices
                                                                  .popView(
                                                                      context),
                                                          btnText: "Cancel",
                                                          enableColor: true,
                                                          disableGradient: true,
                                                          btnColor: AppColors
                                                              .blackColor
                                                              .withOpacity(0.2),
                                                          btnTextColor: true,
                                                          btnTextClr: AppColors
                                                              .blackColor),
                                                    ),
                                                    AppServices.addWidth(15.w),
                                                    Expanded(
                                                        child: SizedBox(
                                                      child: ButtonOneExpanded(
                                                          onPressed: () =>
                                                              deleteService(data
                                                                  .serviceId),
                                                          btnText: "Delete"),
                                                    )),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  )),
                          splashRadius: 20.sp,
                          icon: GradientIcon(
                              Icons.delete, 25, AppColors.appGradientColor)),
                    ],
                  ),
                );
              })),
    );
  }

  Future<void> deleteService(String id) async {
    setState(() => loading = true);
    try {
      await database.ref("Services/$id").remove();
      setState(() => loading = false);
      AppServices.popView(context);
    } catch (e) {
      setState(() => loading = false);
      print(e);
    }
  }
}
