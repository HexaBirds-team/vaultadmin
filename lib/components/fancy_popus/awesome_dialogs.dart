import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';

class FancyDialogController {
  AwesomeDialog deleteConfirmationDialog(BuildContext context, Function? onOk) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "Confirm Delete",
        desc: "Are you sure you want to remove this item?",
        btnCancelOnPress: () {},
        btnOkOnPress: onOk != null ? () => onOk() : null);
  }

  AwesomeDialog willCloseWindow(BuildContext context, Function onokPress) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: "Warning",
      desc:
          "All the changes you made will be lost. Do you want to close the window",
      btnOkText: "Ok",
      btnCancelText: "Cancel",
      btnCancelOnPress: () {},
      btnOkOnPress: () => onokPress(),
    );
  }

  AwesomeDialog showWillPopMsg(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "Alert!!",
        desc: "Do you want to close the app?",
        btnCancelOnPress: () => {},
        btnOkOnPress: () => SystemNavigator.pop());
  }

  AwesomeDialog logoutConfirmationDialog(BuildContext context, Function? onOk) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.scale,
        title: "Confirm Logout",
        desc: "Are you sure you want to Logout?",
        btnCancelOnPress: () {},
        btnOkOnPress: onOk != null ? () => onOk() : null);
  }

  AwesomeDialog confirmBlockDialog(
      BuildContext context, Function? onOk, String msg) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.scale,
        title: "Confirm Action!",
        btnOkText: "Confirm",
        desc: msg,
        btnCancelOnPress: () {},
        btnOkOnPress: onOk != null ? () => onOk() : null);
  }

  AwesomeDialog confirmInvalidDocument(BuildContext context, Function? onOk) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.scale,
        title: "Confirm Action!",
        btnOkText: "Confirm",
        desc: "Are you sure to mark this document as ivalid.",
        btnCancelOnPress: () {},
        btnOkOnPress: onOk != null ? () => onOk() : null);
  }

  AwesomeDialog approvalPendingDialog(BuildContext context, Function? onOk) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: "Approval Pending",
        desc:
            "Your business profile is pending for approval. Please wait for 2 working days.",
        btnOkOnPress: onOk != null ? () => onOk() : null);
  }
}
