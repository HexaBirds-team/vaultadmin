// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/style_sheet.dart';

class TextFieldPrimary extends StatelessWidget {
  String hint, prefix;
  TextEditingController? controller;
  Function(String)? onchange;
  double padding;
  int maxlines;
  bool readOnly;
  TextInputType inputType;
  Function? ontap;
  TextFieldPrimary(
      {Key? key,
      this.hint = "",
      this.controller,
      this.onchange,
      this.prefix = '',
      this.padding = 15,
      this.maxlines = 1,
      this.readOnly = false,
      this.ontap,
      this.inputType = TextInputType.emailAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? TextField(
            onTap: ontap == null ? null : () => ontap!(),
            readOnly: readOnly,
            onChanged: onchange == null ? null : (value) => onchange!(value),
            maxLines: maxlines,
            controller: controller,
            keyboardType: inputType,
            obscuringCharacter: "*",
            style: GetTextTheme.sf16_regular.copyWith(
                color: readOnly
                    ? AppColors.blackColor.withOpacity(0.37)
                    : AppColors.blackColor),
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.r)),
                hintText: hint,
                hintStyle: GetTextTheme.sf14_regular
                    .copyWith(color: const Color.fromARGB(188, 154, 154, 154)),
                prefixIcon: prefix == ''
                    ? null
                    : IconButton(
                        onPressed: null,
                        iconSize: 15,
                        icon: Image.asset(
                          prefix,
                          height: 22.sp,
                          color: const Color.fromARGB(187, 146, 145, 145),
                        ),
                      ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: padding.h)),
          )
        : CupertinoTextField(
            readOnly: readOnly,
            onChanged: (value) => onchange!(value),
            maxLines: maxlines,
            controller: controller,
            onTap: ontap == null ? null : () => ontap!(),
            obscuringCharacter: "*",
            decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(10.r)),
            placeholder: hint,
            placeholderStyle: GetTextTheme.sf14_regular
                .copyWith(color: const Color.fromARGB(188, 154, 154, 154)),
            prefix: prefix == ""
                ? null
                : IconButton(
                    onPressed: null,
                    iconSize: 15,
                    icon: Image.asset(
                      prefix,
                      height: 22.sp,
                      color: const Color.fromARGB(187, 146, 145, 145),
                    ),
                  ),
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: padding.h),
          );
  }
}
