// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/subscription/add_Plan.dart';
import 'package:valt_security_admin_panel/components/Subscription/subscription_form.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

class EditCategoryScreen extends StatefulWidget {
  CategoryClass categoryClass;
  EditCategoryScreen({super.key, required this.categoryClass});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
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
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _validator = DataValidationController();
  final _appFunctions = FunctionsController();

  final _picker = ImagePicker();
  final _name = TextEditingController();

  CroppedFile? _pickedFile;
  @override
  void initState() {
    _name.text = widget.categoryClass.name;
    hourBasic.text = widget.categoryClass.singleHr.basic.toString();
    hourStandard.text = widget.categoryClass.singleHr.standard.toString();
    hourPremium.text = widget.categoryClass.singleHr.premium.toString();
    singleShiftBasic.text = widget.categoryClass.singleShift.basic.toString();
    singleShiftStandard.text =
        widget.categoryClass.singleShift.standard.toString();
    singleShiftPremium.text =
        widget.categoryClass.singleShift.premium.toString();
    multipleDayHourBasic.text = widget.categoryClass.dailyHr.basic.toString();
    multipleDayHourStandard.text =
        widget.categoryClass.dailyHr.standard.toString();
    multipleDayHourPremium.text =
        widget.categoryClass.dailyHr.premium.toString();
    multipleDayShiftBasic.text =
        widget.categoryClass.dailyShift.basic.toString();
    multipleDayShiftStandard.text =
        widget.categoryClass.dailyShift.standard.toString();
    multipleDayShiftPremium.text =
        widget.categoryClass.dailyShift.premium.toString();
    monthlyHourBasic.text = widget.categoryClass.monthlyHr.basic.toString();
    monthlyHourStandard.text =
        widget.categoryClass.monthlyHr.standard.toString();

    monthlyHourPremium.text = widget.categoryClass.monthlyHr.premium.toString();
    monthlyShiftBasic.text = widget.categoryClass.monthlyShift.basic.toString();
    monthlyShiftStandard.text =
        widget.categoryClass.monthlyShift.premium.toString();
    monthlyShiftPremium.text =
        widget.categoryClass.monthlyHr.premium.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
          autoLeading: true,
          context: context,
          title: const Text("Edit Category"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(children: [
              SimpleTextField(
                  name: _name,
                  validator: _validator,
                  label: "Edit Category Name",
                  hint: "Security Guard"),
              AppServices.addHeight(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    // onTap: () => onImagePicked(),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15),
                        decoration:
                            WidgetDecoration.containerDecoration_1(context)
                                .copyWith(
                                    color: AppColors.purple50.withOpacity(0.3)),
                        child: Text("Change Image",
                            style: GetTextTheme.sf16_medium)),
                  ),
                ],
              ),
              AppServices.addHeight(25.h),
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
                          onChanged: (v) => setState(() => differentPlan = v!)),
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
              Container(
                width: AppServices.getScreenWidth(context),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Consumer<AppDataController>(
                    //   builder: (context, value, child) {
                    //     if (value.getSubDifference.isEmpty) {
                    //       return const SizedBox();
                    //     } else {
                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: value.getSubDifference.length,
                    //         itemBuilder: (context, index) {
                    //           return subDifferenceModelTiel(
                    //               value.getSubDifference[index]);
                    //         },
                    //       );
                    //     }
                    //   },
                    // ),
                    AppServices.addHeight(50.h),
                    Consumer<AppDataController>(
                        builder: (context, data, child) => data.appLoading
                            ? const OnViewLoader()
                            : ButtonOneExpanded(
                                onPressed: () {}, btnText: "Save"))
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
