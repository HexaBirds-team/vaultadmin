import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:valt_security_admin_panel/components/pdf/pdf_file_handle_api.dart';

import '../../app_config.dart';
import '../../helpers/base_getters.dart';
import '../../models/app_models.dart';

class PdfInvoiceApi {
  static Future<File> generate(BookingsClass booking) async {
    final pdf = Document();

    // price calculation with tax and without tax
    var priceWithOutTax = booking.price *
        int.parse(booking.bookingDuration) *
        booking.guards.length;
    var tax = (priceWithOutTax * 18) / 100;
    var priceWithTax = priceWithOutTax + tax;

    // images
    final appLogo =
        (await rootBundle.load(AppConfig.logoBlack)).buffer.asUint8List();

    final categoryImage = await networkImage(booking.bookingCategoryImg);
    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(30),
        build: (context) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image(MemoryImage(appLogo), height: 50)),
              SizedBox(height: 10),
              Center(
                child: Text("Thanks For Booking!!",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 30),
              Text(
                  "Thank you for choosing our security services! We appreciate your trust in us and remain committed to providing exceptional protection.",
                  style: const TextStyle(fontSize: 14)),
              SizedBox(height: 20),
              customRow("Order:", booking.bookingId, false),
              customRow("Status:", booking.paymentStatus, false),
              customRow(
                  "Date:",
                  DateFormat("yyyy-MM-dd hh:mm a").format(booking.bookingTime),
                  false),
              customRow(
                  "Payment Id:", booking.paymentId.split("_").last, false),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: categoryImage)),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.bookingCategory,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "duration : ${booking.bookingDuration} (${booking.type})",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Rs. $priceWithTax",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 18),
              customRow("Subtotal", "Rs. ${priceWithOutTax.toString()}", true),
              SizedBox(height: 7),
              customRow("Tax (18%)", "Rs. ${tax.toString()}", true),
              SizedBox(height: 7),
              customRow("Total", "Rs. ${priceWithTax.toString()}", true),
              SizedBox(height: 18),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 18),
              customRow(
                  "Reporting Date:",
                  booking.type == "Multiple Day"
                      ? AppServices.splitBookingDate(booking.reportingDate)
                      : AppServices.formatDate(booking.reportingDate),
                  true),
              SizedBox(height: 7),
              customRow("Reporting Time:", booking.reportingTime, true),
              SizedBox(height: 7),
              customRow("Address:", booking.address, true),
              SizedBox(height: 30),
              Text(
                "If you need help with anything. don't hesitate to contact us at +91-9992211889",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              BarcodeWidget(
                  drawText: false,
                  height: 50,
                  width: 200,
                  data: booking.bookingId,
                  barcode: Barcode.code128()),
            ],
          );
        }));

    return PdfFileHandlerApi.saveDocument(
        name: "booking_receipt.pdf", pdf: pdf);
  }

  static customRow(text1, text2, bool isSpace) {
    return Row(
        mainAxisAlignment:
            isSpace ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(text1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          SizedBox(width: 10),
          Flexible(
              flex: 4,
              child: Text(
                text2,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
              )),
        ]);
  }
}
