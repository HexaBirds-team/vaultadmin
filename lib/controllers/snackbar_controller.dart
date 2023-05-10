import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class MySnackBar {
  static success(BuildContext context, String msg) {
    AnimatedSnackBar.rectangle('Success', msg,
            duration: const Duration(milliseconds: 1500),
            type: AnimatedSnackBarType.success,
            brightness: Brightness.light)
        .show(context);
  }

  static error(BuildContext context, String msg) {
    AnimatedSnackBar.rectangle('Error', msg,
            duration: const Duration(milliseconds: 1500),
            type: AnimatedSnackBarType.error,
            brightness: Brightness.light)
        .show(context);
  }

  static warning(BuildContext context, String msg) {
    AnimatedSnackBar.rectangle('Watning', msg,
            duration: const Duration(milliseconds: 1500),
            type: AnimatedSnackBarType.warning,
            brightness: Brightness.light)
        .show(context);
  }

  static info(BuildContext context, String msg) {
    AnimatedSnackBar.rectangle('Information', msg,
            duration: const Duration(milliseconds: 1500),
            type: AnimatedSnackBarType.info,
            brightness: Brightness.light)
        .show(context);
  }
}
