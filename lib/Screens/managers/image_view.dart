// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

class ImageView extends StatelessWidget {
  DocsClass doc;
  ImageView({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blackColor,
        appBar: AppBar(
          backgroundColor: AppColors.blackColor,
          elevation: 0,
          foregroundColor: AppColors.whiteColor,
        ),
        body: Padding(
            padding: EdgeInsets.all(10.sp),
            child: PhotoView(
                maxScale: PhotoViewComputedScale.covered * 1.8,
                minScale: PhotoViewComputedScale.contained * 1,
                imageProvider: NetworkImage(doc.image))));
  }
}
