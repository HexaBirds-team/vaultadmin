import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../helpers/style_sheet.dart';
import 'firebase_controller.dart';

class FunctionsController {
  Future<String> uploadImageToStorage(File imageFile, {String url = ""}) async {
    if (url.isNotEmpty) {
      await storage.refFromURL(url).delete();
    }

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

// function to convert latLng to address for user Readable.
  Future<Placemark> convertLatLngToAddress(
      double position1, double position2, BuildContext context) async {
    // final db = Provider.of<AppDataController>(context, listen: false);
    // db.setLoader(true);

    final location = await placemarkFromCoordinates(position1, position2);
    // db.setLoader(false);

    return location.first;
  }

  generateId({int length = 7}) {
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
    ];

    String id = "";

    String randomChoice() {
      Random random = Random();
      int index = random.nextInt(characters.length);
      return characters[index];
    }

    for (var i = 0; i < length; i++) {
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

  List<String> getTokens(Map<String, dynamic> data) {
    List<String> tokens = [];
    data.forEach((key, value) {
      print(key.toString());
      tokens.add(key.toString());
    });
    return tokens;
  }

  String titleCase(String text) {
    var a = text.trim().split(" ");
    var b = a.map((e) {
      var c = e.trim().split("");
      c[0] = c[0].toUpperCase();
      return c.join();
    });

    return b.join(" ");
  }

  // Function to check Internet available or not
  static Future<bool> checkInternetConnectivity(context) async {
    bool result = await InternetConnectionChecker().hasConnection;

    return result;
  }

  static getNotificationIcon(String notificationType) {
    switch (notificationType) {
      case "announcement":
        return AppIcons.notification_announcement;
      case "complaint":
        return AppIcons.notification_complaint;
      case "guard":
        return AppIcons.notification_guard;
      case "payment":
        return AppIcons.notification_payment;
      case "reject":
        return AppIcons.notification_cancel;

      default:
        return AppIcons.documentsIcon;
    }
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
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
