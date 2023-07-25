// ignore_for_file: must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_bookings_tile.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_guards_tile.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_users_tile.dart';
import 'package:valt_security_admin_panel/Screens/managers/booking/booking_manager.dart';
import 'package:valt_security_admin_panel/Screens/managers/complaints/complaints_tab_bar.dart';
import 'package:valt_security_admin_panel/Screens/managers/provider_manager.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/users_manager.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_text.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

import '../../controllers/app_data_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/firebase_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../drawer_handler/admin_drawer.dart';
import '../managers/request_manager.dart';

import '../settings.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // String paymentResponse = "";
  //Testing
  // String mid = "TEST_MID_HERE";
  // String PAYTM_MERCHANT_KEY = "TEST_KEY_HERE";
  // String website = "WEBSTAGING";
  // bool testing = true;

  // function to decode location

  Future<bool> rebuild() async {
    if (!mounted) return false;
    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppDataController>(context);
    final userList = data.getAllUsers;
    final bookingsList = data.getBookings;

    final approvedGuard = data.getAllProviders
        .where((element) => element.isApproved == GuardApprovalStatus.approved)
        .toList();
    final pendingGuard = data.getAllProviders
        .where((element) => element.isApproved == GuardApprovalStatus.pending)
        .toList();

    final complaintsList = data.getAllComplaints;
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        bool network =
            await FunctionsController.checkInternetConnectivity(context);
        if (network) {
          final firebase = FirebaseController(context);
          await firebase.getUsersList();

          await firebase.getGuardsList();

          await firebase.getComplaints();

          await firebase.getBookings();
        } else {
          MySnackBar.error(context,
              "Couldn't refresh data. Please check your connection or try again.");
        }
      },
      child: Scaffold(
        key: _key,
        drawer: Drawer(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(20.r))),
          child: const AdminDrawerView(),
        ),
        appBar: customAppBar(
            context: context,
            title: const Text("Dashboard"),
            autoLeading: true,
            action: [
              IconButton(
                  onPressed: () {
                    AppServices.pushTo(context, const SettingsView());
                    // generateTxnToken(0);
                    // var response = AllInOneSdk.startTransaction(mid, orderId, amount, txnToken, callbackUrl, isStaging, restrictAppInvoke)
                  },
                  icon: const Icon(Icons.settings))
            ]),
        body: WillPopScope(
          onWillPop: () async {
            if (_key.currentState!.isDrawerOpen) {
              _key.currentState!.closeDrawer();
              return false;
            } else {
              return await FancyDialogController()
                  .showWillPopMsg(context)
                  .show();
            }
          },
          child: SafeArea(
              child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            shrinkWrap: true,
            children: [
              Text("Hello, Admin", style: GetTextTheme.sf24_bold),
              Text("Welcome back!", style: GetTextTheme.sf16_regular),
              AppServices.addHeight(30.h),
              Row(
                children: [
                  TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const AllUserManagerView()),
                      total: userList.length.toString(),
                      title: "Users",
                      icon: AppIcons.profileIcon),
                  AppServices.addWidth(10.w),
                  TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const AdminProviderManager()),
                      total: approvedGuard.length.toString(),
                      title: "Guards",
                      icon: AppIcons.localPoliceIcon)
                ],
              ),
              AppServices.addHeight(10.h),
              Row(
                children: [
                  TotalServicesTiles(
                      ontap: () =>
                          AppServices.pushTo(context, const BookingManager()),
                      total: bookingsList.length.toString(),
                      title: "Bookings",
                      icon: AppIcons.fileIcon),
                  AppServices.addWidth(10.w),
                  TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const ComplaintsTabBarView()),
                      total: complaintsList.length.toString(),
                      title: "Complaints",
                      icon: AppIcons.documentsIcon)
                ],
              ),
              AppServices.addHeight(40.h),
              titleBar(
                  "New Guards",
                  () => AppServices.pushTo(
                      context, const AdminRequestManagerView())),
              AppServices.addHeight(15.h),
              SizedBox(
                  height: 180.sp,
                  child: pendingGuard.isEmpty
                      ? AppServices.getEmptyIcon(
                          "There are no pending requests for new joinee.",
                          "No Data Found")
                      : ListView.builder(
                          itemCount: pendingGuard.toList().length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            final profile = pendingGuard[i];

                            return NewGuardsTile(
                                profile: profile,
                                onApprove: () async => await AuthController()
                                    .approveProfile(
                                        profile.uid, profile, context),
                                onReject: () async => await AuthController()
                                    .rejectProfile(
                                        profile.uid, profile, context));
                          })),
              AppServices.addHeight(35.h),
              titleBar(
                  "New Users",
                  () =>
                      AppServices.pushTo(context, const AllUserManagerView())),
              AppServices.addHeight(15.h),
              SizedBox(
                  height: 180.sp,
                  child: userList.isEmpty
                      ? AppServices.getEmptyIcon(
                          "There are no new users available", "No User Found")
                      : ListView.builder(
                          itemCount: userList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            final profile = userList[i];
                            return NewUsersTile(profile: profile);
                          })),
              AppServices.addHeight(35.h),
              titleBar("New Bookings",
                  () => AppServices.pushTo(context, const BookingManager())),
              AppServices.addHeight(15.h),
              bookingsList.isEmpty
                  ? AppServices.getEmptyIcon(
                      "Looks like no one have booked any guard yet.",
                      "No Bookings Yet",
                      image: AppImages.noBookingImage)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          bookingsList.length > 5 ? 5 : bookingsList.length,
                      itemBuilder: (context, i) {
                        final booking = bookingsList[i];
                        return NewBookingsTile(booking: booking);
                      })
            ],
          )),
        ),
      ),
    );
  }

  Row titleBar(String title, Function ontap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GetTextTheme.sf18_bold),
        InkWell(
            onTap: () => ontap(),
            child: GradientText("View All",
                gradient: AppColors.appGradientColor,
                style: GetTextTheme.sf16_medium))
      ],
    );
  }

  // void generateTxnToken(int mode) async {
  //   String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  //   String callBackUrl =
  //       '${testing ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in'}/theia/paytmCallback?ORDER_ID=$orderId';
  //   var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

  //   var body = json.encode({
  //     "mid": mid,
  //     "key_secret": PAYTM_MERCHANT_KEY,
  //     "website": website,
  //     "orderId": orderId,
  //     "amount": "1",
  //     "callbackUrl": callBackUrl,
  //     "custId": "122",
  //     "mode": mode.toString(),
  //     "testing": testing ? 0 : 1
  //   });

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: body,
  //       headers: {'Content-type': "application/json"},
  //     );
  //     print("Response is");
  //     print(response.body);
  //     String txnToken = response.body;
  //     setState(() {
  //       paymentResponse = txnToken;
  //     });

  //     var paytmResponse = Paytm.payWithPaytm(
  //         mId: mid,
  //         orderId: orderId,
  //         txnToken: txnToken,
  //         txnAmount: "1",
  //         callBackUrl: callBackUrl,
  //         staging: testing,
  //         appInvokeEnabled: false);

  //     paytmResponse.then((value) {
  //       print(value);
  //       setState(() {
  //         print("Value is ");
  //         print(value);
  //         if (value['error']) {
  //           paymentResponse = value['errorMessage'];
  //         } else {
  //           if (value['response'] != null) {
  //             paymentResponse = value['response']['STATUS'];
  //           }
  //         }
  //         paymentResponse += "\n$value";
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

class TotalServicesTiles extends StatelessWidget {
  Function ontap;
  String total, title;
  String icon;
  TotalServicesTiles(
      {super.key,
      required this.ontap,
      required this.total,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: InkWell(
            onTap: () => ontap(),
            child: Container(
                padding: EdgeInsets.all(15.sp),
                height: 110.h,
                decoration: WidgetDecoration.containerDecoration_1(context,
                    enableShadow: true),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientText(total,
                            gradient: AppColors.appGradientColor,
                            style: GetTextTheme.sf20_bold),
                        Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.lightgreyColor.withOpacity(0.3)),
                            child: ImageGradient(
                                image: icon,
                                gradient: AppColors.appGradientColor))
                      ],
                    ),
                    Text("Total $title", style: GetTextTheme.sf16_regular)
                  ],
                ))));
  }
}
