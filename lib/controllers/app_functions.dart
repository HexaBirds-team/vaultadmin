import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../helpers/style_sheet.dart';
import 'app_data_controller.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseDatabase database = FirebaseDatabase.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

class FunctionsController {
  getUserCategory(BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    final snapshot = await database.ref("Categories").get();
    if (snapshot.exists) {
      final data = snapshot.children;
      db.setUserCategoryList(data
          .map((e) => CategoryClass.fromCategory(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList());
    }
  }

  getLocation(String lat, String lng) async {
    Placemark? location;
    location = lat == ""
        ? null
        : await FunctionsController()
            .decodeLocation(double.parse(lat), double.parse(lng));

    return location == null
        ? ""
        : "${location.street}, ${location.subLocality}, ${location.locality}, ${location.administrativeArea}";
  }

  Future<String> uploadImageToStorage(
    File imageFile,
  ) async {
    final storageReference =
        storage.ref().child("Categories/${DateTime.now()}.jpg");
    final uploadTask = storageReference.putFile(imageFile);
    final storageSnapshot = await uploadTask;
    final String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<CroppedFile?> cropImage(
      {required String path, bool squareRatio = false}) async {
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: AppColors.primary1,
              toolbarWidgetColor: AppColors.whiteColor,
              initAspectRatio: squareRatio
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.ratio16x9,
              lockAspectRatio: true),
          IOSUiSettings(title: 'Image Cropper'),
        ]);
    if (croppedImage == null) {
      return null;
    } else {
      return croppedImage;
    }
  }

  Future<Placemark> decodeLocation(double lat, double lng) async {
    final placemark = await placemarkFromCoordinates(lat, lng);
    final location = placemark.first;
    return location;
  }

  generateId() {
    List<String> characters = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "0",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z",
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
      // "_",
      // "%",
      // "\$",
      // "-"
    ];

    String id = "";

    String randomChoice() {
      Random random = Random();
      int index = random.nextInt(characters.length);
      return characters[index];
    }

    for (var i = 0; i < 7; i++) {
      String character = randomChoice();
      id += character;
    }

    return id;
  }

  // Funtion To Filter review List
  static List<ReviewsModel> filterReviewList(
      List<ReviewsModel> reviewList, double startWith, double endWith) {
    return reviewList
        .where((element) =>
            element.ratings >= startWith && element.ratings <= endWith)
        .toList();
  }

  // function to get average rating provider user
  static double averageRating(List<ReviewsModel> reviewModel) {
    double ratingCount = 0;
    for (var review in reviewModel) {
      ratingCount += review.ratings;
    }
    return ratingCount / reviewModel.length;
  }

  static getReviews(BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    final path = database.ref("Reviews");
    final snapshot = await path.get();
    db.addAllReviews(snapshot.children
        .map((e) => ReviewsModel.fromJson(
            e.value as Map<Object?, Object?>, e.key.toString()))
        .toList());
  }

//   getUserProfile(BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     final path = _database.ref("users/${preference.getString("uid")}");
//     final snapshot = await path.get();
//     if (snapshot.exists) {
//       database.setUserPersonalData(UserInformationClass.fromUser(
//           snapshot.value as Map<Object?, Object?>));
//     }
//   }

//   getOrganizationProfile(BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     final path = _database.ref("organizations/${preference.getString("uid")}");
//     final snapshot = await path.get();
//     if (snapshot.exists) {
//       database.setOrgInfoData(OrganizationProfileClass.fromOrg(
//           snapshot.value as Map<Object?, Object?>, snapshot.key.toString()));
//     }
//   }

//   getAllServicesList(BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     final path = _database.ref("services");
//     final snapshot = await path.get();
//     if (snapshot.exists) {
//       print(snapshot.children);
//       database.setServicesList(snapshot.children
//           .map((e) => OrgServicesClass.fromService(
//               e.value as Map<Object?, Object?>, e.key.toString()))
//           .toList());
//     }
//   }

  // Future<List<ProvidersInformationClass>> getProviders(
  //     BuildContext context) async {
  //   final db = Provider.of<AppDataController>(context, listen: false);
  //   final path = database.ref("Providers");

  //   // final path2 = database.ref("Providers/services");
  //   final snapshot = await path.get();
  //   // final snapshot2 = await path2.get();
  //   if (snapshot.exists) {
  //     var myList = snapshot.children
  //         .map((e) => ProvidersInformationClass.fromUser(
  //             e.value as Map<Object?, Object?>, e.key.toString()))
  //         .toList();
  //     db.setProvidersData(myList);

  //     return myList;
  //   } else {
  //     return [];
  //   }
  // }

  List<GuardServices> getServices(Map<Object?, Object?> data) {
    List<GuardServices> snapshot = [];
    data.forEach((key, value) {
      snapshot.add(GuardServices.fromService(
          value as Map<Object?, Object?>, key.toString()));
    });
    return snapshot;
  }

  List<String> getTokens(Map<Object?, Object?> data) {
    List<String> tokens = [];
    data.forEach((key, value) {
      print(key.toString());
      tokens.add(key.toString());
    });
    return tokens;
  }

  List<DocsClass> getDocs(List<Object?> data) {
    List<DocsClass> snapshot = [];
    for (var element in data) {
      snapshot.add(DocsClass.fromDocs(element as Map<Object?, Object?>));
    }
    return snapshot;
  }

  getComplaints(BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    final path = database.ref("Complaints");
    final snapshot = await path.get();
    if (snapshot.exists) {
      var complaintLists = snapshot.children
          .map((e) => ComplaintsClass.fromComplaint(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList();
      db.setComplaintsData(complaintLists);
    } else {
      null;
    }
  }

  getBookings(BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    final path = database.ref("Bookings");
    final snapshot = await path.get();
    if (snapshot.exists) {
      var bookingLists = snapshot.children
          .map((e) => BookingsClass.fromBooking(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList();

      db.setBookingsList(bookingLists);
    } else {
      null;
    }
  }
}

extension CheckTimeAgo on DateTime {
  String timeAgo({bool numericDates = true}) {
    var date1 = DateTime.now();
    final difference = date1.difference(this);
    if ((difference.inDays / 7).floor() >= 2) {
      return DateFormat("yyyy-MM-dd").format(this);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
