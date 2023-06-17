// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/style_sheet.dart';

class BoxShimmerView extends StatelessWidget {
  Color baseColor, highlighter;
  BoxShimmerView(
      {Key? key,
      this.baseColor = AppColors.blackColor,
      this.highlighter = AppColors.blackColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor.withOpacity(0.1),
      highlightColor: highlighter.withOpacity(0.04),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle, color: AppColors.blackColor),
      ),
    );
  }
}
