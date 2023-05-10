import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/pop_ups/add_service_area_dialog.dart';
import 'package:valt_security_admin_panel/components/pop_ups/edit_service_area_dialog.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
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

  getServiceUrl() {
    final path = database.ref("ServiceAreas");
    return path;
  }

  @override
  Widget build(BuildContext context) {
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
          child: FirebaseAnimatedList(
              shrinkWrap: true,
              defaultChild: const OnViewLoader(),
              query: getServiceUrl(),
              itemBuilder: (context, snapshot, animation, i) {
                Map<Object?, Object?> data =
                    snapshot.value as Map<Object?, Object?>;
                return ListTile(
                  title: Text(data['pincode'].toString(),
                      style: GetTextTheme.sf18_medium),
                  trailing: IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => EditServiceAreaDialog(
                              pincode: data['pincode'].toString(),
                              id: snapshot.key.toString())),
                      splashRadius: 20.sp,
                      icon: ImageGradient(
                          image: AppIcons.editIcon,
                          gradient: AppColors.appGradientColor)),
                );
              })),
    );
  }
}
