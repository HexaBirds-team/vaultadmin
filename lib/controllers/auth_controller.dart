import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../models/enums.dart';

class AuthController {
  Future<bool> approveProfile(String profileId, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);

    await FirestoreApiReference.guardApi(profileId)
        .update({"isApproved": GuardApprovalStatus.approved.name});
    db.updateApproval(profileId);
    db.setLoader(false);
    return true;
  }

  Future<bool> rejectProfile(String profileId, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
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

  Future<void> updateDocumentStatus(DocsClass document, String id, String docId,
      DocumentState status, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    await FirestoreApiReference.guardDocumentPath(id)
        .doc(docId)
        .update({"documentState": status.name});
    db.setLoader(false);
  }
}
