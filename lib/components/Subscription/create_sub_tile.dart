// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class CreateSubscriptionTile extends StatelessWidget {
  TextEditingController hourbasic;
  TextEditingController hourStandard;
  TextEditingController hourPremium;
  TextEditingController shiftbasic;
  TextEditingController shiftStandard;
  TextEditingController shiftPremium;
  String title;

  CreateSubscriptionTile(
      {super.key,
      required this.hourbasic,
      required this.hourStandard,
      required this.hourPremium,
      required this.shiftbasic,
      required this.shiftStandard,
      required this.shiftPremium,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppServices.getScreenWidth(context),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppServices.getScreenWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: AppColors.purple50.withOpacity(0.3),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.r))),
            child: Text(title, style: GetTextTheme.sf18_medium),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppServices.addHeight(5.h),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: AppColors.blackColor.withOpacity(0.6))),
                    AppServices.addWidth(15.w),
                    Text("Hourly", style: GetTextTheme.sf18_medium),
                    AppServices.addWidth(15.w),
                    Expanded(
                        child: Divider(
                            color: AppColors.blackColor.withOpacity(0.6))),
                  ],
                ),
                AppServices.addHeight(10.h),
                Row(
                  children: [
                    SubTextField("Basic", hourbasic),
                    AppServices.addWidth(10.w),
                    SubTextField("Standard", hourStandard),
                    AppServices.addWidth(10.w),
                    SubTextField("Premium", hourPremium)
                  ],
                ),
                AppServices.addHeight(20.h),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: AppColors.blackColor.withOpacity(0.6))),
                    AppServices.addWidth(15.w),
                    Text("Shift Basis", style: GetTextTheme.sf18_medium),
                    AppServices.addWidth(15.w),
                    Expanded(
                        child: Divider(
                            color: AppColors.blackColor.withOpacity(0.6))),
                  ],
                ),
                AppServices.addHeight(10.h),
                Row(
                  children: [
                    SubTextField("Basic", shiftbasic),
                    AppServices.addWidth(10.w),
                    SubTextField("Standard", shiftStandard),
                    AppServices.addWidth(10.w),
                    SubTextField("Premium", shiftPremium),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded SubTextField(String title, TextEditingController controller) {
    RegExp expression = RegExp(r'^\d+(?:-\d+)?$');
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: GetTextTheme.sf18_medium),
          AppServices.addHeight(5.h),
          TextFormField(
            controller: controller,
            validator: (v) =>
                DataValidationController().validateTextInput(v, "amount"),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(expression)
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide.none),
              fillColor: AppColors.grey100,
              filled: true,
            ),
          )
        ],
      ),
    );
  }
}
