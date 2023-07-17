import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
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

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final offers = db.getOffers;
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
              AppServices.addWidth(20.w)
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

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(10.sp),
                        decoration:
                            WidgetDecoration.containerDecoration_1(context)
                                .copyWith(
                                    color: offer.isDisabled
                                        ? AppColors.redColor.withOpacity(0.1)
                                        : AppColors.whiteColor,
                                    border: Border.all(
                                        color: offer.isDisabled
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
                                  padding: EdgeInsets.all(8.sp),
                                  height: 50.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                      gradient: AppColors.appGradientColor,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: FittedBox(
                                    child: Text("${offer.discount}%",
                                        style: const TextStyle(
                                            color: AppColors.whiteColor)),
                                  ),
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
                                Expanded(
                                  child: ButtonOneExpanded(
                                      onPressed: () {
                                        offer.isDisabled
                                            ? FirebaseController(context)
                                                .updateOfferIsDisabled(
                                                    false, offer.id)
                                            : FancyDialogController()
                                                .disableConfirmationDialog(
                                                    context, () {
                                                FirebaseController(context)
                                                    .updateOfferIsDisabled(
                                                        true, offer.id);
                                              }).show();
                                      },
                                      btnText: offer.isDisabled
                                          ? "Enable"
                                          : "Disable",
                                      borderColor: AppColors.greyColor,
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
