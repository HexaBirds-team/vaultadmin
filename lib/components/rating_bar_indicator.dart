// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/style_sheet.dart';

class ItemRatingIndicator extends StatelessWidget {
  double rating, itemSize;
  ItemRatingIndicator({Key? key, required this.rating, this.itemSize = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) =>
          const Icon(Icons.star, color: AppColors.primary1),
      itemCount: 5,
      itemSize: itemSize.sp,
      direction: Axis.horizontal,
    );
  }
}
