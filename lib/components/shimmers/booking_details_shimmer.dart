// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class BookingDetailsShimmer extends StatelessWidget {
  Color baseColor, highlighter;
  BookingDetailsShimmer(
      {super.key,
      this.baseColor = AppColors.blackColor,
      this.highlighter = AppColors.blackColor});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15.sp),
      shrinkWrap: true,
      children: [
        TextShimmer(baseColor: baseColor, highlighter: highlighter),
        AppServices.addHeight(10.h),
        const ListTileShimmer(),
        AppServices.addHeight(20.h),
        TextShimmer(baseColor: baseColor, highlighter: highlighter),
        AppServices.addHeight(10.h),
        Container(
            padding: EdgeInsets.all(15.sp),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.2),
                      offset: const Offset(0, 0),
                      blurRadius: 4)
                ],
                borderRadius: BorderRadius.circular(10.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextShimmer(
                        baseColor: baseColor,
                        highlighter: highlighter,
                        width: 100),
                    AppServices.addWidth(10.w),
                    TextShimmer(
                      baseColor: baseColor,
                      highlighter: highlighter,
                    )
                  ],
                ),
                AppServices.addHeight(10.h),
                const Divider(),
                AppServices.addHeight(10.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 120),
                AppServices.addHeight(10.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 180),
                AppServices.addHeight(5.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 95),
                AppServices.addHeight(20.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextShimmer(
                              baseColor: baseColor,
                              highlighter: highlighter,
                              width: 110),
                          AppServices.addHeight(10.h),
                          TextShimmer(
                              baseColor: baseColor, highlighter: highlighter),
                          AppServices.addHeight(5.h),
                          TextShimmer(
                              baseColor: baseColor,
                              highlighter: highlighter,
                              width: 80),
                        ],
                      ),
                    ),
                    AppServices.addWidth(10.w),
                    const CircularContainerShimmer()
                  ],
                ),
                AppServices.addHeight(20.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 100),
                AppServices.addHeight(10.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 60),
                AppServices.addHeight(5.h),
                TextShimmer(
                    baseColor: baseColor, highlighter: highlighter, width: 115),
              ],
            )),
        AppServices.addHeight(20.h),
        TextShimmer(baseColor: baseColor, highlighter: highlighter),
        AppServices.addHeight(10.h),
        const ListTileShimmer(),
      ],

      // Container(
      //   decoration: const BoxDecoration(
      //       shape: BoxShape.rectangle, color: AppColors.blackColor),
      // ),
    );
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      tileColor: AppColors.blackColor.withOpacity(0.07),
      leading: const CircularContainerShimmer(),
      title: Shimmer.fromColors(
          baseColor: AppColors.blackColor.withOpacity(0.1),
          highlightColor: AppColors.blackColor.withOpacity(0.02),
          child: Row(
            children: [
              Container(
                  height: 8.h,
                  width: AppServices.getScreenWidth(context) * 0.6,
                  color: AppColors.blackColor),
            ],
          )),
      subtitle: Shimmer.fromColors(
          baseColor: AppColors.blackColor.withOpacity(0.1),
          highlightColor: AppColors.blackColor.withOpacity(0.02),
          child: Row(
            children: [
              Container(
                  height: 8.h, width: 140.sp, color: AppColors.blackColor),
            ],
          )),
    );
  }
}

class CircularContainerShimmer extends StatelessWidget {
  const CircularContainerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.blackColor.withOpacity(0.1),
      highlightColor: AppColors.blackColor.withOpacity(0.02),
      child: Container(
          height: 50.sp,
          width: 50.sp,
          decoration: const BoxDecoration(
              color: AppColors.blackColor, shape: BoxShape.circle)),
    );
  }
}

class TextShimmer extends StatelessWidget {
  const TextShimmer(
      {super.key,
      required this.baseColor,
      required this.highlighter,
      this.width = 200});

  final Color baseColor;
  final Color highlighter;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor.withOpacity(0.1),
        highlightColor: highlighter.withOpacity(0.04),
        child: Row(
          children: [
            Container(height: 8.h, width: width.w, color: AppColors.blackColor),
          ],
        ));
  }
}
