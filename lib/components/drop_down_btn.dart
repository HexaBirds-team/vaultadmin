// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/style_sheet.dart';

class AppDropDownButton extends StatelessWidget {
  String title;
  List<String> items;
  String dropDownValue;
  Function(String) onChange;
  AppDropDownButton(
      {super.key,
      this.title = "",
      required this.items,
      required this.dropDownValue,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title == ""
            ? const SizedBox()
            : Text(title,
                style: GetTextTheme.sf16_regular.copyWith(
                  color: AppColors.greyColor,
                )),
        Container(
            margin: const EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border:
                    Border.all(color: AppColors.greyColor)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    isExpanded: true,
                    value: dropDownValue,
                    items: items
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                        .toList(),
                    onChanged: (String? v) => {onChange(v!)}))),
      ],
    );
  }
}
