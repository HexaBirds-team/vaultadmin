import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/controllers/notification_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../models/enums.dart';

class AuthController {
  Future<bool> approveProfile(String profileId, ProvidersInformationClass guard,
      BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    Map<String, dynamic> data = {
      "title": "Approval Accepted",
      "body": "Your profile has been accepted by admin.",
      "route": "/approved",
      "createdAt": DateTime.now().toIso8601String(),
      "notificationType": "Approval",
      "receiver": guard.uid
    };
    for (var token in guard.tokens) {
      await NotificationController().sendFCM(data, token);
    }
    await NotificationController().uploadNotification("Notifications", data);
    await FirestoreApiReference.guardApi(profileId)
        .update({"isApproved": GuardApprovalStatus.approved.name});
    db.updateApproval(profileId);
    db.setLoader(false);
    return true;
  }

  Future<bool> rejectProfile(String profileId, ProvidersInformationClass guard,
      BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    Map<String, dynamic> data = {
      "title": "Approval Rejected",
      "body": "Your account approval request has been rejected by the Admin.",
      "route": "/rejected",
      "createdAt": DateTime.now().toIso8601String(),
      "notificationType": "Approval",
      "receiver": guard.uid
    };
    for (var token in guard.tokens) {
      await NotificationController().sendFCM(data, token);
    }
    await NotificationController().uploadNotification("Notifications", data);
    await FirestoreApiReference.guardApi(profileId)
        .update({"isApproved": GuardApprovalStatus.rejected.name});
    db.updateRejection(profileId);
    db.setLoader(false);
    return true;
  }

  approveAllProfile(List<String> profiles, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    for (var profileId in profiles) {
      await FirestoreApiReference.guardApi(profileId)
          .update({"isApproved": GuardApprovalStatus.approved.name});
      db.updateApproval(profileId);
    }
    db.setLoader(false);
  }

  Future<void> updateDocumentStatus(String id, String docId,
      DocumentState status, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    await FirestoreApiReference.guardDocumentPath(id)
        .doc(docId)
        .update({"documentState": status.name});
    db.setLoader(false);
  }
}
