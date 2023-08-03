// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/subscription/add_Plan.dart';
import 'package:valt_security_admin_panel/Screens/managers/subscription/sub_difference_model_tile.dart';
import 'package:valt_security_admin_panel/components/Subscription/subscription_form.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/snackbar_controller.dart';

class EditCategoryScreen extends StatefulWidget {
  CategoryClass categoryClass;
  EditCategoryScreen({super.key, required this.categoryClass});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
// global keys
  final GlobalKey<FormState> _key = GlobalKey();

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

  final _validator = DataValidationController();
  final _appFunctions = FunctionsController();

  final _picker = ImagePicker();
  final _name = TextEditingController();

  CroppedFile? _pickedFile;
  @override
  void initState() {
    super.initState();
    getStuff();
  }

  getStuff() async {
    final db = Provider.of<AppDataController>(context, listen: false);
    if (!await rebuild()) return;
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
    await FirebaseController(context)
        .getSubDifference(widget.categoryClass.categoryId);
    differentPlan = db.getSubDifference.isEmpty ? false : true;
    setState(() {});
  }

  Future<bool> rebuild() async {
    if (!mounted) return false;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: customAppBar(
          autoLeading: true,
          context: context,
          title: const Text("Edit Category"),
        ),
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  SimpleTextField(
                      name: _name,
                      validator: _validator,
                      label: "Edit Category Name",
                      hint: "Security Guard"),
                  AppServices.addHeight(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: _pickedFile == null
                            ? Image.network(widget.categoryClass.image,
                                height: 70.h, width: 70.w)
                            // CachedNetworkImage(
                            //     imageUrl: widget.categoryClass.image,
                            //     height: 70.h,
                            //     width: 70.w,
                            //   )
                            : Image.file(File(_pickedFile!.path),
                                height: 70.h, width: 70.w),
                      ),
                      TextButton(
                          onPressed: () {
                            onImagePicked();
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 15),
                              backgroundColor:
                                  AppColors.purple50.withOpacity(0.3),
                              foregroundColor: AppColors.blackColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r))),
                          child: Text("Change Image",
                              style: GetTextTheme.sf16_medium))
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
                                    context, AddPlanInSubScription());
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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        value.getSubDifference.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.getSubDifference.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      AppServices.pushTo(
                                          context,
                                          AddPlanInSubScription(
                                              data: value
                                                  .getSubDifference[index]));
                                    },
                                    child: SubDifferenceModelTile(
                                        data: value.getSubDifference[index]),
                                  );
                                },
                              ),

                        AppServices.addHeight(50.h),
                        value.appLoading
                            ? const OnViewLoader()
                            : ButtonOneExpanded(
                                onPressed: () {
                                  onSave(context);
                                },
                                btnText: "Save")
                        // ),
                      ],
                    );
                    //  Container(
                    //     width: AppServices.getScreenWidth(context),
                    //     decoration: BoxDecoration(
                    //         color: AppColors.whiteColor,
                    //         borderRadius: BorderRadius.circular(10.r)),
                    //     child:
                    //   );
                  }),
                ],
              ),
            ),
          ),
        ));
  }

  onImagePicked() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final croppedImage = await FunctionsController()
        .cropImage(path: picked.path, squareRatio: true);
    setState(() => _pickedFile = croppedImage);
  }

  Future<Map<String, dynamic>> getFormData() async {
    Map<String, dynamic> data = {
      "name": _name.text.trim(),
      "image": _pickedFile == null
          ? widget.categoryClass.image
          : await _appFunctions.uploadImageToStorage(File(_pickedFile!.path),
              url: widget.categoryClass.image),
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
    return data;
  }

  onSave(BuildContext context) async {
    bool isValid = _key.currentState!.validate();
    if (isValid) {
      var data = await getFormData();
      // data.addAll(widget.categoryClass);
      await FirebaseController(context)
          .editCategoryCallBack(data, widget.categoryClass.categoryId);

      setState(() {
        formSubmit = true;
      });
      // db.resetSubDifference();
    } else {
      MySnackBar.error(context, "All fields are Mandatory");
    }
  }
}
