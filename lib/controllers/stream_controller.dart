import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import 'app_data_controller.dart';
import 'firebase_controller.dart';

class AppDataStreamer {
  /* User Category Type Event Listners */
  // onCategoryAdded(DatabaseEvent event, BuildContext context) {
  //   final data = event.snapshot.value as Map<Object?, Object?>;
  //   final database = Provider.of<AppDataController>(context, listen: false);
  //   database.isCategoryAvailable(event.snapshot.key.toString())
  //       ? null
  //       : database.addNewCategory(
  //           CategoryClass.fromCategory(data, event.snapshot.key.toString()));
  // }

  // onCategoryRemoved(DatabaseEvent event, BuildContext context) {
  //   final database = Provider.of<AppDataController>(context, listen: false);
  //   database.removeCategory(event.snapshot.key.toString());
  // }

  // onProviderChanged(DatabaseEvent event, BuildContext context) {
  //   final data = event.snapshot.value as Map<Object?, Object?>;
  //   print("provider updated");
  //   final db = Provider.of<AppDataController>(context, listen: false);
  //   db.updateProfile(ProvidersInformationClass.fromUser(
  //       data, event.snapshot.key.toString()));
  // }

  // onGuardAdded(BuildContext context) {
  //   database.ref("Providers").onChildAdded.listen((event) {
  //     final data = event.snapshot.value as Map<Object?, Object?>;
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     db.getAllProviders.any((element) => element.uid == event.snapshot.key)
  //         ? null
  //         : {
  //             db.addNewProviderData(ProvidersInformationClass.fromUser(
  //                 data, event.snapshot.key.toString())),
  //           };
  //   });
  // }

  // userStream(BuildContext context) {
  //   return database.ref("Users").onValue.listen((event) {
  //     final data = event.snapshot.children;
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     db.getAllUsers
  //             .any((element) => element.uid == event.snapshot.key.toString())
  //         ? null
  //         : db.setUsersListData(data
  //             .map((e) => UserInformationClass.fromUser(
  //                 e.value as Map<Object?, Object?>, e.key.toString()))
  //             .toList());
  //   });
  // }

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
      // db.setNotifications(data
      //     .map((e) => NotificationModel.fromNotification(
      //         e.value as Map<Object?, Object?>, e.key.toString()))
      //     .toList());
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
  offerStream(BuildContext context) {
    return database.ref("Offers").onValue.listen((event) {
      final data = event.snapshot.children;

      final db = Provider.of<AppDataController>(context, listen: false);

      for (var offer in data) {
        db.getOffers.any((element) => element.id == offer.key)
            ? null
            : db.addOffers(OfferClass.fromJson(
                offer.value as Map<Object?, Object?>, offer.key.toString()));
      }

      // db.setOffers(data
      //     .map((e) => OfferClass.fromJson(
      //         e.value as Map<Object?, Object?>, e.key.toString()))
      //     .toList());
    });
  }

  // complaintStream(BuildContext context) {
  //   return database.ref("Complaints").onValue.listen((event) {
  //     final data = event.snapshot.children;
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     if (db.getAllComplaints.any(
  //         (element) => element.complaintId == event.snapshot.key.toString())) {
  //       null;
  //     } else {
  //       db.setComplaintsData(data
  //           .map((e) => ComplaintsClass.fromComplaint(
  //               e.value as Map<Object?, Object?>, e.key.toString()))
  //           .toList());
  //     }
  //   });
  // }

  // bookingStream(BuildContext context) {
  //   return database.ref("Bookings").onValue.listen((event) {
  //     final data = event.snapshot.children;
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     if (db.getBookings
  //         .any((element) => element.id == event.snapshot.key.toString())) {
  //       null;
  //     } else {
  //       db.setBookingsList(data
  //           .map((e) => BookingsClass.fromBooking(
  //               e.value as Map<Object?, Object?>, e.key.toString()))
  //           .toList());
  //     }
  //   });
  // }

  // onReviewAdded(BuildContext context) {
  //   return database.ref("Reviews").onChildAdded.listen((event) {
  //     final db = Provider.of<AppDataController>(context, listen: false);
  //     final data = event.snapshot.value as Map<Object?, Object?>;
  //     final id = event.snapshot.key.toString();
  //     if (db.getReviews.any((element) => element.id == id)) {
  //       null;
  //     } else {
  //       db.addReview(ReviewsModel.fromJson(data, id));
  //     }
  //   });
  // }
}
