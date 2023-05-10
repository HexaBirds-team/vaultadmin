import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/search_textfield.dart';

import '../../../controllers/app_functions.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';
import '../../../models/app_models.dart';
import '../../../models/enums.dart';
import '../../dashboard/new_bookings_tile.dart';

class BookingManager extends StatefulWidget {
  const BookingManager({super.key});

  @override
  State<BookingManager> createState() => _BookingManagerState();
}

class _BookingManagerState extends State<BookingManager> {
  int bookingsLength = 0;
  bool isBookingFetch = true;
  BookingStatus status = BookingStatus.all;

  // bool isFiltered = false;
  getBookingsUrl() {
    final path = database.ref("Bookings");
    return path;
  }

  String searchValue = "";

  @override
  void initState() {
    super.initState();
    getBookingsLength();
  }

  getBookingsLength() async {
    final path = await database.ref("Bookings").once();

    if (!mounted) return;
    setState(() {
      bookingsLength = path.snapshot.children.length;
      isBookingFetch = false;
    });
    return path.snapshot.children.length;
  }

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
        children: [
          FirebaseAnimatedList(
              defaultChild: const OnViewLoader(),
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
              shrinkWrap: true,
              sort: (a, b) => (b.value as Map<Object?, Object?>)['CreatedAt']
                  .toString()
                  .compareTo((a.value as Map<Object?, Object?>)['CreatedAt']
                      .toString()),
              query: getBookingsUrl(),
              itemBuilder: (context, snapshot, animation, i) {
                if (i > 0) {
                  isBookingFetch = true;
                }
                if (i == 0 && isBookingFetch == true) {
                  getBookingsLength();
                }
                BookingsClass booking = BookingsClass.fromBooking(
                    snapshot.value as Map<Object?, Object?>,
                    snapshot.key.toString());

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
              }),
          bookingsLength == 0
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
              : const SizedBox()
        ],
      )),
    );
  }
}
