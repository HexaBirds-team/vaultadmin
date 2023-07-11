import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:valt_security_admin_panel/components/pdf/pdf_file_handle_api.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';

import '../../app_config.dart';
import '../../models/app_models.dart';

class TransactionReportApi {
  static Future<File> generate(List<PaymentModel> data, String startDate,
      String endDate, AppDataController db) async {
    final pdf = Document();
    final fontRegular = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsMedium();

    // images
    final appLogo =
        (await rootBundle.load(AppConfig.logoBlack)).buffer.asUint8List();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.symmetric(vertical: 30),
        // maxPages: 100,
        build: (context) {
          return [
            ListView(padding: const EdgeInsets.all(20), children: [
              Align(
                  alignment: Alignment.center,
                  child: Image(MemoryImage(appLogo), height: 50)),
              SizedBox(height: 10),
              Center(
                child: Text("DIAL VAULT",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        font: fontBold)),
              ),
              Center(
                child: Text("Transaction Report",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        font: fontRegular)),
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("From : $startDate", style: TextStyle(font: fontRegular)),
                Text("To : $endDate", style: TextStyle(font: fontRegular)),
              ]),
              SizedBox(height: 10),
              Table(children: [
                TableRow(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: PdfColors.black,
                          )),
                          child: Text("Date",
                              style: TextStyle(fontSize: 12, font: fontBold),
                              textAlign: TextAlign.center))),
                  Expanded(
                      flex: 3,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: PdfColors.black,
                          )),
                          child: Text("Narration",
                              style: TextStyle(fontSize: 12, font: fontBold),
                              textAlign: TextAlign.center))),
                  Expanded(
                      flex: 2,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: PdfColors.black,
                          )),
                          child: Text("Transaction id",
                              style: TextStyle(fontSize: 12, font: fontBold),
                              textAlign: TextAlign.center))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: PdfColors.black,
                          )),
                          child: Text("Credit",
                              style: TextStyle(fontSize: 12, font: fontBold),
                              textAlign: TextAlign.center))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: PdfColors.black,
                          )),
                          child: Text("Debit",
                              style: TextStyle(fontSize: 12, font: fontBold),
                              textAlign: TextAlign.center))),
                ]),
              ]),
              Table(children: [
                ...List.generate(10, (i) {
                  return customTableRow(data[i], fontBold, db);
                })
              ])
            ]),
            if (data.length > 10) getListofTransaction(data, fontBold, db)
            // ListView(padding: const EdgeInsets.all(20), children: [
            //   Table(children: [
            //     ...List.generate(14, (i) {
            //       var subData = data.sublist(10);
            //       return customTableRow(subData[i], fontBold, db);
            //     })
            //   ])
            // ])
          ];
        }));
    return PdfFileHandlerApi.saveDocument(
        name: "Transaction_report.pdf", pdf: pdf);
  }
}

customTableRow(PaymentModel data, Font font, AppDataController db) {
  return TableRow(children: [
    Expanded(
        flex: 1,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: PdfColors.black,
            )),
            child: Text(DateFormat("dd MMM yyyy").format(data.createdOn),
                maxLines: 2,
                overflow: TextOverflow.span,
                style: TextStyle(fontSize: 12, font: font),
                textAlign: TextAlign.center))),
    Expanded(
        flex: 3,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: PdfColors.black,
            )),
            child: Text(data.description,
                maxLines: 2,
                overflow: TextOverflow.span,
                style: TextStyle(fontSize: 12, font: font),
                textAlign: TextAlign.center))),
    Expanded(
        flex: 2,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: PdfColors.black,
            )),
            child: Text(data.paymentId.split("_").last,
                maxLines: 2,
                overflow: TextOverflow.span,
                style: TextStyle(fontSize: 12, font: font),
                textAlign: TextAlign.center))),
    Expanded(
        flex: 1,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: PdfColors.black,
            )),
            child: Text(
                data.userId == db.adminDetails['id']
                    ? ""
                    : "Rs. ${data.amount.split(".").first}",
                maxLines: 2,
                overflow: TextOverflow.span,
                style: TextStyle(fontSize: 12, font: font),
                textAlign: TextAlign.center))),
    Expanded(
        flex: 1,
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              color: PdfColors.black,
            )),
            child: Text(
                data.userId == db.adminDetails['id']
                    ? "Rs. ${data.amount.split(".").first}"
                    : "",
                maxLines: 2,
                overflow: TextOverflow.span,
                style: TextStyle(fontSize: 12, font: font),
                textAlign: TextAlign.center))),
  ]);
}

getListofTransaction(List<PaymentModel> data, Font font, AppDataController db) {
  var list = data.sublist(10);
  List<PaymentModel> list1 = [];
  Widget widget = SizedBox();
  for (var i = 0; i < list.length; i++) {
    list1.add(list[i]);
    if (i % 13 == 0) {
      widget = ListView(padding: const EdgeInsets.all(20), children: [
        Table(children: [
          ...List.generate(
              list1.length, (index) => customTableRow(list1[index], font, db))
        ])
      ]);
      list1 = [];
    }
  }
  return widget;
}
