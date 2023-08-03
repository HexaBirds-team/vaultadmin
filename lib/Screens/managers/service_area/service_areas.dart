import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/service_area/add_service_area.dart';
import 'package:valt_security_admin_panel/Screens/managers/service_area/edit_service_area.dart';
import 'package:valt_security_admin_panel/components/drop_down_btn.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';

import '../../../controllers/stream_controller.dart';
import '../../../helpers/style_sheet.dart';

class ServiceAreaManager extends StatefulWidget {
  const ServiceAreaManager({Key? key}) : super(key: key);

  @override
  State<ServiceAreaManager> createState() => _ServiceAreaManagerState();
}

class _ServiceAreaManagerState extends State<ServiceAreaManager> {
  final dataStreamer = AppDataStreamer();

  late StreamSubscription<DatabaseEvent> ref;

  // List<ServiceAreaClass> serviceArea = [];

  // @override
  // void initState() {
  //   super.initState();
  //   getStuff();
  // }

  // getStuff() async {
  //   serviceArea = await FirebaseController(context).getServiceArea();
  //   if (!mounted) return;
  //   setState(() {});
  // }

  String searchValue = "All";

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final serviceArea = searchValue == "All"
        ? db.getserviceArea
        : db.getserviceArea
            .where((element) =>
                element.city.trim().toLowerCase() ==
                searchValue.trim().toLowerCase())
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Service Area"),
        actions: [
          IconButton(
              onPressed: () =>
                  AppServices.pushTo(context, AddServiceAreaView()),
              icon: const Icon(Icons.add))
        ],
        bottom: PreferredSize(
            preferredSize: Size(AppServices.getScreenWidth(context), 50.h),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AppDropDownButton(
                    items: [
                      "All",
                      ...db.getserviceArea.map((e) {
                        var a = e.city.split("");
                        a[0] = a[0].toUpperCase();
                        return a.join(); 
                      }).toSet().toList()
                    ],
                    dropDownValue: searchValue,
                    onChange: (v) => setState(() => searchValue = v)))),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: serviceArea.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(serviceArea[i].pincode.toString(),
                      style: GetTextTheme.sf18_medium),
                  subtitle: Text(
                    serviceArea[i].city,
                  ),
                  trailing: IconButton(
                      onPressed: () => AppServices.pushTo(context,
                          EditServiceAreaView(serviceData: serviceArea[i])),
                      splashRadius: 20.sp,
                      icon: ImageGradient(
                          image: AppIcons.editIcon,
                          gradient: AppColors.appGradientColor)),
                );
              })),
    );
  }
}
