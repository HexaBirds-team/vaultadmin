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
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

import 'controllers/app_data_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getStuff();
  }

  getStuff() async {
    final firebase = FirebaseController(context);
    final db = Provider.of<AppDataController>(context, listen: false);
    firebase.getServices();
    await firebase.getUsersList();
    await firebase.getGuardsList();
    firebase.getUserCategory();
    firebase.getBanners();
    await firebase.getComplaints();
    firebase.getSubscriptions();
    await firebase.getServiceArea();
    await firebase.getBookings();
    final data = await FirestoreApiReference.adminPath.get();
    db.setAdminDetails(data.data()!);
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
                      Image.asset(AppConfig.logoWhite,
                          height: 85.sp, width: 93.6.sp, fit: BoxFit.cover),
                      Text('DIAL VAULT\nADMIN',
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
