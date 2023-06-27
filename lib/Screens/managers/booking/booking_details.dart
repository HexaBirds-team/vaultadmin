import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/pdf/pdf_file_handle_api.dart';
import 'package:valt_security_admin_panel/components/pdf/receipt_pdf.dart';
import 'package:valt_security_admin_panel/components/shimmers/booking_details_shimmer.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/style_sheet.dart';

class BookingDetailsView extends StatefulWidget {
  final BookingsClass booking;
  const BookingDetailsView({super.key, required this.booking});

  @override
  State<BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<BookingDetailsView> {
  String bookingId = "";
  BookingsClass? myBooking;
  late UserInformationClass userData;
  List<ProvidersInformationClass> guardsProfile = [];
  bool loading = false;

  @override
  void initState() {
    getBookingDetails();
    super.initState();
  }

  getBookingDetails() async {
    final db = Provider.of<AppDataController>(context, listen: false);
    loading = true;
    myBooking = widget.booking;
    bookingId = widget.booking.id;
    userData = db.getAllUsers
        .firstWhere((element) => element.uid == widget.booking.userId);
    var guards = widget.booking.guards;

    for (var guard in db.getAllProviders) {
      if (guards.any((element) => element.split("/").first == guard.uid)) {
        guardsProfile.add(guard);
        print(guardsProfile.length);
      }
    }
    loading = false;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        foregroundColor: AppColors.blackColor,
        elevation: 0,
        title: const Text("Booking Detail"),
      ),
      body: SafeArea(
          child: loading
              ? BookingDetailsShimmer()
              : ListView(
                  padding: EdgeInsets.all(15.sp),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text("Client Detail", style: GetTextTheme.sf16_bold),
                    AppServices.addHeight(10.h),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      tileColor: AppColors.blackColor.withOpacity(0.07),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(500.r),
                        child: userData.image == ""
                            ? Shimmer.fromColors(
                                baseColor:
                                    AppColors.blackColor.withOpacity(0.1),
                                highlightColor:
                                    AppColors.blackColor.withOpacity(0.02),
                                child: Container(
                                  height: 50.sp,
                                  width: 50.sp,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blackColor),
                                ),
                              )
                            : CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor:
                                          AppColors.blackColor.withOpacity(0.1),
                                      highlightColor: AppColors.blackColor
                                          .withOpacity(0.02),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.blackColor),
                                      ),
                                    ),
                                imageUrl: userData.image,
                                height: 50.sp,
                                width: 50.sp,
                                fit: BoxFit.cover),
                      ),
                      title: Text(userData.username,
                          style: GetTextTheme.sf16_bold),
                      subtitle:
                          Text(userData.phone, style: GetTextTheme.sf14_medium),
                      trailing: IconButton(
                          onPressed: () {
                            _makePhoneCall(userData.phone);
                          },
                          icon: const Icon(Icons.phone,
                              color: AppColors.primary1)),
                    ),
                    AppServices.addHeight(20.h),
                    Text("Booking Schedule", style: GetTextTheme.sf16_bold),
                    AppServices.addHeight(10.h),
                    Container(
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.2),
                                  offset: const Offset(0, 0),
                                  blurRadius: 4)
                            ],
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(
                                text: "Booking ID: ",
                                style: GetTextTheme.sf16_regular,
                                children: [
                                  TextSpan(
                                      text: myBooking!.bookingId,
                                      style: GetTextTheme.sf16_bold)
                                ])),
                            AppServices.addHeight(10.h),
                            const Divider(),
                            AppServices.addHeight(10.h),
                            Text("Booking Date & Time",
                                style: GetTextTheme.sf14_regular),
                            AppServices.addHeight(10.h),
                            Text(
                                myBooking!.type == "Multiple Day"
                                    ? AppServices.splitBookingDate(
                                        myBooking!.reportingDate.toString())
                                    : AppServices.formatDate(
                                        myBooking!.reportingDate.toString()),
                                style: GetTextTheme.sf16_medium),
                            Text("Shift : ${myBooking!.reportingTime}",
                                style: GetTextTheme.sf14_regular),
                            AppServices.addHeight(20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Booking Address",
                                          style: GetTextTheme.sf14_regular),
                                      AppServices.addHeight(10.h),
                                      Text(myBooking!.address,
                                          style: GetTextTheme.sf16_medium),
                                    ],
                                  ),
                                ),
                                AppServices.addWidth(10.w),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blackColor
                                          .withOpacity(0.07)),
                                  child: IconButton(
                                      onPressed: () => _openMap(
                                          myBooking!.lat, myBooking!.lng),
                                      icon: const Icon(Icons.map,
                                          color: AppColors.primary1)),
                                )
                              ],
                            ),
                            AppServices.addHeight(20.h),
                            Text("Expected Amount",
                                style: GetTextTheme.sf14_regular),
                            AppServices.addHeight(10.h),
                            Text("\u{20B9} ${myBooking!.price}.00",
                                style: GetTextTheme.sf16_medium),
                            Text("For 2 Hours",
                                style: GetTextTheme.sf14_regular),
                          ],
                        )),
                    AppServices.addHeight(20.h),
                    Text("Guards List", style: GetTextTheme.sf16_bold),
                    AppServices.addHeight(10.h),
                    guardsProfile.isEmpty
                        ? Text("Not Available",
                            textAlign: TextAlign.center,
                            style: GetTextTheme.sf20_bold)
                        : Column(
                            children: [
                              ...List.generate(
                                guardsProfile.length,
                                (i) {
                                  var profile = guardsProfile[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.sp),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      tileColor: AppColors.blackColor
                                          .withOpacity(0.07),
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500.r),
                                        child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                                  baseColor: AppColors
                                                      .blackColor
                                                      .withOpacity(0.1),
                                                  highlightColor: AppColors
                                                      .blackColor
                                                      .withOpacity(0.02),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                ),
                                            imageUrl:
                                                profile.profileImage.toString(),
                                            height: 50.sp,
                                            width: 50.sp,
                                            fit: BoxFit.cover),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(profile.name.toString(),
                                              style: GetTextTheme.sf16_bold),
                                          widget.booking.guards
                                                  .firstWhere((element) =>
                                                      element
                                                          .split("/")
                                                          .first ==
                                                      profile.uid)
                                                  .endsWith("rejected")
                                              ? Text("   (Rejected)",
                                                  style: GetTextTheme.sf16_bold
                                                      .copyWith(
                                                          color: AppColors
                                                              .redColor))
                                              : const SizedBox()
                                        ],
                                      ),
                                      subtitle: Consumer<AppDataController>(
                                          builder: (context, data, child) {
                                        final category = data.getUserCategories
                                            .firstWhere((e) =>
                                                e.categoryId ==
                                                profile.category);
                                        return Text(category.name.toString(),
                                            style: GetTextTheme.sf14_medium);
                                      }),
                                      trailing: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.greenColor),
                                          ),
                                          onPressed: () => AppServices.pushTo(
                                              context,
                                              GuardProfileView(
                                                  providerDetails: profile,
                                                  showEditOptions: false)),
                                          child: Text("View Profile",
                                              style: GetTextTheme.sf10_medium
                                                  .copyWith(
                                                      color: AppColors
                                                          .whiteColor))),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                    AppServices.addHeight(40.h),
                    ButtonOneExpanded(
                        onPressed: () async {
                          final file =
                              await PdfInvoiceApi.generate(widget.booking);
                          PdfFileHandlerApi.openFile(file);
                        },
                        // AppServices.pushTo(
                        //     context, ReceiptView(booking: myBooking!)),
                        btnText: "View Receipt"),
                    widget.booking.bookingStatus == BookingStatus.cancelled.name
                        ? TextButton.icon(
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary1),
                            onPressed: () {},
                            icon: const Icon(Icons.payment),
                            label: const Text("Refund Payment"))
                        : const SizedBox(),
                    AppServices.addHeight(20.h),
                  ],
                )),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _openMap(double lat, double lng, [String label = ""]) async {
    getUri() {
      if (Platform.isAndroid) {
        return Uri(
            scheme: 'geo',
            host: '0,0',
            queryParameters: {"q": '$lat,$lng$label'});
      } else if (Platform.isIOS) {
        var params = {
          'll': '$lat,$lng',
          "q": label == "" ? "$lat,$lng" : label
        };
        return Uri.https('maps.apple.com', "/", params);
      } else {
        return Uri.parse(
            "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
      }
    }

    if (!await launchUrl(getUri())) {
      throw 'Could not launch app';
    }
  }
}
