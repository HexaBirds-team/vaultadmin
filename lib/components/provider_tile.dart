import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../controllers/app_functions.dart';
import '../controllers/widget_creator.dart';
import '../helpers/base_getters.dart';
import '../helpers/style_sheet.dart';

class ProviderTile extends StatefulWidget {
  const ProviderTile({super.key, required this.provider});
  final ProvidersInformationClass provider;

  @override
  State<ProviderTile> createState() => _ProviderTileState();
}

class _ProviderTileState extends State<ProviderTile> {
  Placemark? location;

  decodeLocation() async {
    location = widget.provider.latitude == ""
        ? null
        : await FunctionsController().decodeLocation(
            double.parse(widget.provider.latitude),
            double.parse(widget.provider.longitude));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    decodeLocation();
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: WidgetDecoration.containerDecoration_1(context),
      width: AppServices.getScreenWidth(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80.sp,
            width: 80.sp,
            decoration: WidgetDecoration.circularContainerDecoration_1(context),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: WidgetImplimentor()
                    .addNetworkImage(url: widget.provider.profileImage)),
          ),
          AppServices.addWidth(15.w),
          Expanded(
              child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.provider.name, style: GetTextTheme.sf18_bold),
                AppServices.addHeight(6.h),
                Text(
                    location == null
                        ? "Address : Not Available"
                        : "Address : ${location!.street}, ${location!.subLocality}, ${location!.locality}, ${location!.administrativeArea}",
                    style: GetTextTheme.sf14_regular.copyWith(
                        color: AppColors.blackColor.withOpacity(0.4))),
                AppServices.addHeight(2.h),
                Text("phone : ${widget.provider.phone}",
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
