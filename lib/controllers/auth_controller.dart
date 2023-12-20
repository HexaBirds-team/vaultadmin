import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../models/enums.dart';

class AuthController {
  Future<bool> approveProfile(String profileId, ProvidersInformationClass guard,
      BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    // await NotificationController().approveProfileNotification(guard);
    await FirestoreApiReference.guardApi(profileId)
        .update({"isApproved": GuardApprovalStatus.approved.name});
    db.updateApproval(profileId);
    db.setLoader(false);
    return true;
  }

  Future<bool> rejectProfile(
    String profileId,
    ProvidersInformationClass guard,
    BuildContext context,
  ) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    // sendNotification
    //     ? await NotificationController().rejectProfileNotification(guard)
    //     : null;
    await FirestoreApiReference.guardApi(profileId)
        .update({"isApproved": GuardApprovalStatus.rejected.name});
    db.updateRejection(profileId);
    db.setLoader(false);
    return true;
  }

  Future<bool> profileObjection(
      ProvidersInformationClass guard, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    // await NotificationController().rejectProfileNotification(guard);

    await FirestoreApiReference.guardApi(guard.uid)
        .update({"isApproved": GuardApprovalStatus.objection.name});
    db.updateObjection(guard.uid);
    db.setLoader(false);
    return true;
  }

  approveDocuments(String guardId) async {
    final documents = await FirestoreApiReference.guardDocumentPath(guardId)
        .where("documentState", isNotEqualTo: DocumentState.valid.name)
        .get();
    if (documents.docs.isNotEmpty) {
      for (var docs in documents.docs) {
        FirestoreApiReference.guardDocumentPath(guardId)
            .doc(docs.id)
            .update({"documentState": DocumentState.valid.name});
      }
    }
  }

  approveAllProfile(
      List<ProvidersInformationClass> profiles, BuildContext context) async {
    FancyDialogController().approveAllGuardDialog(context, () async {
      final db = Provider.of<AppDataController>(context, listen: false);
      db.setLoader(true);
      for (var profile in profiles) {
        await FirestoreApiReference.guardApi(profile.uid)
            .update({"isApproved": GuardApprovalStatus.approved.name});
        await approveDocuments(profile.uid);

        // await NotificationController().approveProfileNotification(profile);
        db.updateApproval(profile.uid);
      }
      db.setLoader(false);
    }).show();
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
