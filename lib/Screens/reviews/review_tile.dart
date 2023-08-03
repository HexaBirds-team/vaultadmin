// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class ReviewsTile extends StatelessWidget {
  ReviewsModel review;
  ReviewsTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(1000.r),
                  child: Image.network(review.profileImage,
                      height: 45.sp, width: 45.sp, fit: BoxFit.cover)),
              // CachedNetworkImage(
              //     imageUrl: review.profileImage,
              //     height: 45.sp,
              //     width: 45.sp,
              //     fit: BoxFit.cover)),
              AppServices.addWidth(20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name, style: GetTextTheme.sf16_regular),
                    AppServices.addHeight(5.h),
                    RatingBar(
                        itemSize: 12.sp,
                        itemCount: 5,
                        allowHalfRating: true,
                        initialRating: review.ratings,
                        ignoreGestures: true,
                        ratingWidget: RatingWidget(
                            full: const Icon(Icons.star,
                                color: AppColors.yellowColor),
                            half: const Icon(Icons.star_half,
                                color: AppColors.yellowColor),
                            empty: const Icon(Icons.star_border_outlined,
                                color: AppColors.yellowColor)),
                        onRatingUpdate: (rating) => {}),
                  ],
                ),
              ),
              Text(CheckTimeAgo(review.createdAt).timeAgo(),
                  style: GetTextTheme.sf10_regular)
            ],
          ),
          AppServices.addHeight(10.h),
          Text(review.description, style: GetTextTheme.sf14_regular)
        ],
      ),
    );
  }
}
