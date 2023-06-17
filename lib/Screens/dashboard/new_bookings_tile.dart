// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/managers/booking/booking_details.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_text.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/icons_and_images.dart';
import '../../helpers/style_sheet.dart';

class NewBookingsTile extends StatelessWidget {
  BookingsClass booking;
  NewBookingsTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          AppServices.pushTo(context, BookingDetailsView(booking: booking)),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(10.sp),
        decoration: WidgetDecoration.containerDecoration_1(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                      imageUrl: AppNetWorkImages.guard,
                      height: 70.h,
                      width: 70.h,
                      fit: BoxFit.cover),
                ),
                AppServices.addWidth(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                                color: booking.bookingStatus.toLowerCase() ==
                                            "pending" ||
                                        booking.bookingStatus.toLowerCase() ==
                                            "cancelled"
                                    ? AppColors.redColor.withOpacity(0.15)
                                    : AppColors.greenColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(booking.bookingStatus,
                                style: GetTextTheme.sf12_regular.copyWith(
                                    color:
                                        booking.bookingStatus.toLowerCase() ==
                                                    "pending" ||
                                                booking.bookingStatus
                                                        .toLowerCase() ==
                                                    "cancelled"
                                            ? AppColors.redColor
                                            : AppColors.greenColor)),
                          ),
                          const Spacer(),
                          Container(
                            height: 22.sp,
                            width: 22.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.greyColor)),
                            child: FittedBox(
                              child: Text(booking.guards.length.toString()),
                            ),
                          ),
                          AppServices.addWidth(5.w),
                          Text(booking.guards.length == 1 ? "Guard" : "Guards",
                              style: GetTextTheme.sf14_regular)
                        ],
                      ),
                      AppServices.addHeight(5.h),
                      Text(booking.category, style: GetTextTheme.sf16_bold),
                      AppServices.addHeight(5.h),
                      GradientText(
                          "${AppServices.getCurrencySymbol}${booking.price}",
                          gradient: AppColors.appGradientColor,
                          style: GetTextTheme.sf14_bold)
                    ],
                  ),
                )
              ],
            ),
            AppServices.addHeight(12.h),
            Text.rich(TextSpan(text: "Booking id : ", children: [
              TextSpan(text: booking.bookingId, style: GetTextTheme.sf14_bold)
            ])),
            AppServices.addHeight(12.h),
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                  color: AppColors.lightgreyColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Date & Time",
                            style: GetTextTheme.sf14_medium
                                .copyWith(color: AppColors.greyColor)),
                      ),
                      AppServices.addWidth(20.w),
                      Expanded(
                          flex: 2,
                          child: Text(
                              "${booking.type == "daily" ? AppServices.splitBookingDate(booking.reportingDate.toString()) : AppServices.formatDate(booking.reportingDate.toString())} At (${booking.reportingTime})",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GetTextTheme.sf14_medium)),
                    ],
                  ),
                  AppServices.addHeight(10.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Address",
                            style: GetTextTheme.sf14_medium
                                .copyWith(color: AppColors.greyColor)),
                      ),
                      AppServices.addWidth(20.w),
                      Expanded(
                          flex: 2,
                          child: Text(booking.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GetTextTheme.sf14_medium)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
