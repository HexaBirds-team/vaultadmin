import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/components/pop_ups/offer_reactivate_dialog.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';

import '../../../components/expanded_btn.dart';
import '../../../components/gradient_components/gradient_text.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';

class OfferManager extends StatefulWidget {
  const OfferManager({super.key});

  @override
  State<OfferManager> createState() => _OfferManagerState();
}

class _OfferManagerState extends State<OfferManager> {
  bool loading = false;

  getOffers() async {
    FirebaseController(context).getOffers(context);

    setState(() {});
  }

  isOfferActive(String expiryDate) {
    DateTime expiredAt = DateTime.parse(expiryDate);
    DateTime now = DateTime.now();
    return expiredAt.difference(now).inHours > 0;
  }

  String filterBy = "all";

  filterOffers(String filterBy, AppDataController db) {
    switch (filterBy) {
      case "active":
        return db.getOffers.where((element) {
          bool isActive = isOfferActive(element.expiryDate);
          return isActive && !element.isDisabled;
        }).toList();

      case "disabled":
        return db.getOffers.where((element) => element.isDisabled).toList();

      case "expired":
        return db.getOffers.where((element) {
          bool isActive = isOfferActive(element.expiryDate);
          return !isActive;
        }).toList();

      default:
        return db.getOffers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final offers = filterOffers(filterBy, db);
    // isOfferActive("2023-08-10T00:00:00.000");
    return Scaffold(
        appBar: customAppBar(
            context: context,
            title: const Text("Manage Offers"),
            autoLeading: true,
            action: <Widget>[
              loading
                  ? const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator.adaptive()))
                  : const SizedBox(),
              AppServices.addWidth(20.w),
              PopupMenuButton(
                  initialValue: filterBy,
                  icon: const Icon(Icons.filter_alt),
                  onSelected: (v) => setState(() => filterBy = v),
                  itemBuilder: (context) => [
                        const PopupMenuItem(value: "all", child: Text("All")),
                        const PopupMenuItem(
                            value: "active", child: Text("Active")),
                        const PopupMenuItem(
                            value: "disabled", child: Text("Disabled")),
                        const PopupMenuItem(
                            value: "expired", child: Text("Expired")),
                      ])
            ]),
        body: offers.isEmpty
            ? RefreshIndicator.adaptive(
                onRefresh: () => getOffers(),
                child: ListView(
                  padding: EdgeInsets.all(20.sp),
                  // shrinkWrap: true,
                  children: [
                    AppServices.addHeight(
                        AppServices.getScreenHeight(context) * 0.25),
                    AppServices.getEmptyIcon(
                        "You have not added any offers yet. Please add some offers.",
                        "Offers Not Found")
                  ],
                ),
              )
            : RefreshIndicator.adaptive(
                onRefresh: () => getOffers(),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  children: [
                    ...List.generate(offers.length, (index) {
                      var offer = offers[index];
                      bool isActive = isOfferActive(offer.expiryDate);
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(10.sp),
                        decoration:
                            WidgetDecoration.containerDecoration_1(context)
                                .copyWith(
                                    color: offer.isDisabled || !isActive
                                        ? AppColors.redColor.withOpacity(0.1)
                                        : AppColors.whiteColor,
                                    border: Border.all(
                                        color: offer.isDisabled || !isActive
                                            ? AppColors.redColor
                                            : AppColors.blackColor
                                                .withOpacity(0.1))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8.sp),
                                  height: 50.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                      gradient: AppColors.appGradientColor,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Text(
                                      "${offer.isRupeesDiscount ? AppServices.getCurrencySymbol : ""}${offer.discount}${offer.isRupeesDiscount ? "" : "%"}",
                                      style: GetTextTheme.sf18_bold.copyWith(
                                          color: AppColors.whiteColor)),
                                ),
                                AppServices.addWidth(10.w),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(offer.title,
                                          style: GetTextTheme.sf18_medium),
                                      AppServices.addHeight(2.h),
                                      Text(offer.offerCode,
                                          style: GetTextTheme.sf14_medium
                                              .copyWith(
                                                  color: AppColors.blackColor
                                                      .withOpacity(0.3)))
                                    ],
                                  ),
                                ),
                                AppServices.addWidth(10.w),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    offer.isPromoCode
                                        ? Text("Promo Code",
                                            style: GetTextTheme.sf12_regular
                                                .copyWith(
                                                    color:
                                                        AppColors.greenColor))
                                        : const SizedBox(),
                                    GradientText(
                                        DateFormat("dd MMM yyyy").format(
                                            DateTime.parse(offer.expiryDate)),
                                        gradient: AppColors.appGradientColor,
                                        style: GetTextTheme.sf18_medium),
                                  ],
                                )
                              ],
                            ),
                            AppServices.addHeight(10.h),
                            Text(offer.description,
                                style: GetTextTheme.sf16_medium
                                    .copyWith(color: AppColors.greyColor)),
                            AppServices.addHeight(10.h),
                            Row(
                              children: [
                                isActive
                                    ? Expanded(
                                        child: ButtonOneExpanded(
                                            onPressed: () {
                                              offer.isDisabled
                                                  ? FirebaseController(context)
                                                      .updateOfferIsDisabled(
                                                          false, offer.id)
                                                  : FancyDialogController()
                                                      .disableConfirmationDialog(
                                                          context, () {
                                                      FirebaseController(
                                                              context)
                                                          .updateOfferIsDisabled(
                                                              true, offer.id);
                                                    }).show();
                                            },
                                            btnText: offer.isDisabled
                                                ? "Enable"
                                                : "Disable",
                                            borderColor: AppColors.greyColor
                                                .withOpacity(0.6),
                                            btnColor: AppColors.transparent,
                                            enableColor: true,
                                            btnTextColor: true,
                                            btnTextClr: AppColors.blackColor,
                                            showBorder: true,
                                            disableGradient: true),
                                      )
                                    : Expanded(
                                        child: ButtonOneExpanded(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      OfferReactivateDialog(
                                                          id: offer.id));
                                            },
                                            btnText: "Re-activate",
                                            borderColor: AppColors.greyColor
                                                .withOpacity(0.6),
                                            btnColor: AppColors.transparent,
                                            enableColor: true,
                                            btnTextColor: true,
                                            btnTextClr: AppColors.blackColor,
                                            showBorder: true,
                                            disableGradient: true),
                                      ),
                                AppServices.addWidth(10.w),
                                Expanded(
                                    child: ButtonOneExpanded(
                                        onPressed: () {
                                          FancyDialogController()
                                              .deleteConfirmationDialog(context,
                                                  () {
                                            FirebaseController(context)
                                                .deleteOffer(offer.id);
                                          }).show();
                                        },
                                        btnText: "Delete"))
                              ],
                            )
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ));
  }
}
