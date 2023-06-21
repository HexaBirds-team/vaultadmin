// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';
import 'add_banner.dart';
import 'delete_banner_dialog.dart';

class ManageBanners extends StatefulWidget {
  const ManageBanners({super.key});

  @override
  State<ManageBanners> createState() => _ManageBannersState();
}

class _ManageBannersState extends State<ManageBanners> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final banners = db.getBanners;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Banners"),
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        foregroundColor: AppColors.blackColor,
        actions: [
          IconButton(
              splashRadius: 20.r,
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddBannerBottomSheet()),
              icon: const Icon(Icons.add),
              iconSize: 30.sp)
        ],
      ),
      body: SafeArea(
          child: ListView.builder(
              padding: EdgeInsets.all(15.sp),
              itemCount: banners.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final banner = banners[i];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.sp),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 160.sp,
                        width: AppServices.getScreenWidth(context),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.blackColor.withOpacity(0.1),
                            highlightColor:
                                AppColors.blackColor.withOpacity(0.02),
                            child: Container(color: AppColors.blackColor),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          filterQuality: FilterQuality.high,
                          imageUrl: banner.banner,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) => DeleteBannerDialog(
                                  id: banner.bannerId.toString(),
                                  banner: banner.banner)),
                          child: Container(
                            margin: EdgeInsets.only(top: 5.sp),
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(5.r),
                                    right: Radius.circular(2.r)),
                                color: AppColors.whiteColor),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Delete", style: GetTextTheme.sf16_bold),
                                AppServices.addWidth(5.w),
                                const Icon(Icons.delete)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
