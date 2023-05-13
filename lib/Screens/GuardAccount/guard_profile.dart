// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile_header.dart';
import 'package:valt_security_admin_panel/Screens/managers/image_view.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/auth_controller.dart';
import 'package:valt_security_admin_panel/controllers/notification_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';

import '../../components/custom_appbar.dart';
import '../../components/expanded_btn.dart';
import '../../helpers/icons_and_images.dart';
import '../../helpers/style_sheet.dart';
import '../../models/app_models.dart';
import '../../models/enums.dart';
import 'package:rating_dialog/rating_dialog.dart';

class GuardProfileView extends StatefulWidget {
  bool showEditOptions;
  ProvidersInformationClass providerDetails;
  GuardProfileView(
      {super.key, required this.providerDetails, this.showEditOptions = true});

  @override
  State<GuardProfileView> createState() => _GuardProfileViewState();
}

class _GuardProfileViewState extends State<GuardProfileView> {
  bool isChanged = false;
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isDisabled = widget.providerDetails.isBlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final documents = widget.providerDetails.documents;
    return WillPopScope(
      onWillPop: () async {
        if (isChanged) {
          await FancyDialogController().willCloseWindow(context, () {
            Navigator.pop(context);
          }).show();
          return false;
        } else {
          AppServices.popView(context);
          return true;
        }
      },
      child: Scaffold(
        appBar: customAppBar(
            context: context,
            title: const SizedBox(),
            autoLeading: true,
            action: [
              widget.showEditOptions
                  ? IconButton(
                      splashRadius: 25,
                      onPressed: () async {
                        !isDisabled
                            ? FancyDialogController().confirmBlockDialog(
                                context, () async {
                                final path = database.ref(
                                    "Providers/${widget.providerDetails.uid}");
                                await path.update(
                                    {"isBlocked": true, "isOnline": false});
                                setState(() => isDisabled = true);
                              },
                                "Are you sure you want to block this guard?").show()
                            : {
                                await database
                                    .ref(
                                        "Providers/${widget.providerDetails.uid}")
                                    .update({"isBlocked": false}),
                                setState(() => {isDisabled = false})
                              };
                      },
                      icon: ImageGradient(
                        image: AppIcons.powerIcon,
                        gradient: isDisabled
                            ? const LinearGradient(colors: [
                                AppColors.yellowColor,
                                AppColors.redColor
                              ])
                            : const LinearGradient(colors: [
                                Color.fromARGB(255, 98, 204, 160),
                                AppColors.greenColor
                              ]),
                        height: 28,
                        width: 28,
                      ))
                  : const SizedBox(),
            ]),
        body: SafeArea(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          children: [
            AccountHeader(providerDetails: widget.providerDetails),
            AppServices.addHeight(10.h),
            AppServices.customDivider(5.h),
            Text("Services Offered", style: GetTextTheme.sf16_medium),
            AppServices.addHeight(5.h),
            ListView.builder(
                itemCount: widget.providerDetails.services.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Image.asset(AppIcons.bulletIcon,
                            height: 10.sp, width: 10.sp),
                        AppServices.addWidth(15.w),
                        Text(widget.providerDetails.services[i].title,
                            style: GetTextTheme.sf14_regular)
                      ],
                    ),
                  );
                }),
            AppServices.customDivider(5.h),
            Text("Description", style: GetTextTheme.sf16_medium),
            AppServices.addHeight(10.h),
            Text(
                widget.providerDetails.description == ""
                    ? "Not Available"
                    : widget.providerDetails.description,
                style: GetTextTheme.sf14_regular),
            AppServices.customDivider(5.h),
            documentNumberTile("ESIC Number", ""),
            AppServices.addHeight(5.h),
            documentNumberTile("PF Number", ""),
            AppServices.addHeight(20.h),
            Text("Documents", style: GetTextTheme.sf16_medium),
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
                        Text("Documents are not available for the guard.",
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
                            color: document.status == DocumentState.invalid
                                ? AppColors.redColor.withOpacity(0.1)
                                : AppColors.whiteColor,
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
                                document.image == "" ||
                                        widget.showEditOptions == false
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 30.sp,
                                        width: 30.sp,
                                        child: PopupMenuButton<DocumentState>(
                                            padding: const EdgeInsets.all(0),
                                            initialValue: document.status,
                                            itemBuilder: (context) =>
                                                DocumentState.values
                                                    .where((element) =>
                                                        element !=
                                                        DocumentState.posted)
                                                    .map((e) => PopupMenuItem(
                                                        value: e,
                                                        child: Text(e.name)))
                                                    .toList(),
                                            onSelected: (v) async {
                                              Map<String, dynamic> data = {
                                                "title":
                                                    "Invalid KYC documents",
                                                "body":
                                                    "${document.name} of your KYC documents are marked as invalid. Please update your documents to prevent your profile from being blocked.",
                                                "route": "",
                                                "createdAt": DateTime.now()
                                                    .toIso8601String(),
                                                "notificationType": "KYC",
                                                "receiver":
                                                    widget.providerDetails.uid
                                              };
                                              v == DocumentState.invalid
                                                  ? FancyDialogController()
                                                      .confirmInvalidDocument(
                                                          context, () async {
                                                      await NotificationController()
                                                          .sendFCM(
                                                              data,
                                                              widget
                                                                  .providerDetails
                                                                  .token);
                                                      await NotificationController()
                                                          .uploadNotification(
                                                              "Notifications",
                                                              data);
                                                      await AuthController()
                                                          .updateDocumentStatus(
                                                              document,
                                                              widget
                                                                  .providerDetails
                                                                  .uid,
                                                              i.toString(),
                                                              v,
                                                              context)
                                                          .then((value) =>
                                                              setState(() {
                                                                document
                                                                    .status = v;
                                                              }));
                                                    }).show()
                                                  : {
                                                      await AuthController()
                                                          .updateDocumentStatus(
                                                              document,
                                                              widget
                                                                  .providerDetails
                                                                  .uid,
                                                              i.toString(),
                                                              v,
                                                              context)
                                                          .then((value) =>
                                                              setState(() {
                                                                document
                                                                    .status = v;
                                                              })),
                                                    };
                                            }),
                                      )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            AppServices.addHeight(20.h),
            ButtonOneExpanded(
              onPressed: () {
                final dialog = RatingDialog(
                    initialRating: widget.providerDetails.rating,
                    enableComment: false,
                    title: Text(widget.providerDetails.name,
                        textAlign: TextAlign.center,
                        style: GetTextTheme.sf26_bold),
                    submitButtonText: "Submit",
                    image: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.whiteColor,
                      backgroundImage:
                          NetworkImage(widget.providerDetails.profileImage),
                    ),
                    starSize: 35.sp,
                    message: Text("Set the ratings for this Security Guard",
                        textAlign: TextAlign.center,
                        style: GetTextTheme.sf16_medium),
                    onSubmitted: (v) async {
                      await database
                          .ref("Providers/${widget.providerDetails.uid}")
                          .update({"Ratings": v.rating});
                    });
                showDialog(context: context, builder: (context) => dialog);
              },
              btnText: "Set Ratings",
            ),
            AppServices.addHeight(20.h),
          ],
        )),
      ),
    );
  }

  Row documentNumberTile(String docName, String docNumber) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(docName, style: GetTextTheme.sf16_medium),
        Text(docNumber == "" ? "Not Available" : docNumber,
            style: GetTextTheme.sf14_regular),
      ],
    );
  }
}
