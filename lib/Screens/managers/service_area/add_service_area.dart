import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';

import '../../../components/expanded_btn.dart';
import '../../../components/loaders/on_view_loader.dart';
import '../../../components/shift_form.dart';
import '../../../components/simple_textfield.dart';
import '../../../controllers/app_data_controller.dart';
import '../../../controllers/data_validation_controller.dart';
import '../../../controllers/firebase_controller.dart';
import '../../../controllers/snackbar_controller.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';

class AddServiceAreaView extends StatelessWidget {
  AddServiceAreaView({super.key});

  final _pinCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final TextEditingController _morningStartTime = TextEditingController();
  final TextEditingController _morningEndTime = TextEditingController();
  final TextEditingController _eveningStartTime = TextEditingController();
  final TextEditingController _eveningEndTime = TextEditingController();

  final _validator = DataValidationController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    return Scaffold(
      appBar: customAppBar(
        context: context,
        autoLeading: true,
        title: Text("Add Service Area", style: GetTextTheme.sf24_bold),
      ),
      body: Form(
        key: _key,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          padding: EdgeInsets.all(20.sp),
          children: [
            // AppServices.addHeight(40.h),
            SimpleTextField(
                name: _pinCodeController,
                validator: _validator,
                inputType: TextInputType.number,
                label: "Enter Service Area Pincode"),
            AppServices.addHeight(15.h),
            SimpleTextField(
                name: _cityController,
                validator: _validator,
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
                              btnColor: AppColors.blackColor.withOpacity(0.15),
                              btnTextColor: true,
                              btnTextClr: AppColors.blackColor)),
                      AppServices.addWidth(15.w),
                      Expanded(
                          child: ButtonOneExpanded(
                              onPressed: () => onSave(db, context),
                              btnText: "Save"))
                    ],
                  )
          ],
        ),
      ),
    );
  }

  onSave(AppDataController value, BuildContext context) async {
    String dayTime =
        (_morningStartTime.text.isNotEmpty && _morningEndTime.text.isNotEmpty)
            ? "${_morningStartTime.text} to ${_morningEndTime.text}"
            : "";

    String nightTime =
        (_eveningStartTime.text.isNotEmpty && _eveningEndTime.text.isNotEmpty)
            ? "${_eveningStartTime.text} to ${_eveningEndTime.text}"
            : "";

    if (_key.currentState!.validate()) {
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
        await FirebaseController(context).addServiceArea(data);
      }
    } else {
      null;
    }
  }
}
