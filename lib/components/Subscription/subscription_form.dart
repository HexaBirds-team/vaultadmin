import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/Subscription/create_sub_tile.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';

class SubscriptionForm extends StatelessWidget {
  const SubscriptionForm(
      {super.key,
      required this.hourBasic,
      required this.hourStandard,
      required this.hourPremium,
      required this.singleShiftBasic,
      required this.singleShiftPremium,
      required this.singleShiftStandard,
      required this.multipleDayHourBasic,
      required this.multipleDayHourStandard,
      required this.multipleDayHourPremium,
      required this.multipleDayShiftBasic,
      required this.multipleDayShiftStandard,
      required this.multipleDayShiftPremium,
      required this.monthlyHourBasic,
      required this.monthlyHourStandard,
      required this.monthlyHourPremium,
      required this.monthlyShiftBasic,
      required this.monthlyShiftPremium,
      required this.monthlyShiftStandard});

// single day hourly plan
  final TextEditingController hourBasic;
  final TextEditingController hourStandard;
  final TextEditingController hourPremium;

// single day shift plan
  final TextEditingController singleShiftBasic;
  final TextEditingController singleShiftStandard;
  final TextEditingController singleShiftPremium;

// multiple day hourly plan
  final TextEditingController multipleDayHourBasic;
  final TextEditingController multipleDayHourStandard;
  final TextEditingController multipleDayHourPremium;

// multiple day shift plan
  final TextEditingController multipleDayShiftBasic;
  final TextEditingController multipleDayShiftStandard;
  final TextEditingController multipleDayShiftPremium;

// monthly hourly plan
  final TextEditingController monthlyHourBasic;
  final TextEditingController monthlyHourStandard;
  final TextEditingController monthlyHourPremium;

// monthly shift plan
  final TextEditingController monthlyShiftBasic;
  final TextEditingController monthlyShiftStandard;
  final TextEditingController monthlyShiftPremium;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateSubscriptionTile(
              hourbasic: hourBasic,
              hourStandard: hourStandard,
              hourPremium: hourPremium,
              shiftbasic: singleShiftBasic,
              shiftStandard: singleShiftStandard,
              shiftPremium: singleShiftPremium,
              title: "Single Day"),
          AppServices.addHeight(15.h),
          CreateSubscriptionTile(
              hourbasic: multipleDayHourBasic,
              hourStandard: multipleDayHourStandard,
              hourPremium: multipleDayHourPremium,
              shiftbasic: multipleDayShiftBasic,
              shiftStandard: multipleDayShiftStandard,
              shiftPremium: multipleDayShiftPremium,
              title: "Multiple Days"),
          AppServices.addHeight(15.h),
          CreateSubscriptionTile(
              hourbasic: monthlyHourBasic,
              hourStandard: monthlyHourStandard,
              hourPremium: monthlyHourPremium,
              shiftbasic: monthlyShiftBasic,
              shiftStandard: monthlyShiftStandard,
              shiftPremium: monthlyShiftPremium,
              title: "Monthly"),
        ],
      ),
    );
  }
}
