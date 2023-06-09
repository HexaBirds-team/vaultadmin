import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import '../../components/fancy_popus/awesome_dialogs.dart';
import '../../components/pop_ups/add_category_dialog.dart';
import '../../controllers/firebase_controller.dart';
import '../../controllers/app_data_controller.dart';
import '../../controllers/stream_controller.dart';
import '../../controllers/widget_creator.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/icons_and_images.dart';
import '../../helpers/style_sheet.dart';

class AdminCategoryManager extends StatefulWidget {
  const AdminCategoryManager({Key? key}) : super(key: key);

  @override
  State<AdminCategoryManager> createState() => _AdminCategoryManagerState();
}

class _AdminCategoryManagerState extends State<AdminCategoryManager> {




  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDataController>(context);
    final categoryList = database.getUserCategories;
    return Scaffold(
      appBar: customAppBar(
          autoLeading: true,
          context: context,
          title: const Text("Manage Category"),
          action: [
            IconButton(
                onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => StatefulBuilder(
                        builder: (context, state) =>
                            const AddNewCategoryPopUp())),
                icon: const Icon(Icons.add))
          ]),
      body: SafeArea(
          child: categoryList.isEmpty
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
                      Text("There are not any category present.",
                          style: GetTextTheme.sf14_regular)
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: categoryList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75),
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: WidgetDecoration.containerDecoration_1(
                          context,
                          enableShadow: true),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r)),
                              child: WidgetImplimentor().addNetworkImage(
                                  url: categoryList[i].image,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.sp, vertical: 10.sp),
                            child: Text(categoryList[i].name,
                                textAlign: TextAlign.center,
                                style: GetTextTheme.sf14_regular),
                          )
                        ],
                      ),
                    );
                  })),
    );
  }
}
