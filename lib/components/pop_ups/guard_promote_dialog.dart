// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/app_data_controller.dart';
import '../../controllers/firestore_api_reference.dart';
import '../../controllers/snackbar_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../drop_down_btn.dart';

class PromoteGuardDialog extends StatefulWidget {
  ProvidersInformationClass guard;
  PromoteGuardDialog({super.key, required this.guard});

  @override
  State<PromoteGuardDialog> createState() => _PromoteGuardDialogState();
}

class _PromoteGuardDialogState extends State<PromoteGuardDialog> {
  String promotedTo = "basic";

  @override
  void initState() {
    super.initState();
    promotedTo = widget.guard.promotion;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    return Dialog(
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.blackColor.withOpacity(0.3),
                shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  AppServices.popView(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                )),
          ),
          AppServices.addHeight(10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(5.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.guard.name, style: GetTextTheme.sf26_bold),
                AppServices.addHeight(5.h),
                ClipRRect(
                    borderRadius: BorderRadius.circular(1000.r),
                    child: Image.network(widget.guard.profileImage,
                        height: 100.sp, width: 100.sp, fit: BoxFit.cover)),
                AppServices.addHeight(15.h),
                Text("Promote this security guard to :",
                    style: GetTextTheme.sf16_medium),
                AppDropDownButton(
                    items: const ["basic", "standard", "premium"],
                    dropDownValue: promotedTo,
                    onChange: (v) => setState(() => promotedTo = v)),
                AppServices.addHeight(25.h),
                ButtonOneExpanded(
                    onPressed: () async {
                      await FirestoreApiReference.guardApi(widget.guard.uid)
                          .update({"Promotion": promotedTo});
                      db.updateProviderRatings(widget.guard.uid, promotedTo);
                      AppServices.keyboardUnfocus(context);
                      AppServices.popView(context);
                      MySnackBar.success(context,
                          "${widget.guard.name} has been successfully promoted to $promotedTo");
                    },
                    btnText: "Submit")
              ],
            ),
          )
        ],
      ),
    );
  }
}
