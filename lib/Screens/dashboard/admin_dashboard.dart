// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_bookings_tile.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_guards_tile.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/new_users_tile.dart';
import 'package:valt_security_admin_panel/Screens/managers/booking/booking_manager.dart';
import 'package:valt_security_admin_panel/Screens/managers/complaints/complaints_tab_bar.dart';
import 'package:valt_security_admin_panel/Screens/managers/provider_manager.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/users_manager.dart';
import 'package:valt_security_admin_panel/Screens/settings.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_text.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';

import '../../controllers/admin_callback_controller.dart';
import '../../controllers/app_data_controller.dart';
import '../../controllers/app_functions.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../../models/app_models.dart';
import '../drawer_handler/admin_drawer.dart';
import '../managers/request_manager.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final _adminController = AdminCallbacksController();
  // final firebasedatabase = FirebaseDatabase.instance;
  // final _streamer = AppDataStreamer();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isGuardFetch = true;
  bool isUserFetch = true;
  bool isBookingFetch = true;
  int newGuardsIndex = 0;
  int newUsersIndex = 0;
  int newBookingsIndex = 0;

  Query getUrl() {
    final path = database
        .ref("Providers")
        .orderByChild("isApproved")
        .equalTo(false)
        // .once();
        .limitToFirst(8);
    return path;
  }

  getGuardLength() async {
    final path = await database
        .ref("Providers")
        .orderByChild("isApproved")
        .equalTo(false)
        .once();

    if (!mounted) return;
    setState(() {
      newGuardsIndex = path.snapshot.children.length;
      isGuardFetch = false;
    });
    // .limitToFirst(8);
    return path.snapshot.children.length;
  }

  getUsersLength() async {
    final path = await database.ref("Users").once();

    if (!mounted) return;
    setState(() {
      newUsersIndex = path.snapshot.children.length;
      isUserFetch = false;
    });
    // .limitToFirst(8);
    return path.snapshot.children.length;
  }

  getBookingsLength() async {
    final path = await database.ref("Bookings").once();

    if (!mounted) return;
    setState(() {
      newBookingsIndex = path.snapshot.children.length;
      isBookingFetch = false;
    });
    // .limitToFirst(8);
    return path.snapshot.children.length;
  }

  Query getusersUrl() {
    final path = database.ref("Users").limitToFirst(8);
    return path;
  }

  Query getBookingsUrl() {
    final path = database.ref("Bookings").limitToFirst(5);
    return path;
  }

  Placemark? location;
  decodeLocation(String lat, String lng) async {
    if (!await rebuild()) return;
    location = lat == ""
        ? null
        : await FunctionsController()
            .decodeLocation(double.parse(lat), double.parse(lng));

    setState(() {});
  }

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
    return Scaffold(
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
                onPressed: () =>
                    AppServices.pushTo(context, const SettingsView()),
                icon: const Icon(Icons.settings))
          ]),
      body: WillPopScope(
        onWillPop: () async {
          print(_key.currentState!.isDrawerOpen);
          if (_key.currentState!.isDrawerOpen) {
            _key.currentState!.closeDrawer();
            return false;
          } else {
            return await FancyDialogController().showWillPopMsg(context).show();
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
                Consumer<AppDataController>(builder: (context, data, child) {
                  final userList = data.getAllUsers;
                  return TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const AllUserManagerView()),
                      total: userList.length.toString(),
                      title: "Users",
                      icon: AppIcons.profileIcon);
                }),
                AppServices.addWidth(10.w),
                Consumer<AppDataController>(builder: (context, data, child) {
                  final userList = data.getAllProviders
                      .where((element) => element.isApproved == true)
                      .toList();
                  return TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const AdminProviderManager()),
                      total: userList.length.toString(),
                      title: "Guards",
                      icon: AppIcons.localPoliceIcon);
                }),
              ],
            ),
            AppServices.addHeight(10.h),
            Row(
              children: [
                Consumer<AppDataController>(builder: (context, data, child) {
                  final bookingList = data.getBookings;
                  return TotalServicesTiles(
                      ontap: () =>
                          AppServices.pushTo(context, const BookingManager()),
                      total: bookingList.length.toString(),
                      title: "Bookings",
                      icon: AppIcons.fileIcon);
                }),
                AppServices.addWidth(10.w),
                Consumer<AppDataController>(builder: (context, data, child) {
                  final complaints = data.getAllComplaints;
                  return TotalServicesTiles(
                      ontap: () => AppServices.pushTo(
                          context, const ComplaintsTabBarView()),
                      total: complaints.length.toString(),
                      title: "Complaints",
                      icon: AppIcons.documentsIcon);
                }),
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
              child: Stack(
                children: [
                  FirebaseAnimatedList(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      query: getUrl(),
                      itemBuilder: (context, snapshot, animation, i) {
                        if (i > 0) {
                          isGuardFetch = true;
                        }
                        if (i == 0 && isGuardFetch == true) {
                          getGuardLength();
                        }
                        ProvidersInformationClass profile =
                            ProvidersInformationClass.fromUser(
                                snapshot.value as Map<Object?, Object?>,
                                snapshot.key.toString());
                        decodeLocation(profile.latitude, profile.longitude);

                        return NewGuardsTile(
                            profile: profile, location: location);
                      }),
                  newGuardsIndex == 0
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
                              Text("No Data Found",
                                  style: GetTextTheme.sf18_bold),
                              Text(
                                  "There are no pending requests for new joinee.",
                                  style: GetTextTheme.sf14_regular)
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            AppServices.addHeight(35.h),
            titleBar("New Users",
                () => AppServices.pushTo(context, const AllUserManagerView())),
            AppServices.addHeight(15.h),
            SizedBox(
              height: 180.sp,
              child: Stack(
                children: [
                  FirebaseAnimatedList(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    query: getusersUrl(),
                    itemBuilder: (context, snapshot, animation, i) {
                      if (i > 0) {
                        isUserFetch = false;
                      }
                      if (i == 0 && isUserFetch == true) {
                        getUsersLength();
                      }
                      UserInformationClass profile =
                          UserInformationClass.fromUser(
                              snapshot.value as Map<Object?, Object?>,
                              snapshot.key.toString());

                      return NewUsersTile(profile: profile);
                    },
                  ),
                  newUsersIndex == 0
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
                              Text("No Data Found",
                                  style: GetTextTheme.sf18_bold),
                              Text("There are no new users available.",
                                  style: GetTextTheme.sf14_regular)
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            AppServices.addHeight(35.h),
            titleBar("New Bookings",
                () => AppServices.pushTo(context, const BookingManager())),
            AppServices.addHeight(15.h),
            Stack(
              children: [
                FirebaseAnimatedList(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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
                      return NewBookingsTile(booking: booking);
                    }),
                newBookingsIndex == 0
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
                            Text("No Data Found",
                                style: GetTextTheme.sf18_bold),
                            Text("There are no new bookings available.",
                                style: GetTextTheme.sf14_regular)
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            )
          ],
        )),
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
