// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/BottomNavBar/bottom_nav_bar.dart';
import 'package:valt_security_admin_panel/Screens/login.dart';
import 'package:valt_security_admin_panel/app_config.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_settings_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

import 'controllers/app_data_controller.dart';
import 'controllers/app_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _functions = FunctionsController();

  @override
  void initState() {
    super.initState();
    getStuff();
  }

  getStuff() async {
    final db = Provider.of<AppDataController>(context, listen: false);
    await _functions.getProviders(context);
    await _functions.getUserCategory(context);
    final data = await database.ref("Admin").get();
    db.setAdminDetails(data.value as Map<Object?, Object?>);
    bool islogin = await preference.getBool("isLogin") ?? false;
    AppServices.pushAndRemove(
        islogin ? BottomNavBar() : const LoginView(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: AppServices.getScreenHeight(context),
        width: AppServices.getScreenWidth(context),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.splashBg), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(AppConfig.appLogo,
                          height: 85.sp, width: 93.6.sp, fit: BoxFit.cover),
                      Text('VAULT\nSECURITIES',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jockeyOne(
                              height: 1.0,
                              color: AppColors.whiteColor,
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Admin Panel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jockeyOne(
                              color: AppColors.whiteColor,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w400)),
                      AppServices.addHeight(25.h),
                      const OnViewLoader()
                    ],
                  ))),
              const Text("Loading data...",
                  style: TextStyle(color: AppColors.whiteColor)),
              AppServices.addHeight(10.h)
            ],
          ),
        ),
      ),
    );
  }
}
