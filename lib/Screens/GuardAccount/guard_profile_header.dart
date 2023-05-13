// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import '../../../../helpers/base_getters.dart';
import '../../../../helpers/style_sheet.dart';

class AccountHeader extends StatelessWidget {
  ProvidersInformationClass providerDetails;
  AccountHeader({super.key, required this.providerDetails});

  @override
  Widget build(BuildContext context) {
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
            text: "Gunman * ",
            style: GetTextTheme.sf12_medium,
            children: [
              TextSpan(
                  text: "${providerDetails.experience} Year Experience",
                  style: GetTextTheme.sf12_regular)
            ])),
        // AppServices.addHeight(20.h),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     detailTile("3.2", "Rating"),
        //     detailTile("102", "Reviews"),
        //     detailTile("32", "Yrs Old")
        //   ],
        // )
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
