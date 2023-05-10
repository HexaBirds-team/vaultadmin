
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/style_sheet.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.blackColor.withOpacity(0.4)),
      child: Card(
          child: Container(
        padding: EdgeInsets.all(10.sp),
        height: 90.sp,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70.sp,
              child: SpinKitWave(
                  color: AppColors.primary1,
                  type: SpinKitWaveType.center,
                  size: 30.sp),
            ),
            Text("Please Wait", style: GetTextTheme.sf14_regular)
          ],
        ),
      )),
    );
  }
}
