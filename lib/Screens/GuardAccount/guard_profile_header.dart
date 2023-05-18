// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import '../../../../helpers/base_getters.dart';
import '../../../../helpers/style_sheet.dart';

class AccountHeader extends StatelessWidget {
  ProvidersInformationClass providerDetails;
  AccountHeader({super.key, required this.providerDetails});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final category = db.getUserCategories
        .firstWhere((e) => e.categoryId == providerDetails.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppServices.addHeight(15.h),
        ClipRRect(
            borderRadius: BorderRadius.circular(1000.r),
            child: CachedNetworkImage(
                imageUrl: providerDetails.profileImage,
                height: 90.sp,
                width: 90.sp,
                fit: BoxFit.cover)),
        AppServices.addHeight(10.h),
        Text(providerDetails.name, style: GetTextTheme.sf16_bold),
        AppServices.addHeight(5.h),
        Text.rich(TextSpan(
            text: "${category.name} * ",
            style: GetTextTheme.sf12_medium,
            children: [
              TextSpan(
                  text:
                      "${AppServices.experienceCalculation(DateFormat("dd-MM-yyyy").parse(providerDetails.experience))} Experience",
                  style: GetTextTheme.sf12_regular)
            ])),
      ],
    );
  }

  Column detailTile(String title, String subtitle) {
    return Column(
      children: [
        Text(title, style: GetTextTheme.sf16_medium),
        AppServices.addHeight(3.h),
        Text(subtitle, style: GetTextTheme.sf12_regular),
      ],
    );
  }
}
