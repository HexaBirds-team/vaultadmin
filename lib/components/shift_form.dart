// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../helpers/base_getters.dart';
import '../helpers/icons_and_images.dart';
import '../helpers/style_sheet.dart';
import 'gradient_components/gradient_image.dart';

class ShiftForm extends StatefulWidget {
  TextEditingController startTimeController, endTimeController;
  String title;
  ShiftForm(
      {super.key,
      required this.startTimeController,
      required this.endTimeController,
      required this.title});

  @override
  State<ShiftForm> createState() => _ShiftFormState();
}

class _ShiftFormState extends State<ShiftForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: GetTextTheme.sf18_bold),
        AppServices.addHeight(20.h),
        shiftTextField(() async {
          var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 00));
          widget.startTimeController.text = DateFormat("hh:mm a")
              .format(DateTime(1999, 08, 24, time!.hour, time.minute));
          // "${time!.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} ${time.period.name}";

          setState(() {});
        }, "Select Start Time", "", widget.startTimeController),
        AppServices.addHeight(20.h),
        shiftTextField(() async {
          var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 00));
          widget.endTimeController.text = DateFormat("hh:mm a")
              .format(DateTime(1999, 08, 24, time!.hour, time.minute));

          setState(() {});
        }, "Select End Time", "", widget.endTimeController),
      ],
    );
  }

  // shift text field
  shiftTextField(Function ontap, String hint, String errorText,
      TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          // readOnly: true,
          onTap: () {
            ontap();
          },
          controller: controller,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.sp, vertical: 17.sp),
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              suffixIcon: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: ImageGradient(
                      image: AppIcons.calenderIcon,
                      gradient: AppColors.appGradientColor,
                      height: 20.sp,
                      width: 20.sp))),
        ),
        AppServices.addHeight(errorText.isEmpty ? 0 : 3.h),
        errorText.isEmpty
            ? const SizedBox()
            : Text(errorText,
                style: GetTextTheme.sf12_regular
                    .copyWith(color: AppColors.redColor))
      ],
    );
  }
}
