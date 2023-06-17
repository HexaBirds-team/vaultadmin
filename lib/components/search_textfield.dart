// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/style_sheet.dart';

class SearchField extends StatelessWidget {
  Function(String)? onSearch;
  Function? onTap;
  TextEditingController? controller;
  String hint;
  SearchField(
      {Key? key,
      this.onSearch,
      this.onTap,
      this.controller,
      this.hint = "Search by name.."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: WidgetDecoration.containerDecoration_1(context),
      child: TextField(
        controller: controller,
        onTap: onTap == null ? null : () => onTap!(),
        onChanged: (value) => onSearch!(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: hint,
            prefixIcon: const Icon(Icons.search, size: 26)),
      ),
    );
  }
}
