import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetImplimentor {
  CachedNetworkImage addNetworkImage(
          {required String url,
          double height = 35,
          BoxFit? fit,
          Widget placeHolder = const SizedBox()}) =>
      CachedNetworkImage(
        placeholder: (context, url) => placeHolder,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        filterQuality: FilterQuality.high,
        imageUrl: url,
        height: fit != null ? null : height.h,
        width: fit != null ? null : height.h,
        fit: fit,
      );
}
