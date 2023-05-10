import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/style_sheet.dart';

class OnViewLoader extends StatelessWidget {
  const OnViewLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 70.sp,
          child: SpinKitWave(
              color: AppColors.primary1,
              type: SpinKitWaveType.center,
              size: 30.sp)),
    );
  }
}
