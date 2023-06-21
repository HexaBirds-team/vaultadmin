import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

class Appthemes {
  BuildContext context;
  Appthemes({required this.context});
  Color isDarkMode() {
    if (AppServices.isDarkMode(context)) {
      return AppColors.whiteColor;
    } else {
      return AppColors.blackColor;
    }
  }

  BoxDecoration primaryDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      gradient: AppColors.appGradientColor);

  // Light app theme
  ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.whiteColor,
      primaryColor: AppColors.whiteColor,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(),

      //Button theme
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  AppColors.blackColor.withOpacity(0.5)))),

      //appbar theme
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          foregroundColor: AppColors.blackColor),

      //tab bar theme
      tabBarTheme: const TabBarTheme(
          indicatorColor: AppColors.primary1,
          labelColor: AppColors.blackColor,
          unselectedLabelColor: AppColors.greyColor),

      //Bottom Navigation Bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          selectedItemColor: const Color(0xff0336FF),
          selectedIconTheme: const IconThemeData(color: Color(0xff0336FF)),
          unselectedIconTheme:
              IconThemeData(color: AppColors.blackColor.withOpacity(0.7)),
          unselectedItemColor: AppColors.blackColor.withOpacity(0.7)));

  // dark theme of the app
  ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: const Color(0xff222222),
      scaffoldBackgroundColor: AppColors.blackColor,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(),

      //button theme in dark mode
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all(AppColors.whiteColor.withOpacity(0.6)),
      )),

      //appbar theme
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.blackColor,
          elevation: 0,
          foregroundColor: AppColors.whiteColor),

      //tab bar theme
      tabBarTheme: const TabBarTheme(
          indicatorColor: AppColors.primary1,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.greyColor),

      // dark mode bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.blackColor,
          selectedItemColor: AppColors.primary1,
          selectedIconTheme: IconThemeData(color: AppColors.primary1),
          unselectedIconTheme: IconThemeData(color: AppColors.whiteColor),
          unselectedItemColor: AppColors.whiteColor));
}
