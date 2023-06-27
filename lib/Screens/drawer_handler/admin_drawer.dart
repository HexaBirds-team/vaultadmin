// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/login.dart';
import 'package:valt_security_admin_panel/Screens/managers/Announcements/announcement.dart';
import 'package:valt_security_admin_panel/Screens/managers/Announcements/manage_offers.dart';
import 'package:valt_security_admin_panel/Screens/managers/banners/manage_banners.dart';
import 'package:valt_security_admin_panel/Screens/managers/service_areas.dart';
import 'package:valt_security_admin_panel/Screens/managers/service_manager.dart';
import 'package:valt_security_admin_panel/Screens/managers/transactions/transactions_view.dart';
import 'package:valt_security_admin_panel/controllers/app_settings_controller.dart';

import '../../app_config.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/icons_and_images.dart';
import '../../helpers/style_sheet.dart';
import '../managers/category_manager.dart';
import 'drawer_btn.dart';

class AdminDrawerView extends StatelessWidget {
  const AdminDrawerView({Key? key}) : super(key: key);

  /* App Controllers */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppServices.addHeight(AppBar().preferredSize.height),
        AspectRatio(
          aspectRatio: 16 / 7,
          child: Container(
            alignment: Alignment.center,
            width: AppServices.getScreenWidth(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppConfig.logoBlack, width: 80.sp),
                AppServices.addHeight(10.h),
                Text(AppConfig.appName, style: GetTextTheme.sf22_bold)
              ],
            ),
          ),
        ),
        const Divider(),
        Expanded(
            child: SizedBox(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            children: [
              DrawerButtonView(
                  text: "Manage Category",
                  callback: () =>
                      AppServices.pushTo(context, const AdminCategoryManager()),
                  image: AppIcons.categoryIcon),
              DrawerButtonView(
                  text: "Manage Services",
                  callback: () =>
                      AppServices.pushTo(context, const ServiceManager()),
                  image: AppIcons.serviceIcon),
              DrawerButtonView(
                  text: "Manage Service Area",
                  callback: () =>
                      AppServices.pushTo(context, const ServiceAreaManager()),
                  image: AppIcons.serviceAreaIcon),
              const Divider(),
              DrawerButtonView(
                  text: "Create Announcement/Offer",
                  callback: () =>
                      AppServices.pushTo(context, const CreateAnnouncement()),
                  image: AppIcons.announcementIcon),
              DrawerButtonView(
                  text: "Manage Offers",
                  callback: () =>
                      AppServices.pushTo(context, const OfferManager()),
                  image: AppIcons.offerIcon),
              DrawerButtonView(
                  text: "Manage Banners",
                  callback: () =>
                      AppServices.pushTo(context, const ManageBanners()),
                  image: AppIcons.bannersIcon),
              const Divider(),
              DrawerButtonView(
                  text: "Transactions",
                  callback: () =>
                      AppServices.pushTo(context, const TransactionsView()),
                  image: AppIcons.transactionIcon),
              const Divider(),
              DrawerButtonView(
                  text: "Logout",
                  pop: false,
                  callback: () => logout(context),
                  image: AppIcons.logoutIcon),
            ],
          ),
        )),
      ],
    );
  }

  logout(BuildContext context) async {
    await preference.setBool("isLogin", false);
    AppServices.pushAndRemove(const LoginView(), context);
  }
}
