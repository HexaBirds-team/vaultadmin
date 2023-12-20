// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';

import '../../controllers/firestore_api_reference.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../simple_textfield.dart';

class AddObjectionCommentDialog extends StatefulWidget {
  String id;
  AddObjectionCommentDialog({super.key, required this.id});

  @override
  State<AddObjectionCommentDialog> createState() =>
      _AddObjectionCommentDialogState();
}

class _AddObjectionCommentDialogState extends State<AddObjectionCommentDialog> {
  final TextEditingController _objectionMsgController = TextEditingController();

  var msg = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Objection Message", style: GetTextTheme.sf20_bold),
            AppServices.addHeight(15.h),
            SimpleTextField(
              name: _objectionMsgController,
              maxLines: 5,
              onChange: (v) => setState(() => msg = v),
              borderRadius: 10.r,
              hint: "Enter message....",
            ),
            AppServices.addHeight(30.h),
            Row(
              children: [
                Expanded(
                    child: ButtonOneExpanded(
                        onPressed: () {
                          AppServices.popView(context);
                        },
                        btnText: "Cancel",
                        enableColor: true,
                        disableGradient: true,
                        btnColor: AppColors.grey100,
                        btnTextClr: AppColors.blackColor,
                        btnTextColor: true)),
                AppServices.addWidth(10.w),
                msg.isNotEmpty
                    ? Expanded(
                        child: ButtonOneExpanded(
                            onPressed: () async {
                              final path =
                                  FirestoreApiReference.guardApi(widget.id);
                              await path.update(
                                  {"comment": _objectionMsgController.text});
                              AppServices.popView(context);
                              MySnackBar.success(
                                  context, "Message added successfully.");
                            },
                            btnText: "Save"))
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
