import 'package:flutter/material.dart';

dynamic customAppBar(
    {required BuildContext context,
    required dynamic title,
    dynamic leading,
    dynamic action,
    bool autoLeading = false,
    bool centerTitle = false}) {
  return AppBar(
    centerTitle: centerTitle,
    leading: autoLeading ? null : leading,
    title: title,
    actions: action,
    automaticallyImplyLeading: autoLeading,
  );
}
