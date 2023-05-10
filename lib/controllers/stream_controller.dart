// import 'package:edu_market/models/data_classes.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

// import '../main.dart';
// import 'app_data_controller.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import 'app_data_controller.dart';

class AppDataStreamer {
  /* User Category Type Event Listners */
  onCategoryAdded(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final database = Provider.of<AppDataController>(context, listen: false);
    database.isCategoryAvailable(event.snapshot.key.toString())
        ? null
        : database.addNewCategory(
            CategoryClass.fromCategory(data, event.snapshot.key.toString()));
  }

  onCategoryRemoved(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final database = Provider.of<AppDataController>(context, listen: false);
    database.removeCategory(event.snapshot.key.toString());
  }

  onProviderChanged(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final db = Provider.of<AppDataController>(context, listen: false);
    db.updateProfile(ProvidersInformationClass.fromUser(
        data, event.snapshot.key.toString()));
  }

  onGuardAdded(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final db = Provider.of<AppDataController>(context, listen: false);
    db.addNewProviderData(ProvidersInformationClass.fromUser(
        data, event.snapshot.key.toString()));
  }

  onUserAdded(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final db = Provider.of<AppDataController>(context, listen: false);
    db.getAllUsers
            .any((element) => element.uid == event.snapshot.key.toString())
        ? null
        : db.addNewUser(
            UserInformationClass.fromUser(data, event.snapshot.key.toString()));
  }

  onComplaintAdded(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final db = Provider.of<AppDataController>(context, listen: false);
    if (db.getAllComplaints.any(
        (element) => element.complaintId == event.snapshot.key.toString())) {
      null;
    } else {
      db.addNewComplaint(
          ComplaintsClass.fromComplaint(data, event.snapshot.key.toString()));
    }
  }

  onBookingAdded(DatabaseEvent event, BuildContext context) {
    final data = event.snapshot.value as Map<Object?, Object?>;
    final db = Provider.of<AppDataController>(context, listen: false);
    if (db.getBookings
        .any((element) => element.id == event.snapshot.key.toString())) {
      null;
    } else {
      db.addNewBooking(
          BookingsClass.fromBooking(data, event.snapshot.key.toString()));
    }
  }

  onReviewAdded(BuildContext context, DatabaseEvent event) {
    final db = Provider.of<AppDataController>(context, listen: false);
    final data = event.snapshot.value as Map<Object?, Object?>;
    final id = event.snapshot.key.toString();
    if (db.getReviews.any((element) => element.id == id)) {
      null;
    } else {
      db.addReview(ReviewsModel.fromJson(data, id));
    }
  }

//   /* Organization Data Event Listners */
//   onProfileAdded(DatabaseEvent event, BuildContext context) {
//     final data = event.snapshot.value as Map<Object?, Object?>;
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.isOrganizationAvailable(event.snapshot.key.toString())
//         ? null
//         : database.addNewProfileData(OrganizationProfileClass.fromOrg(
//             data, event.snapshot.key.toString()));
//   }

//   onProfileUpdated(DatabaseEvent event, BuildContext context) {
//     final data = event.snapshot.value as Map<Object?, Object?>;
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.updateProfile(
//         OrganizationProfileClass.fromOrg(data, event.snapshot.key.toString()));
//   }

//   onFavAdded(DatabaseEvent event, BuildContext context) {
//     final data = event.snapshot.value as Map<Object?, Object?>;
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     if (data['userId'].toString() == preference.getString("uid")) {
//       database.markFavorite(
//           FavoriteModel.fromFavorites(data, event.snapshot.key.toString()));
//     }
//   }

//   onLiked(DatabaseEvent event, BuildContext context) {
//     final data = event.snapshot.value as Map<Object?, Object?>;
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     if (data['userId'].toString() == preference.getString("uid")) {
//       database
//           .markLiked(LikesModel.fromLikes(data, event.snapshot.key.toString()));
//     }
//   }

//   /* Org Details Streamer in Public View */
//   onFavoriteAdded(DatabaseEvent event, String profId, BuildContext context) {
//     var data = event.snapshot.value as Map<Object?, Object?>;
//     if (data['orgId'].toString() == profId) {
//       return event.snapshot.key.toString();
//       // favCounts.add(event.snapshot.key.toString());
//     } else {
//       return "";
//     }
//   }
}
