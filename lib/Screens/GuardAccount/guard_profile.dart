// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile_header.dart';
import 'package:valt_security_admin_panel/Screens/managers/image_view.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/auth_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';

import '../../components/custom_appbar.dart';
import '../../components/expanded_btn.dart';
import '../../components/pop_ups/guard_promote_dialog.dart';
import '../../controllers/notification_controller.dart';
import '../../helpers/icons_and_images.dart';
import '../../helpers/style_sheet.dart';
import '../../models/app_models.dart';
import '../../models/enums.dart';

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
  bool loading = false;

  List<DocsClass> documents = [];
  List<GuardServices> services = [];

  List<String> invalidDocuments = [];
  List<String> validDocuments = [];

  @override
  void initState() {
    super.initState();

    getStuff();
  }

  getStuff() async {
    documents = await FirebaseController(context)
        .getGuardDocs(widget.providerDetails.uid);

    var invalidDocs = documents
        .where((element) => element.status == DocumentState.invalid)
        .toList();
    var validDocs = documents
        .where((element) => element.status == DocumentState.valid)
        .toList();

    invalidDocuments.addAll(invalidDocs.map((e) => e.id).toList());
    validDocuments.addAll(validDocs.map((e) => e.id).toList());
    services = await FirebaseController(context)
        .getGuardServices(widget.providerDetails.uid);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final guard = db.getAllProviders
        .firstWhere((e) => e.uid == widget.providerDetails.uid);

    bool isDisabled = guard.isBlocked;
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
              widget.showEditOptions &&
                      widget.providerDetails.isApproved !=
                          GuardApprovalStatus.pending
                  ? IconButton(
                      splashRadius: 25,
                      onPressed: () async {
                        !isDisabled
                            ? FancyDialogController().confirmBlockDialog(
                                context, () async {
                                await FirestoreApiReference.guardApi(guard.uid)
                                    .update(
                                        {"isBlocked": true, "isOnline": false});
                                db.updateProviderBlockStatus(guard.uid, true);
                              },
                                "Are you sure you want to block this guard?").show()
                            : {
                                FirestoreApiReference.guardApi(guard.uid)
                                    .update(
                                        {"isBlocked": false, "isOnline": true}),
                                db.updateProviderBlockStatus(guard.uid, false)
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
            AccountHeader(providerDetails: guard),
            AppServices.addHeight(10.h),
            AppServices.customDivider(5.h),
            Text("Services Offered", style: GetTextTheme.sf16_medium),
            AppServices.addHeight(5.h),
            services.isEmpty
                ? Text(
                    "Guard not updated his/her services.",
                    style: GetTextTheme.sf14_regular,
                  )
                : ListView.builder(
                    itemCount: services.length,
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
                            Text(services[i].title,
                                style: GetTextTheme.sf14_regular)
                          ],
                        ),
                      );
                    }),
            AppServices.customDivider(5.h),
            Text("Description", style: GetTextTheme.sf16_medium),
            AppServices.addHeight(10.h),
            Text(
                guard.description == "" || guard.description == "null"
                    ? "Guard not updated his/her description."
                    : guard.description,
                style: GetTextTheme.sf14_regular),
            AppServices.customDivider(5.h),
            documentNumberTile("ESIC Number", guard.esicNumber),
            AppServices.addHeight(5.h),
            documentNumberTile("PF Number", guard.pfNumber),
            AppServices.addHeight(20.h),
            Text("Documents", style: GetTextTheme.sf16_medium),
            AppServices.addHeight(10.h),
            documents.isEmpty
                ? AppServices.getEmptyIcon(
                    "Guard have not updated his/her documents yet.",
                    "Documents Not Found")
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
                            color: invalidDocuments.contains(document.id)
                                ? AppColors.redColor.withOpacity(0.1)
                                : validDocuments.contains(document.id)
                                    ? AppColors.greenColor.withOpacity(0.1)
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
                                          child: Image.network(document.image,
                                              height: 45.sp,
                                              width: 60.sp,
                                              fit: BoxFit.cover),
                                          // CachedNetworkImage(
                                          //     imageUrl: document.image,
                                          //     height: 45.sp,
                                          //     width: 60.sp,
                                          //     fit: BoxFit.cover),
                                        ),
                                      ),
                                AppServices.addWidth(10.w),
                                document.image == "" ||
                                        widget.showEditOptions == false ||
                                        document.status != DocumentState.posted
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
                                            onSelected: (v) {
                                              onSelect(v, document);
                                            }),
                                      )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            AppServices.addHeight(20.h),
            loading
                ? const OnViewLoader()
                : ((guard.isApproved == GuardApprovalStatus.pending &&
                            documents.isNotEmpty &&
                            validDocuments.length == documents.length) ||
                        documents.isEmpty ||
                        !isChanged
                    ? const SizedBox()
                    : ButtonOneExpanded(
                        onPressed: () {
                          invalidDocuments.isNotEmpty ||
                                  validDocuments.isNotEmpty
                              ? updateDocStatus(guard, documents)
                              : null;
                        },
                        btnText:
                            guard.isApproved == GuardApprovalStatus.pending &&
                                    invalidDocuments.isNotEmpty
                                ? "Raise Objection"
                                : "Update Documents",
                        showBorder: true,
                        disableGradient: true,
                        btnTextColor: true,
                        btnTextClr: invalidDocuments.isNotEmpty ||
                                validDocuments.isNotEmpty
                            ? AppColors.primary1
                            : AppColors.greyColor,
                        borderColor: invalidDocuments.isNotEmpty ||
                                validDocuments.isNotEmpty
                            ? AppColors.primary1
                            : AppColors.greyColor,
                      )),
            AppServices.addHeight(20.h),
            (guard.isApproved == GuardApprovalStatus.approved)
                ? ButtonOneExpanded(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) =>
                              PromoteGuardDialog(guard: guard));
                    },
                    btnText: "Promote",
                  )
                : (guard.isApproved == GuardApprovalStatus.pending &&
                        invalidDocuments.isEmpty)
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ButtonOneExpanded(
                              onPressed: () {
                                FancyDialogController()
                                    .approveGuardDialog(
                                        context, () => approveGuard())
                                    .show();
                              },
                              btnText: "Approve"),
                          AppServices.addHeight(10.h),
                          ButtonOneExpanded(
                            onPressed: () {
                              FancyDialogController()
                                  .rejectGuardDialog(
                                      context, () => rejectGuard(guard))
                                  .show();
                              // rejectGuard(guard);
                            },
                            btnText: "Reject",
                            btnColor: AppColors.grey100,
                            enableColor: true,
                            disableGradient: true,
                            btnTextClr: AppColors.blackColor,
                            btnTextColor: true,
                          ),
                        ],
                      )
                    // PopupMenuButton(
                    //     iconSize: 30.sp,
                    //     padding: const EdgeInsets.all(0),
                    //     onSelected: (value) async {
                    //       if (value == "approve") {
                    //         await approveGuard();
                    //       } else {
                    //         await rejectGuard(guard);
                    //       }
                    //     },
                    //     itemBuilder: (context) => [
                    //           const PopupMenuItem(
                    //               value: "approve", child: Text("Approve")),
                    //           const PopupMenuItem(
                    //               value: "reject", child: Text("Reject")),
                    //         ])
                    : const SizedBox(),
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

  onSelect(DocumentState v, DocsClass document) {
    if (v == DocumentState.valid && !validDocuments.contains(document.id)) {
      if (invalidDocuments.contains(document.id)) {
        invalidDocuments.remove(document.id);
        validDocuments.add(document.id);
      } else {
        validDocuments.add(document.id);
      }
    } else if (v == DocumentState.invalid &&
        !invalidDocuments.contains(document.id)) {
      if (validDocuments.contains(document.id)) {
        validDocuments.remove(document.id);
        invalidDocuments.add(document.id);
      } else {
        invalidDocuments.add(document.id);
      }
    } else {
      null;
    }
    isChanged = true;
    setState(() {});
  }

  updateDocStatus(ProvidersInformationClass guard, List<DocsClass> docs) async {
    loading = true;
    var updatedDocuments = documents
        .where((element) => element.status != DocumentState.posted)
        .toList();

    if (invalidDocuments.isNotEmpty) {
      await NotificationController().guardDocInvalidNotification(guard);
      for (var doc in invalidDocuments) {
        if (!updatedDocuments.any((element) => element.id == doc)) {
          await AuthController().updateDocumentStatus(
              guard.uid, doc, DocumentState.invalid, context);
          int i = documents.indexWhere((element) => element.id == doc);
          documents[i].status = DocumentState.invalid;
        }
      }
      await rejectGuard(guard, sendNotification: false);
    }

    if (validDocuments.isNotEmpty) {
      for (var doc in validDocuments) {
        if (!updatedDocuments.any((element) => element.id == doc)) {
          await AuthController().updateDocumentStatus(
              guard.uid, doc, DocumentState.valid, context);
          int i = documents.indexWhere((element) => element.id == doc);
          documents[i].status = DocumentState.valid;
        }
      }
    }

    if (validDocuments.length == docs.length) {
      FirestoreApiReference.guardApi(guard.uid).update({"isVerified": true});
    }
    isChanged = false;

    loading = false;
    setState(() {});
  }

  approveGuard() async {
    await AuthController().approveProfile(
        widget.providerDetails.uid, widget.providerDetails, context);
    var docs = documents
        .where((element) => element.status != DocumentState.valid)
        .toList();
    for (var document in docs) {
      await AuthController().updateDocumentStatus(widget.providerDetails.uid,
          document.id, DocumentState.valid, context);
      validDocuments.add(document.id);
      invalidDocuments.isNotEmpty ? invalidDocuments.remove(document.id) : null;
    }
    if (documents.isNotEmpty) {
      await FirestoreApiReference.guardApi(widget.providerDetails.uid)
          .update({"isVerified": true});
    }
    setState(() {});
  }

  rejectGuard(ProvidersInformationClass guard,
      {bool sendNotification = true}) async {
    await AuthController().rejectProfile(guard.uid, guard, context,
        sendNotification: sendNotification);
  }
}
