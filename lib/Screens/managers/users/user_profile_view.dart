// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../components/fancy_popus/awesome_dialogs.dart';
import '../../../components/gradient_components/gradient_image.dart';
import '../../../helpers/base_getters.dart';
import '../image_view.dart';

class UserProfileView extends StatefulWidget {
  UserInformationClass user;
  UserProfileView({super.key, required this.user});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  bool isDisabled = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.user.username;
      _phoneController.text = widget.user.phone;
      isDisabled = widget.user.isBlocked;
    });
  }

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    final documents = widget.user.documents;
    final user = widget.user;
    return Scaffold(
      appBar: customAppBar(
          context: context,
          title: const Text("Update User"),
          autoLeading: true,
          action: [
            IconButton(
                splashRadius: 25,
                onPressed: () async {
                  !isDisabled
                      ? FancyDialogController().confirmBlockDialog(context,
                          () async {
                          final path = database.ref("Users/${widget.user.uid}");
                          await path.update({"isBlocked": true});
                          setState(() => isDisabled = true);
                        }, "Are you sure you want to block this user?").show()
                      : {
                          await database
                              .ref("Users/${widget.user.uid}")
                              .update({"isBlocked": false}),
                          setState(() => {isDisabled = false})
                        };
                },
                icon: ImageGradient(
                  image: AppIcons.powerIcon,
                  gradient: isDisabled
                      ? const LinearGradient(
                          colors: [AppColors.yellowColor, AppColors.redColor])
                      : const LinearGradient(colors: [
                          Color.fromARGB(255, 98, 204, 160),
                          AppColors.greenColor
                        ]),
                  height: 28,
                  width: 28,
                ))
          ]),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000.r),
                  child: CachedNetworkImage(
                      imageUrl: widget.user.image,
                      height: 120.sp,
                      width: 120.sp,
                      fit: BoxFit.cover)),
            ),
            AppServices.addHeight(25.h),
            detailTile("Username", user.username),
            detailTile("Contact No.", user.phone),
            detailTile(
                "Gender", user.gender == '' ? "Not Available" : user.gender),
            detailTile("Date Of Birth",
                user.dateOfBirth == "" ? "Not Available" : user.dateOfBirth),
            AppServices.customDivider(5.h),
            Text("Documents", style: GetTextTheme.sf20_bold),
            AppServices.addHeight(5.h),
            detailTile("Aadhar No.",
                user.aadharNo == "" ? "Not Available" : user.aadharNo),
            AppServices.addHeight(10.h),
            documents.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 40.h),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppIcons.emptyIcon,
                          height: 70.sp,
                        ),
                        AppServices.addHeight(10.h),
                        Text("No Data Found", style: GetTextTheme.sf18_bold),
                        Text("Documents are not available for the user.",
                            style: GetTextTheme.sf14_regular)
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, i) {
                      DocsClass document = documents[i];

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.sp),
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                                color: AppColors.blackColor.withOpacity(0.1)),
                            boxShadow: [WidgetDecoration.addContainerShadow()],
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ImageGradient(
                                    image: AppIcons.documentsIcon,
                                    gradient: AppColors.appGradientColor),
                                AppServices.addWidth(15.w),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Document Name",
                                        style: GetTextTheme.sf14_regular
                                            .copyWith(
                                                color: AppColors.greyColor)),
                                    Text(document.name,
                                        style: GetTextTheme.sf16_medium),
                                  ],
                                )),
                                document.image == ""
                                    ? const Text("Not Available")
                                    : InkWell(
                                        onTap: () => AppServices.pushTo(
                                            context, ImageView(doc: document)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: CachedNetworkImage(
                                              imageUrl: document.image,
                                              height: 45.sp,
                                              width: 60.sp,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                AppServices.addWidth(10.w),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
          ],
        ),
      )),
    );
  }

  Padding detailTile(String title, String detail) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GetTextTheme.sf18_medium),
          Text(detail, style: GetTextTheme.sf18_regular)
        ],
      ),
    );
  }
}
