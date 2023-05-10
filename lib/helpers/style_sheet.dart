// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// all the colors used in the app are stored in AppColors
class AppColors {
  static const Color lightgreyColor = Color(0xffD9D9D9);
  static const Color blackColor = Color(0xff000000);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const grey50 = Color(0xffe8e8e8);
  static const Color primary1 = Color(0xff0096FF);
  static const Color primary2 = Color(0xffE384FF);
  static const Color purpleColor = Color(0xff655DBB);
  static const Color greenColor = Color(0xff00BF13);
  static const Color yellowColor = Color(0xffFFB800);
  static const Color redColor = Color(0xffF44336);
  static const lightgreenColor = Color(0xFFB6E388);
  static const orangeColor = Color(0xFFF76c0F);
  static const Color blueColor = Colors.blue;
  static LinearGradient appGradientColor = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff0336FF), Color(0xffE384FF)]);
}

// all the text themes used in the app are stored in GetTextTheme
class GetTextTheme {
  //Bold Text
  static TextStyle sf40_bold =
      GoogleFonts.roboto(fontSize: 40.sp, fontWeight: FontWeight.w700);
  static TextStyle sf35_bold =
      GoogleFonts.roboto(fontSize: 35.sp, fontWeight: FontWeight.w700);
  static TextStyle sf32_bold =
      GoogleFonts.roboto(fontSize: 32.sp, fontWeight: FontWeight.w700);
  static TextStyle sf30_bold =
      GoogleFonts.roboto(fontSize: 30.sp, fontWeight: FontWeight.w700);
  static TextStyle sf28_bold =
      GoogleFonts.roboto(fontSize: 28.sp, fontWeight: FontWeight.w700);
  static TextStyle sf26_bold =
      GoogleFonts.roboto(fontSize: 26.sp, fontWeight: FontWeight.w700);
  static TextStyle sf24_bold =
      GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w700);
  static TextStyle sf22_bold =
      GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.w700);
  static TextStyle sf20_bold =
      GoogleFonts.roboto(fontSize: 20.sp, fontWeight: FontWeight.w700);
  static TextStyle sf18_bold =
      GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w700);
  static TextStyle sf16_bold =
      GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w700);
  static TextStyle sf14_bold =
      GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w700);
  static TextStyle sf12_bold =
      GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w700);
  static TextStyle sf10_bold =
      GoogleFonts.roboto(fontSize: 10.sp, fontWeight: FontWeight.w700);

  //Medium Text
  static TextStyle sf40_medium =
      GoogleFonts.roboto(fontSize: 40.sp, fontWeight: FontWeight.w500);
  static TextStyle sf35_medium =
      GoogleFonts.roboto(fontSize: 35.sp, fontWeight: FontWeight.w500);
  static TextStyle sf32_medium =
      GoogleFonts.roboto(fontSize: 32.sp, fontWeight: FontWeight.w500);
  static TextStyle sf30_medium =
      GoogleFonts.roboto(fontSize: 30.sp, fontWeight: FontWeight.w500);
  static TextStyle sf28_medium =
      GoogleFonts.roboto(fontSize: 28.sp, fontWeight: FontWeight.w500);
  static TextStyle sf26_medium =
      GoogleFonts.roboto(fontSize: 26.sp, fontWeight: FontWeight.w500);
  static TextStyle sf24_medium =
      GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w500);
  static TextStyle sf22_medium =
      GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.w500);
  static TextStyle sf20_medium =
      GoogleFonts.roboto(fontSize: 20.sp, fontWeight: FontWeight.w500);
  static TextStyle sf18_medium =
      GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle sf16_medium =
      GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle sf14_medium =
      GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle sf12_medium =
      GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle sf10_medium =
      GoogleFonts.roboto(fontSize: 10.sp, fontWeight: FontWeight.w500);

  //Regular Text
  static TextStyle sf40_regular =
      GoogleFonts.roboto(fontSize: 40.sp, fontWeight: FontWeight.w400);
  static TextStyle sf35_regular =
      GoogleFonts.roboto(fontSize: 35.sp, fontWeight: FontWeight.w400);
  static TextStyle sf32_regular =
      GoogleFonts.roboto(fontSize: 32.sp, fontWeight: FontWeight.w400);
  static TextStyle sf30_regular =
      GoogleFonts.roboto(fontSize: 30.sp, fontWeight: FontWeight.w400);
  static TextStyle sf28_regular =
      GoogleFonts.roboto(fontSize: 28.sp, fontWeight: FontWeight.w400);
  static TextStyle sf26_regular =
      GoogleFonts.roboto(fontSize: 26.sp, fontWeight: FontWeight.w400);
  static TextStyle sf24_regular =
      GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w400);
  static TextStyle sf22_regular =
      GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.w400);
  static TextStyle sf20_regular =
      GoogleFonts.roboto(fontSize: 20.sp, fontWeight: FontWeight.w400);
  static TextStyle sf18_regular =
      GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w400);
  static TextStyle sf16_regular =
      GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle sf14_regular =
      GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle sf12_regular =
      GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle sf10_regular =
      GoogleFonts.roboto(fontSize: 10.sp, fontWeight: FontWeight.w400);
}

class WidgetDecoration {
  static BoxDecoration containerDecoration_1(BuildContext context,
          {bool enableShadow = false, bool enableBorder = true}) =>
      BoxDecoration(
          color: AppColors.whiteColor,
          border: enableBorder
              ? Border.all(color: AppColors.blackColor.withOpacity(0.1))
              : null,
          boxShadow: enableShadow ? [addContainerShadow()] : [],
          borderRadius: BorderRadius.circular(10.r));
  static BoxDecoration circularContainerDecoration_1(BuildContext context) =>
      BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.blackColor.withOpacity(0.1)),
          shape: BoxShape.circle);

  static BoxShadow addContainerShadow() => BoxShadow(
      color: AppColors.blackColor.withOpacity(0.05),
      blurRadius: 5,
      offset: const Offset(2, 3));
}
