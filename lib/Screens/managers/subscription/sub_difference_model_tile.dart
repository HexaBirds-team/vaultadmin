// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';
import '../../../models/app_models.dart';

class SubDifferenceModelTile extends StatelessWidget {
  SubDifferenceModel data;
  SubDifferenceModelTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
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
            child: Text(data.pincode, style: GetTextTheme.sf18_medium),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                            child: Text("Basic Plan",
                                style: GetTextTheme.sf16_bold))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(":",
                          textAlign: TextAlign.center,
                          style: GetTextTheme.sf16_bold),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        child: Text("Start from ${data.singleShift.basic}/ day",
                            style: GetTextTheme.sf16_regular),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                            child: Text("Standard Plan",
                                style: GetTextTheme.sf16_bold))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(":",
                          textAlign: TextAlign.center,
                          style: GetTextTheme.sf16_bold),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        child: Text(
                            "Start from ${data.singleShift.standard}/ day",
                            style: GetTextTheme.sf16_regular),
                      ),
                    )
                  ],
                ),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                            child: Text("Premium Plan",
                                style: GetTextTheme.sf16_bold))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(":",
                          textAlign: TextAlign.center,
                          style: GetTextTheme.sf16_bold),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        child: Text(
                            "Start from ${data.singleShift.premium}/ day",
                            style: GetTextTheme.sf16_regular),
                      ),
                    )
                  ],
                ),
               
              ],
            ),
          )
        ],
      ),
    );
  }
}
