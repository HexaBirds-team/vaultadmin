import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/search_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
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
    final bookings = status == BookingStatus.all
        ? db.getBookings
            .where((element) => element.bookingId
                .toLowerCase()
                .startsWith(searchValue.toLowerCase()))
            .toList()
        : db.getBookings
            .where((element) =>
                element.bookingStatus == status.name &&
                element.bookingId
                    .toLowerCase()
                    .startsWith(searchValue.toLowerCase()))
            .toList();
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
              ? status != BookingStatus.all &&
                      db.getBookings
                          .where(
                              (element) => element.bookingStatus == status.name)
                          .isEmpty
                  ? AppServices.getEmptyIcon(
                      status == BookingStatus.completed
                          ? "Looks like no bookings have been completed yet"
                          : status == BookingStatus.cancelled
                              ? "No one has cancelled their booking"
                              : "Looks like no one have booked any guard yet.",
                      "No Bookings Yet",
                      image: AppImages.noBookingImage)
                  : searchValue.isNotEmpty
                      ? Center(
                          child: Image.asset(
                            AppImages.noResultImage,
                            height: 150.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : AppServices.getEmptyIcon(
                          status == BookingStatus.completed
                              ? "Looks like no bookings have been completed yet"
                              : status == BookingStatus.cancelled
                                  ? "No one has cancelled their booking"
                                  : "Looks like no one have booked any guard yet.",
                          "No Bookings Yet",
                          image: AppImages.noBookingImage)
              : ListView.builder(
                  itemCount: bookings.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                  // shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final booking = bookings[i];
                    return NewBookingsTile(booking: booking);
                    // status == BookingStatus.all
                    //     ? (booking.bookingId
                    //             .toLowerCase()
                    //             .startsWith(searchValue.toLowerCase())
                    //         ? NewBookingsTile(booking: booking)
                    //         : const SizedBox())
                    //     : (booking.bookingStatus == status.name
                    //         ? (booking.bookingId
                    //                 .toLowerCase()
                    //                 .startsWith(searchValue.toLowerCase())
                    //             ? NewBookingsTile(booking: booking)
                    //             : const SizedBox())
                    //         : const SizedBox());
                  })),
    );
  }
}
