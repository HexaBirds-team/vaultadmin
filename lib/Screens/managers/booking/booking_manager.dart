import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/search_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';
import '../../../models/enums.dart';
import '../../dashboard/new_bookings_tile.dart';

class BookingManager extends StatefulWidget {
  const BookingManager({super.key});

  @override
  State<BookingManager> createState() => _BookingManagerState();
}

class _BookingManagerState extends State<BookingManager> {
  BookingStatus status = BookingStatus.all;

  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final bookings = db.getBookings;
    bookings.sort((a, b) => b.bookingTime.compareTo(a.bookingTime));
    return Scaffold(
      appBar: AppBar(
          title: const Text("Manage Bookings"),
          actions: [
            PopupMenuButton(
                initialValue: status,
                icon: const Icon(Icons.filter_alt),
                onSelected: (v) {
                  setState(() {
                    status = v;
                  });
                },
                itemBuilder: (context) {
                  return BookingStatus.values
                      .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
                      .toList();
                })
          ],
          bottom: PreferredSize(
              preferredSize: Size(AppServices.getScreenWidth(context), 45.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SearchField(
                    hint: "Search by Booking Number..",
                    onSearch: (v) => {setState(() => searchValue = v)}),
              ))),
      body: SafeArea(
          child: bookings.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppIcons.emptyIcon,
                        height: 70.sp,
                      ),
                      AppServices.addHeight(10.h),
                      Text("No Data Found", style: GetTextTheme.sf18_bold),
                      Text("There are no new bookings available.",
                          style: GetTextTheme.sf14_regular)
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: bookings.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final booking = bookings[i];
                    return status == BookingStatus.all
                        ? (booking.bookingId
                                .toLowerCase()
                                .startsWith(searchValue.toLowerCase())
                            ? NewBookingsTile(booking: booking)
                            : const SizedBox())
                        : (booking.bookingStatus == status.name
                            ? (booking.bookingId
                                    .toLowerCase()
                                    .startsWith(searchValue.toLowerCase())
                                ? NewBookingsTile(booking: booking)
                                : const SizedBox())
                            : const SizedBox());
                  })),
    );
  }
}
