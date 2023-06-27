import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import 'app_data_controller.dart';
import 'firebase_controller.dart';

class AppDataStreamer {
// notification stream handler
  notificationStream(BuildContext context) {
    return database
        .ref("Notifications")
        .orderByChild("isAdmin")
        .equalTo(true)
        .onValue
        .listen((event) {
      final data = event.snapshot.children;
      final db = Provider.of<AppDataController>(context, listen: false);

      for (var notification in data) {
        db.getNotifications.any((element) => element.id == notification.key)
            ? null
            : db.addNotification(NotificationModel.fromNotification(
                notification.value as Map<Object?, Object?>,
                notification.key.toString()));
      }
    });
  }

// announcement stream handler
  // announcementStream(BuildContext context) {
  //   return database.ref("Announcements").onValue.listen((event) {
  //     final data = event.snapshot.children;
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     db.getAnnouncements
  //             .any((element) => element.id == event.snapshot.key.toString())
  //         ? null
  //         : db.setAnnouncements(data
  //             .map((e) => AnnouncementClass.fromJson(
  //                 e.value as Map<Object?, Object?>, e.key.toString()))
  //             .toList());
  //   });
  // }

// offers stream handler
  // offerStream(BuildContext context) {
  //   return database.ref("Offers").onValue.listen((event) {
  //     final data = event.snapshot.children;

  //     final db = Provider.of<AppDataController>(context, listen: false);

  //     for (var offer in data) {
  //       db.getOffers.any((element) => element.id == offer.key)
  //           ? null
  //           : db.addOffers(OfferClass.fromJson(
  //               offer.value as Map<Object?, Object?>, offer.key.toString()));
  //     }
  //   });
  // }
}
