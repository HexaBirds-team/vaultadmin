// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../helpers/base_getters.dart';
import 'app_data_controller.dart';

class AdminCallbacksController {


  /* Manage Category Callbacks */

  addNewCategoryCallback(
      Map<String, dynamic> data, BuildContext context) async {
    final path = database.ref("Categories").push();
    await path.set(data);
    MySnackBar.success(context, "New category added successfully");
    AppServices.popView(context);
  }

  addNewServiceCallback(Map<String, dynamic> data, BuildContext context) async {
    final path = database.ref("Services").push();
    await path.set(data);
    MySnackBar.success(context, "New Service added successfully");
    AppServices.popView(context);
  }

  updateService(
      Map<String, dynamic> data, String id, BuildContext context) async {
    final path = database.ref("Services/$id");
    await path.update(data);
    MySnackBar.success(context, "Service updated successfully");
    AppServices.popView(context);
  }

  updateSubscription(String amount, String id, BuildContext context) async {
    final path = database.ref("Subscriptions/$id");
    await path.update({'amount': amount});
    MySnackBar.success(context, "Subscription updated successfully");
    AppServices.popView(context);
  }

  removeCategoryCallback(String categoryId) async {
    final path = database.ref("Categories/$categoryId");
    await path.remove();
  }

  getUsersList(BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    try {
      final snapshot = await database.ref("Users").get();
      if (snapshot.exists) {
        final datalist = snapshot.children;
        db.setUsersListData(datalist
            .map((e) => UserInformationClass.fromUser(
                e.value as Map<Object?, Object?>, e.key.toString()))
            .toList());
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    }
  }
}
