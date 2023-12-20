// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/text_field_primary.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../pdf/pdf_file_handle_api.dart';
import '../pdf/transaction_report_pdf.dart';

class DownloadTranReportDialog extends StatefulWidget {
  const DownloadTranReportDialog({super.key});

  @override
  State<DownloadTranReportDialog> createState() =>
      _DownloadTranReportDialogState();
}

class _DownloadTranReportDialogState extends State<DownloadTranReportDialog> {
// text field controllers
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  List<String> dropdownItems = [
    "Recent",
    "Last month",
    "Last 3 months",
    "Last 6 months",
    "Custom Date"
  ];

  String dropdownvalue = "Recent";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.grey50)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: dropdownvalue,
                    isExpanded: true,
                    items: dropdownItems
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() {
                          dropdownvalue = v.toString();
                        })),
              ),
            ),
            Visibility(
              visible: dropdownvalue == 'Custom Date',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppServices.addHeight(10.h),
                  TextFieldPrimary(
                      controller: _startDate,
                      readOnly: true,
                      hint: "Select start date",
                      prefix: AppIcons.calenderIcon,
                      ontap: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 2),
                              lastDate: DateTime.now())
                          .then((value) => setState(() => _startDate.text =
                              DateFormat("dd MMM yyyy").format(value!)))),
                  AppServices.addHeight(10.h),
                  TextFieldPrimary(
                      controller: _endDate,
                      readOnly: true,
                      hint: "Select end date",
                      prefix: AppIcons.calenderIcon,
                      ontap: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 2),
                              lastDate: DateTime.now())
                          .then((value) => setState(() => _endDate.text =
                              DateFormat("dd MMM yyyy").format(value!)))),
                ],
              ),
            ),
            AppServices.addHeight(20.h),
            Row(
              children: [
                Expanded(
                    child: ButtonOneExpanded(
                        onPressed: () {
                          AppServices.popView(context);
                        },
                        btnText: "Cancel",
                        btnColor: AppColors.grey100,
                        enableColor: true,
                        disableGradient: true,
                        btnTextColor: true,
                        btnTextClr: AppColors.blackColor)),
                AppServices.addWidth(10.w),
                Consumer<AppDataController>(
                    builder: (context, data, child) => data.appLoading
                        ? const OnViewLoader()
                        : Expanded(
                            child: ButtonOneExpanded(
                                onPressed: () async {
                                  onDownload();
                                },
                                btnText: "Download"))),
              ],
            )
          ],
        ),
      ),
    );
  }

  onDownload() async {
    DateTime startDate;
    DateTime endDate;

    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    var transactions = db.getPayments;

    if (dropdownvalue == "Recent") {
      startDate = DateTime.now().subtract(const Duration(days: 10));
      endDate = DateTime.now();
    } else if (dropdownvalue == "Last month") {
      var month = DateTime.now().month - 1;
      var year = DateTime.now().year;
      var day = AppServices.findDays(month, year);
      startDate = DateTime(year, month, 1);
      endDate = DateTime(year, month, day);
    } else if (dropdownvalue == "Last 3 months") {
      // var month = DateTime.now().month - 1;
      // var year = DateTime.now().year;
      // var day = AppServices.findDays(month, year);
      startDate = DateTime.now().subtract(Duration(days: (3 * 30.4).round()));
      // endDate = DateTime(year, month, day);
      endDate = DateTime.now();
    } else if (dropdownvalue == "Last 6 months") {
      // var month = DateTime.now().month - 1;
      // var year = DateTime.now().year;
      // var day = AppServices.findDays(month, year);
      startDate = DateTime.now().subtract(Duration(days: (6 * 30.4).round()));
      // endDate = DateTime(year, month, day);
      endDate = DateTime.now();
    } else {
      startDate = DateFormat("dd MMM yyyy").parse(_startDate.text);
      endDate = DateFormat("dd MMM yyyy").parse(_endDate.text);
    }

    var duration = FunctionsController.getDaysInBetween(startDate, endDate);
    var data = transactions
        .where((element) => duration.any((e) =>
            e.toIso8601String().split("T").first ==
            element.createdOn.toIso8601String().split("T").first))
        .toList();
    data.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    File file = await TransactionReportApi.generate(
        data,
        DateFormat("dd/MM/yyyy").format(startDate),
        DateFormat("dd/MM/yyyy").format(endDate),
        db);
    AppServices.popView(context);
    PdfFileHandlerApi.openFile(file, db);
    // db.setLoader(false);
  }
}
