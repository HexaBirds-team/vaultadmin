import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/pop_ups/add_service_area_dialog.dart';
import 'package:valt_security_admin_panel/components/pop_ups/edit_service_area_dialog.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';

import '../../controllers/stream_controller.dart';
import '../../helpers/style_sheet.dart';

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

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final serviceArea = db.getserviceArea;
    return Scaffold(
      appBar: customAppBar(
          autoLeading: true,
          context: context,
          title: const Text("Manage Service Area"),
          action: [
            IconButton(
                onPressed: () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => StatefulBuilder(
                        builder: (context, state) =>
                            const AddServiceAreaDialog())),
                icon: const Icon(Icons.add))
          ]),
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
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => EditServiceAreaDialog(
                              pincode: serviceArea[i].pincode.toString(),
                              id: serviceArea[i].id.toString(),
                              city: serviceArea[i].city.toString())),
                      splashRadius: 20.sp,
                      icon: ImageGradient(
                          image: AppIcons.editIcon,
                          gradient: AppColors.appGradientColor)),
                );
              })),
    );
  }
}
