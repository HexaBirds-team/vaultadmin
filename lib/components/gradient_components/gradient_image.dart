// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A widget to apply gradient to image.
class ImageGradient extends StatelessWidget {
  /// Target image
  final String image;
  double height, width;

  ///Gradient to apply
  final Gradient gradient;

  ImageGradient(
      {super.key,
      required this.image,
      required this.gradient,
      this.height = 20,
      this.width = 20});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bound) {
          return gradient.createShader(bound);
        },
        blendMode: BlendMode.srcATop,
        child: Image.asset(
          image,
          height: height.sp,
          width: width.sp,
          fit: BoxFit.contain,
        ));
  }
}
