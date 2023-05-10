// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import '../../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';

class DeleteBannerDialog extends StatefulWidget {
  String id;
  String banner;
  DeleteBannerDialog({Key? key, required this.id, required this.banner})
      : super(key: key);

  @override
  State<DeleteBannerDialog> createState() => _DeleteBannerDialogState();
}

class _DeleteBannerDialogState extends State<DeleteBannerDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r), side: BorderSide.none),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to delete this banner?",
                style: GetTextTheme.sf18_bold),
            AppServices.addHeight(10.h),
            isLoading
                ? const Center(child: OnViewLoader())
                : Row(
                    children: [
                      Expanded(
                        child: ButtonOneExpanded(
                            onPressed: () => AppServices.popView(context),
                            btnText: "Cancel",
                            enableColor: true,
                            disableGradient: true,
                            btnColor: AppColors.blackColor.withOpacity(0.2),
                            btnTextColor: true,
                            btnTextClr: AppColors.blackColor),
                      ),
                      AppServices.addWidth(15.w),
                      Expanded(
                          child: SizedBox(
                        child: ButtonOneExpanded(
                            onPressed: () => deleteBanner(), btnText: "Delete"),
                      )),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Future<void> deleteBanner() async {
    setState(() => isLoading = true);
    try {
      await storage.refFromURL(widget.banner).delete();
      await database.ref("Banners/${widget.id}").remove();
      setState(() => isLoading = false);
      AppServices.popView(context);
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
    }
  }
}
