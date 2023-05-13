// ignore_for_file: must_be_immutable

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:valt_security_admin_panel/app_config.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

class ReceiptView extends StatefulWidget {
  BookingsClass booking;
  ReceiptView({super.key, required this.booking});

  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  @override
  Widget build(BuildContext context) {
    var priceWithOutTax = widget.booking.price *
        int.parse(widget.booking.bookingDuration) *
        widget.booking.guards.length;
    var tax = (priceWithOutTax * 18) / 100;
    var priceWithTax = priceWithOutTax + tax;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20.sp),
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image.asset(AppConfig.logoBlack, height: 50.h)),
              // const Center(
              //     child: Text("Vault Security", style: TextStyle(fontSize: 20))),
              const SizedBox(height: 10),
              const Center(
                child: Text("Thanks For Booking!!",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              // Center(
              //     child: Text("Sector 13, Hisar (Haryana) - 125001",
              //         style: const TextStyle(fontSize: 14))),
              const SizedBox(height: 30),
              const Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  style: TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              customRow("Order:", widget.booking.bookingId, false),
              customRow("Status:", widget.booking.paymentStatus, false),
              customRow(
                  "Date:",
                  DateFormat("yyyy-MM-dd hh:mm a")
                      .format(widget.booking.bookingTime),
                  false),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.booking.bookingCategoryImg))),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.booking.bookingCategory,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "duration : ${widget.booking.bookingDuration} (${widget.booking.type})",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${AppServices.getCurrencySymbol} $priceWithTax",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 18),
              customRow(
                  "Subtotal",
                  "${AppServices.getCurrencySymbol} ${priceWithOutTax.toString()}",
                  true),
              const SizedBox(height: 7),
              customRow("Tax (18%)",
                  "${AppServices.getCurrencySymbol} ${tax.toString()}", true),
              const SizedBox(height: 7),
              customRow(
                  "Total",
                  "${AppServices.getCurrencySymbol} ${priceWithTax.toString()}",
                  true),
              const SizedBox(height: 18),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 18),
              customRow("Reporting Date:", widget.booking.reportingDate, true),
              const SizedBox(height: 7),
              customRow("Reporting Time:", widget.booking.reportingTime, true),
              const SizedBox(height: 7),
              customRow("Address:", widget.booking.address, true),
              const SizedBox(height: 30),
              const Text(
                "If you need help with anything. don't hesitate to contact us at +91-9876543210",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              AppServices.addHeight(10.h),
              Center(
                child: BarcodeWidget(
                    drawText: false,
                    height: 50,
                    width: 200,
                    data: widget.booking.bookingId,
                    barcode: Barcode.code128()),
              ),
            ],
          ),
          IconButton(
              onPressed: () => {AppServices.popView(context)},
              icon: const Icon(Icons.arrow_back))
        ],
      ),
    ));
  }

  customRow(text1, text2, bool isSpace) {
    return Row(
        mainAxisAlignment:
            isSpace ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(text1,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          AppServices.addWidth(10.w),
          Flexible(
              flex: 4,
              child: Text(
                text2,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.end,
              )),
        ]);
  }
}
