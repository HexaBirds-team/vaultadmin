import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';
import 'add_banner.dart';
import 'delete_banner_dialog.dart';

class ManageBanners extends StatefulWidget {
  const ManageBanners({super.key});

  @override
  State<ManageBanners> createState() => _ManageBannersState();
}

class _ManageBannersState extends State<ManageBanners> {
  int bannersLength = 0;
  bool isBannersFetch = true;
  bool isLoading = false;

  getUrl() {
    final path = database.ref("Banners");
    return path;
  }

  @override
  void initState() {
    super.initState();
    getBannersLength();
  }

  getBannersLength() async {
    final path = await database.ref("Banners").once();

    if (!mounted) return;
    setState(() {
      bannersLength = path.snapshot.children.length;
      isBannersFetch = false;
    });
    return path.snapshot.children.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Banners", style: GetTextTheme.sf24_bold),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Stack(
                children: [
                  FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: getUrl(),
                      itemBuilder: (context, snapshot, animation, i) {
                        if (i > 0) {
                          isBannersFetch = true;
                        }
                        if (i == 0 && isBannersFetch == true) {
                          getBannersLength();
                        }
                        BannersClass banner = BannersClass.fromBanner(
                            snapshot.value as Map<Object?, Object?>,
                            snapshot.key.toString());
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.sp),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 160.sp,
                                width: AppServices.getScreenWidth(context),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor:
                                        AppColors.blackColor.withOpacity(0.1),
                                    highlightColor:
                                        AppColors.blackColor.withOpacity(0.02),
                                    child:
                                        Container(color: AppColors.blackColor),
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
                                        Text("Delete",
                                            style: GetTextTheme.sf16_bold),
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
                      }),
                  bannersLength == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppIcons.emptyIcon,
                                height: 70.sp,
                              ),
                              AppServices.addHeight(10.h),
                              Text("No Data Found",
                                  style: GetTextTheme.sf18_bold),
                              Text("There are no banners available.",
                                  style: GetTextTheme.sf14_regular)
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            )),
    );
  }
}
