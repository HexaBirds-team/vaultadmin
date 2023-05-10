import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/style_sheet.dart';

class CircularShimmerView extends StatelessWidget {
  const CircularShimmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.blackColor.withOpacity(0.1),
      highlightColor: AppColors.blackColor.withOpacity(0.02),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppColors.blackColor),
      ),
    );
  }
}
