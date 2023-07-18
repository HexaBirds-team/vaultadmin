// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/data_validation_controller.dart';
import '../../controllers/firebase_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../shift_form.dart';
import '../simple_textfield.dart';

class EditServiceAreaDialog extends StatefulWidget {
  ServiceAreaClass serviceData;
  // String pincode;
  // String id;
  // String city;
  EditServiceAreaDialog({Key? key, required this.serviceData})
      : super(key: key);

  @override
  State<EditServiceAreaDialog> createState() => _EditServiceAreaDialogState();
}

class _EditServiceAreaDialogState extends State<EditServiceAreaDialog> {
  final _pinCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final TextEditingController _morningStartTime = TextEditingController();
  final TextEditingController _morningEndTime = TextEditingController();
  final TextEditingController _eveningStartTime = TextEditingController();
  final TextEditingController _eveningEndTime = TextEditingController();

  final _validator = DataValidationController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getStuff();
  }

  getStuff() {
    _pinCodeController.text = widget.serviceData.pincode;
    _cityController.text = widget.serviceData.city;
    _morningStartTime.text =
        widget.serviceData.dayTime.split("to").first.trim();
    _morningEndTime.text = widget.serviceData.dayTime.split("to").last.trim();
    _eveningStartTime.text =
        widget.serviceData.nightTime.split("to").first.trim();
    _eveningEndTime.text = widget.serviceData.nightTime.split("to").last.trim();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context, listen: false);
    return Form(
      key: _key,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Service Area", style: GetTextTheme.sf24_bold),
              AppServices.addHeight(40.h),
              SimpleTextField(
                  name: _pinCodeController,
                  validator: _validator,
                  inputType: TextInputType.number,
                  label: "Enter Service Area Pincode"),
              AppServices.addHeight(15.h),
              SimpleTextField(
                  name: _cityController,
                  validator: _validator,
                  inputType: TextInputType.text,
                  label: "Enter Service Area Name"),
              AppServices.addHeight(20.h),
              ShiftForm(
                  startTimeController: _morningStartTime,
                  endTimeController: _morningEndTime,
                  title: "Day Shift"),
              AppServices.addHeight(20.h),
              ShiftForm(
                  startTimeController: _eveningStartTime,
                  endTimeController: _eveningEndTime,
                  title: "Night Shift"),
              AppServices.addHeight(40.h),
              db.appLoading
                  ? const OnViewLoader()
                  : Row(
                      children: [
                        Expanded(
                            child: ButtonOneExpanded(
                                onPressed: () => AppServices.popView(context),
                                btnText: "Cancel",
                                enableColor: true,
                                disableGradient: true,
                                btnColor:
                                    AppColors.blackColor.withOpacity(0.15),
                                btnTextColor: true,
                                btnTextClr: AppColors.blackColor)),
                        AppServices.addWidth(15.w),
                        Expanded(
                            child: ButtonOneExpanded(
                                onPressed: () => onUpdate(db),
                                btnText: "Update"))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

// categoryId

  onUpdate(AppDataController value) async {
    if (_key.currentState!.validate()) {
      String dayTime =
          (_morningStartTime.text.isNotEmpty && _morningEndTime.text.isNotEmpty)
              ? "${_morningStartTime.text} to ${_morningEndTime.text}"
              : "";

      String nightTime =
          (_eveningStartTime.text.isNotEmpty && _eveningEndTime.text.isNotEmpty)
              ? "${_eveningStartTime.text} to ${_eveningEndTime.text}"
              : "";

      if ((_morningStartTime.text.isNotEmpty && _morningEndTime.text.isEmpty) ||
          (_morningEndTime.text.isNotEmpty && _morningStartTime.text.isEmpty)) {
        MySnackBar.error(context,
            "Please select both start and end time for day shift to proceed.");
      } else if ((_eveningStartTime.text.isNotEmpty &&
              _eveningEndTime.text.isEmpty) ||
          (_eveningEndTime.text.isNotEmpty && _eveningStartTime.text.isEmpty)) {
        MySnackBar.error(context,
            "Please select both start and end time for night shift to proceed.");
      } else {
        Map<String, dynamic> data = {
          "pincode": _pinCodeController.text,
          "city": _cityController.text,
          "day": dayTime,
          "night": nightTime
        };
        await FirebaseController(context)
            .editServiceArea(data, widget.serviceData.id);
      }
    } else {
      null;
    }
  }
}
