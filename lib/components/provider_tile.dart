import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../helpers/base_getters.dart';
import '../helpers/style_sheet.dart';

class ProviderTile extends StatefulWidget {
  const ProviderTile(
      {super.key, required this.provider, this.color = AppColors.whiteColor});
  final ProvidersInformationClass provider;
  final Color color;

  @override
  State<ProviderTile> createState() => _ProviderTileState();
}

class _ProviderTileState extends State<ProviderTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: AppColors.blackColor.withOpacity(0.1)),

          // boxShadow:  [addContainerShadow()] ,
          borderRadius: BorderRadius.circular(10.r)),
      width: AppServices.getScreenWidth(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 80.sp,
              width: 80.sp,
              decoration:
                  WidgetDecoration.circularContainerDecoration_1(context),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.network(widget.provider.profileImage,
                      fit: BoxFit.cover))
              //  WidgetImplimentor()
              //     .addNetworkImage(url: widget.provider.profileImage)),
              ),
          AppServices.addWidth(15.w),
          Expanded(
              child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                        child: Text(widget.provider.name,
                            style: GetTextTheme.sf18_bold)),
                    AppServices.addWidth(4.w),
                    widget.provider.isVerified
                        ? Icon(
                            Icons.verified,
                            size: 18.sp,
                            color: AppColors.blueColor,
                          )
                        : const SizedBox()
                  ],
                ),
                AppServices.addHeight(6.h),
                Text(widget.provider.address,
                    style: GetTextTheme.sf14_regular.copyWith(
                        color: AppColors.blackColor.withOpacity(0.4))),
                AppServices.addHeight(2.h),
                Text("Phone : ${widget.provider.phone}",
                    style: GetTextTheme.sf14_regular),
                AppServices.addHeight(10.h),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
