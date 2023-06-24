// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/Subscription/subscription_form.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

class AddPlanInSubScription extends StatefulWidget {
  SubDifferenceModel? data;
  AddPlanInSubScription({super.key, this.data});

  @override
  State<AddPlanInSubScription> createState() => _AddPlanInSubScriptionState();
}

class _AddPlanInSubScriptionState extends State<AddPlanInSubScription> {
// global keys
  final GlobalKey<FormState> _key = GlobalKey();

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

  // pincode text controller
  TextEditingController searchCode = TextEditingController();

  getStuff() {
    searchCode.text = widget.data!.pincode;
    hourBasic.text = widget.data!.dailyHr.basic.toString();
    hourStandard.text = widget.data!.singleHr.standard.toString();
    hourPremium.text = widget.data!.singleHr.premium.toString();
    singleShiftBasic.text = widget.data!.singleShift.basic.toString();
    singleShiftStandard.text = widget.data!.singleShift.standard.toString();
    singleShiftPremium.text = widget.data!.singleShift.premium.toString();
    multipleDayHourBasic.text = widget.data!.dailyHr.basic.toString();
    multipleDayHourStandard.text = widget.data!.dailyHr.standard.toString();
    multipleDayHourPremium.text = widget.data!.dailyHr.premium.toString();
    multipleDayShiftBasic.text = widget.data!.dailyShift.basic.toString();
    multipleDayShiftStandard.text = widget.data!.dailyShift.standard.toString();
    multipleDayShiftPremium.text = widget.data!.dailyShift.premium.toString();
    monthlyHourBasic.text = widget.data!.monthlyHr.basic.toString();
    monthlyHourStandard.text = widget.data!.monthlyHr.standard.toString();
    monthlyHourPremium.text = widget.data!.monthlyHr.premium.toString();
    monthlyShiftBasic.text = widget.data!.monthlyShift.basic.toString();
    monthlyShiftStandard.text = widget.data!.monthlyShift.premium.toString();
    monthlyShiftPremium.text = widget.data!.monthlyHr.premium.toString();
  }

  @override
  void initState() {
    super.initState();
    widget.data != null ? getStuff() : null;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    List<ServiceAreaClass> serviceAreaCode = db.getserviceArea;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context: context, title: null, autoLeading: true),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
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
                        initialValue: TextEditingValue(text: searchCode.text),
                        // optionsMaxHeight: 150.h,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == "") {
                            return const Iterable<String>.empty();
                          } else {
                            if (!serviceAreaCode.any((element) => element
                                .pincode
                                .startsWith(textEditingValue.text))) {
                              return ["Area not available"];
                            } else {
                              List<String> matches = [];
                              matches.addAll(serviceAreaCode
                                  .map((e) => e.pincode)
                                  .toList());

                              matches.retainWhere((e) {
                                return e.startsWith(textEditingValue.text);
                              });

                              return matches;
                            }
                          }
                        },
                        onSelected: (String selection) {
                          searchCode.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                fillColor: AppColors.grey50,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h)),
                            controller: textEditingController,
                            focusNode: focusNode,
                            onSubmitted: (String value) {},
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            void Function(String) onSelected,
                            Iterable<String> options) {
                          return Material(
                              type: MaterialType.transparency,
                              child: Container(
                                  margin:
                                      EdgeInsets.only(top: 7.h, right: 134.w),
                                  child: SingleChildScrollView(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: options.map((opt) {
                                        return InkWell(
                                            onTap: () {
                                              onSelected(opt);
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.all(0),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 15.h),
                                                decoration: const BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: AppColors
                                                                .grey50))),
                                                child: Text(opt)));
                                      }).toList(),
                                    ),
                                  ))));
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
                      widget.data == null ? onSave(db) : onUpdate(db);
                    },
                    btnText: widget.data == null
                        ? "Save Subscription"
                        : "Update Subscription")
              ],
            ),
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

  onSave(AppDataController db) {
    bool isValid = _key.currentState!.validate();
    if (isValid && searchCode.text.isNotEmpty) {
      if (searchCode.text.trim() == "Area not available") {
        MySnackBar.warning(context, "Please Select an area pincode to proceed");
      } else {
        db.addSubDifference(SubDifferenceModel(
          FunctionsController().generateId(length: 20),
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
          ShiftModel(intConvert(hourBasic.text), intConvert(hourStandard.text),
              intConvert(hourPremium.text)),
          ShiftModel(
              intConvert(singleShiftBasic.text),
              intConvert(singleShiftStandard.text),
              intConvert(singleShiftPremium.text)),
        ));
        Navigator.pop(context);
      }
    } else {
      MySnackBar.error(
          context,
          searchCode.text.isEmpty
              ? "Please select pincode from the suggestion dropdown."
              : "All fields are Mandatory");
    }
  }

  onUpdate(AppDataController db) {
    bool isValid = _key.currentState!.validate();
    if (isValid && searchCode.text.isNotEmpty) {
      if (searchCode.text.trim() == "Area not available") {
        MySnackBar.warning(context, "Please Select an area pincode to proceed");
      } else {
        db.updateSubDifference(SubDifferenceModel(
          widget.data!.id,
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
          ShiftModel(intConvert(hourBasic.text), intConvert(hourStandard.text),
              intConvert(hourPremium.text)),
          ShiftModel(
              intConvert(singleShiftBasic.text),
              intConvert(singleShiftStandard.text),
              intConvert(singleShiftPremium.text)),
        ));
        Navigator.pop(context);
      }
    } else {
      MySnackBar.error(
          context,
          searchCode.text.isEmpty
              ? "Please select pincode from the suggestion dropdown."
              : "All fields are Mandatory");
    }
  }
}
