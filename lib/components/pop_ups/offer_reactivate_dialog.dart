import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

class OfferReactivateDialog extends StatefulWidget {
  String id;
  OfferReactivateDialog({super.key, required this.id});

  @override
  State<OfferReactivateDialog> createState() => _OfferReactivateDialogState();
}

class _OfferReactivateDialogState extends State<OfferReactivateDialog> {
  String expiryDate =
      DateTime.now().add(const Duration(days: 1)).toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Expiry Date", style: GetTextTheme.sf20_bold),
            AppServices.addHeight(10.h),
            CalendarDatePicker(
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime(2099),
                onDateChanged: (v) =>
                    {setState(() => expiryDate = v.toIso8601String())}),
            // AppServices.addHeight(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Row(
                children: [
                  Expanded(
                      child: ButtonOneExpanded(
                          onPressed: () {
                            AppServices.popView(context);
                          },
                          disableGradient: true,
                          enableColor: true,
                          btnColor: AppColors.grey100,
                          btnTextClr: AppColors.blackColor,
                          btnTextColor: true,
                          btnText: "Cancel")),
                  AppServices.addWidth(10.w),
                  Expanded(
                      child: ButtonOneExpanded(
                          onPressed: () {
                            FirebaseController(context)
                                .reactivateOffer(widget.id, expiryDate);
                          },
                          btnText: "Activate"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
