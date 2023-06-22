import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/Subscription/subscription_form.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

class AddPlanInSubScription extends StatefulWidget {
  const AddPlanInSubScription({super.key});

  @override
  State<AddPlanInSubScription> createState() => _AddPlanInSubScriptionState();
}

class _AddPlanInSubScriptionState extends State<AddPlanInSubScription> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);

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

    final TextEditingController multipleDayHourStandard =
        TextEditingController();

    final TextEditingController multipleDayHourPremium =
        TextEditingController();

// multiple day shift plan
    final TextEditingController multipleDayShiftBasic = TextEditingController();

    final TextEditingController multipleDayShiftStandard =
        TextEditingController();

    final TextEditingController multipleDayShiftPremium =
        TextEditingController();

// monthly hourly plan
    final TextEditingController monthlyHourBasic = TextEditingController();

    final TextEditingController monthlyHourStandard = TextEditingController();

    final TextEditingController monthlyHourPremium = TextEditingController();

// monthly shift plan
    final TextEditingController monthlyShiftBasic = TextEditingController();

    final TextEditingController monthlyShiftStandard = TextEditingController();

    final TextEditingController monthlyShiftPremium = TextEditingController();

    List<ServiceAreaClass> serviceAreaCode = db.getserviceArea;
    final TextEditingController searchCode = TextEditingController();

    return Scaffold(
      appBar: customAppBar(context: context, title: null, autoLeading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 20.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Pin Code", style: GetTextTheme.sf18_medium),
                  AppServices.addWidth(20.w),
                  Expanded(
                    child: Autocomplete(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == "") {
                          return const Iterable<String>.empty();
                        } else {
                          List<String> matches = [];
                          matches.addAll(
                              serviceAreaCode.map((e) => e.pincode).toList());

                          matches.retainWhere((e) {
                            return e.startsWith(textEditingValue.text);
                          });

                          return matches;
                        }
                      },
                      onSelected: (String selection) {
                        print(selection);
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextField(
                          decoration: InputDecoration(
                              fillColor: AppColors.grey50,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide.none),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h)),
                          controller: textEditingController,
                          focusNode: focusNode,
                          onSubmitted: (String value) {},
                        );
                      },
                    ),
                  ),
                ],
              ),
              AppServices.addHeight(20.h),
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
              AppServices.addHeight(20.h),
              ButtonOneExpanded(
                  onPressed: () {
                    db.addSubDifference(SubDifferenceModel(
                      DateTime.now().millisecondsSinceEpoch.toString(),
                      searchCode.text,
                      ShiftModel(
                          intConvert(monthlyHourBasic.text),
                          intConvert(monthlyHourStandard.text),
                          intConvert(monthlyHourPremium.text)),
                      ShiftModel(
                          intConvert(monthlyShiftBasic.text),
                          intConvert(monthlyShiftStandard.text),
                          intConvert(monthlyShiftPremium.text)),
                      ShiftModel(
                          intConvert(multipleDayHourBasic.text),
                          intConvert(multipleDayHourStandard.text),
                          intConvert(multipleDayHourPremium.text)),
                      ShiftModel(
                          intConvert(multipleDayShiftBasic.text),
                          intConvert(multipleDayShiftStandard.text),
                          intConvert(multipleDayShiftPremium.text)),
                      ShiftModel(
                          intConvert(hourBasic.text),
                          intConvert(hourStandard.text),
                          intConvert(hourPremium.text)),
                      ShiftModel(
                          intConvert(singleShiftBasic.text),
                          intConvert(singleShiftStandard.text),
                          intConvert(singleShiftPremium.text)),
                    ));
                    Navigator.pop(context);
                  },
                  btnText: "Save Subscription")
            ],
          ),
        ),
      ),
    );
  }

  intConvert(String data) {
    if (data.isEmpty) {
      return 0;
    } else {
      return int.parse(data);
    }
  }
}
