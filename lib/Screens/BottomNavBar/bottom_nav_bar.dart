// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:valt_security_admin_panel/Screens/dashboard/admin_dashboard.dart';
import 'package:valt_security_admin_panel/Screens/managers/notifications/notfication.dart';
import 'package:valt_security_admin_panel/Screens/managers/request_manager.dart';
import 'package:valt_security_admin_panel/Screens/reviews/reviews_view.dart';
import 'package:valt_security_admin_panel/components/fancy_popus/awesome_dialogs.dart';

import '../../controllers/app_functions.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/stream_controller.dart';
import '../../helpers/base_getters.dart';

class BottomNavBar extends StatefulWidget {
  int routeIndex;
  BottomNavBar({super.key, this.routeIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late StreamSubscription<DatabaseEvent> ref;
  late StreamSubscription<DatabaseEvent> userRef;
  late StreamSubscription<DatabaseEvent> complaintRef;
  late StreamSubscription<DatabaseEvent> bookingRef;
  late StreamSubscription<DatabaseEvent> reviewsEvent;
  late StreamSubscription<DatabaseEvent> notificationRef;

  List<Widget> screens = [
    const AdminDashboard(),
    const AdminRequestManagerView(),
    const ReviewsView(),
    const NotificationsView()
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.routeIndex;
    });
    getListeneres();
    NotificationController().requestPermission();
    NotificationController().getToken(context);
    NotificationController().initLocalNotifications();
  }

  getListeneres() {
    final dataRef = database.ref("Providers");

    AppDataStreamer().onGuardAdded(context);

    ref = dataRef.onChildChanged
        .listen((event) => AppDataStreamer().onProviderChanged(event, context));
    userRef = AppDataStreamer().userStream(context);
    complaintRef = AppDataStreamer().complaintStream(context);
    bookingRef = AppDataStreamer().bookingStream(context);
    reviewsEvent = AppDataStreamer().onReviewAdded(context);
    notificationRef = AppDataStreamer().notificationStream(context);
  }

  @override
  void dispose() {
    super.dispose();
    ref.cancel();
    userRef.cancel();
    complaintRef.cancel();
    bookingRef.cancel();
    reviewsEvent.cancel();
    notificationRef.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => currentIndex == 0
          ? FancyDialogController().showWillPopMsg(context).show()
          : AppServices.pushAndRemove(BottomNavBar(routeIndex: 0), context),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) => setState(() {
                  currentIndex = value;
                }),
            items: const [
              BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: "Requests", icon: Icon(Icons.file_copy)),
              BottomNavigationBarItem(
                  label: "Reviews", icon: Icon(Icons.reviews)),
              BottomNavigationBarItem(
                  label: "Notifications", icon: Icon(Icons.notifications)),
            ]),
        body: screens[currentIndex],
      ),
    );
  }
}
