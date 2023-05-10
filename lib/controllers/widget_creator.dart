import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';

import 'admin_callback_controller.dart';

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

  dynamic createChart(Map<String, double> dataMap, BuildContext context) {
    return dataMap.isEmpty
        ? const SizedBox()
        : PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: 80.sp,
            colorList: AdminCallbacksController().categoryListColors,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          );
  }
}
