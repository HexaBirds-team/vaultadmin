// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/subscription/add_Plan.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../components/Subscription/subscription_form.dart';

class AddSubscriptionView extends StatefulWidget {
  Map<String, dynamic> category;
  AddSubscriptionView({super.key, required this.category});

  @override
  State<AddSubscriptionView> createState() => _AddSubscriptionViewState();
}

class _AddSubscriptionViewState extends State<AddSubscriptionView> {
// boolean values
  bool differentPlan = false;
  bool formSubmit = false;

  // text editing controllers
  final TextEditingController hourBasic = TextEditingController();

  final TextEditingController hourStandard = TextEditingController();

  final TextEditingController hourPremium = TextEditingController();

// single day shift plan
  final TextEditingController singleShiftBasic = TextEditingController();

  final TextEditingController singleShiftStandard = TextEditingController();

  final TextEditingController singleShiftPremium = TextEditingController();

// multiple day hourly plan
  final TextEditingController multipleDayHourBasic = TextEditingController();

  final TextEditingController multipleDayHourStandard = TextEditingController();

  final TextEditingController multipleDayHourPremium = TextEditingController();

// multiple day shift plan
  final TextEditingController multipleDayShiftBasic = TextEditingController();

  final TextEditingController multipleDayShiftStandard =
      TextEditingController();

  final TextEditingController multipleDayShiftPremium = TextEditingController();

// monthly hourly plan
  final TextEditingController monthlyHourBasic = TextEditingController();

  final TextEditingController monthlyHourStandard = TextEditingController();

  final TextEditingController monthlyHourPremium = TextEditingController();

// monthly shift plan
  final TextEditingController monthlyShiftBasic = TextEditingController();

  final TextEditingController monthlyShiftStandard = TextEditingController();

  final TextEditingController monthlyShiftPremium = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);

    return WillPopScope(
        onWillPop: () async => !formSubmit
            ? {
                await FancyDialogController().willCloseWindow(context, () {
                  storage.refFromURL(widget.category['image']).delete();
                  AppServices.popView(context);
                }).show()
              }
            : AppServices.popView(context),
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: customAppBar(
                context: context,
                title: const Text("Create Subscription"),
                autoLeading: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(children: [
                  SubscriptionForm(
                      hourBasic: hourBasic,
                      hourStandard: hourStandard,
                      hourPremium: hourPremium,
                      singleShiftBasic: singleShiftBasic,
                      singleShiftPremium: singleShiftPremium,
                      singleShiftStandard: singleShiftStandard,
                      multipleDayHourBasic: multipleDayHourBasic,
                      multipleDayHourStandard: multipleDayHourStandard,
                      multipleDayHourPremium: multipleDayHourPremium,
                      multipleDayShiftBasic: multipleDayShiftBasic,
                      multipleDayShiftStandard: multipleDayShiftStandard,
                      multipleDayShiftPremium: multipleDayShiftPremium,
                      monthlyHourBasic: monthlyHourBasic,
                      monthlyHourStandard: monthlyHourStandard,
                      monthlyHourPremium: monthlyHourPremium,
                      monthlyShiftBasic: monthlyShiftBasic,
                      monthlyShiftPremium: monthlyShiftPremium,
                      monthlyShiftStandard: monthlyShiftStandard),
                  AppServices.addHeight(25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: differentPlan,
                              onChanged: (v) =>
                                  setState(() => differentPlan = v!)),
                          Text("Different City Plans",
                              style: GetTextTheme.sf18_medium)
                        ],
                      ),
                      !differentPlan
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                AppServices.pushTo(
                                    context, const AddPlanInSubScription());
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.blackColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 7.h),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.r),
                                      side: const BorderSide(
                                          color: AppColors.blueColor))),
                              child: Text("+ Add Plan",
                                  style: GetTextTheme.sf16_regular))
                    ],
                  ),
                  Consumer<AppDataController>(builder: (context, value, child) {
                    return value.getSubDifference.isEmpty
                        ? const SizedBox()
                        : Container(
                            width: AppServices.getScreenWidth(context),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.getSubDifference.length,
                                  itemBuilder: (context, index) {
                                    return subDifferenceModelTiel(
                                        value.getSubDifference[index]);
                                  },
                                )
                                // Consumer<AppDataController>(
                                //   builder: (context, value, child) {
                                //     if (value.getSubDifference.isEmpty) {
                                //       return const SizedBox();
                                //     } else {
                                //       return
                                //     }
                                //   },
                                // ),
                              ],
                            ),
                          );
                  }),
                  AppServices.addHeight(50.h),
                  ButtonOneExpanded(
                      onPressed: () {
                        onSave();
                      },
                      btnText: "Save")
                ]),
              ),
            )));
  }

  subDifferenceModelTiel(SubDifferenceModel data) {
    return Container(
      width: AppServices.getScreenWidth(context),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppServices.addHeight(10.h),
          Container(
            width: AppServices.getScreenWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: AppColors.purple50.withOpacity(0.3),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.r))),
            child: Text(data.pincode, style: GetTextTheme.sf18_medium),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Basic Plan  ", style: GetTextTheme.sf18_bold),
                    Text("    :", style: GetTextTheme.sf18_bold),
                    Text("Start from ${data.singleShift.basic}/ day",
                        style: GetTextTheme.sf18_medium)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Standard Plan", style: GetTextTheme.sf18_bold),
                    Text(":", style: GetTextTheme.sf18_bold),
                    Text("Start from ${data.singleShift.standard}/ day",
                        style: GetTextTheme.sf18_medium)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Premium Plan", style: GetTextTheme.sf18_bold),
                    Text(":", style: GetTextTheme.sf18_bold),
                    Text("Start from ${data.singleShift.premium}/ day",
                        style: GetTextTheme.sf18_medium)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  onSave() async {
    Map<String, dynamic> data = {
      "monthly": {
        "hourly": {
          "basic": monthlyHourBasic.text,
          "standard": monthlyHourStandard.text,
          "premium": monthlyHourPremium.text
        },
        "shift": {
          "basic": monthlyShiftBasic.text,
          "standard": monthlyShiftStandard.text,
          "premium": monthlyShiftPremium.text
        }
      },
      "multipleDay": {
        "hourly": {
          "basic": multipleDayHourBasic.text,
          "standard": multipleDayHourStandard.text,
          "premium": multipleDayHourPremium.text
        },
        "shift": {
          "basic": multipleDayShiftBasic.text,
          "standard": multipleDayShiftStandard.text,
          "premium": multipleDayShiftPremium.text
        }
      },
      "singleDay": {
        "hourly": {
          "basic": hourBasic.text,
          "standard": hourStandard.text,
          "premium": hourPremium.text
        },
        "shift": {
          "basic": singleShiftBasic.text,
          "standard": singleShiftStandard.text,
          "premium": singleShiftPremium.text
        }
      }
    };

    data.addAll(widget.category);
    await FirebaseController(context).addNewCategoryCallback(data);
    setState(() {
      formSubmit = true;
    });
  }
}
