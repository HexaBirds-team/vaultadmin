// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import '../app_config.dart';
import 'app_data_controller.dart';
import 'app_settings_controller.dart';
import 'firestore_api_reference.dart';

class NotificationController {
  sendFCM(Map<String, dynamic> snapshot, String to) async {
    final Map<String, dynamic> data = {
      'priority': 'high',
      "notification": {
        "title": snapshot['title'].toString(),
        "body": snapshot['body'].toString()
      },
      "data": {"click_action": snapshot['route'], "id": "1", "status": "done"},
      "to": to
    };

    final Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "key=${AppConfig.firebaseMessagingKey}"
    };
    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: header, body: jsonEncode(data));
  }

  uploadNotification(String api, Map<String, dynamic> data) async {
    final path = database.ref(api).push();
    await path.set(data);
    return;
  }

  void firebaseMessagingForegroundHandler(RemoteMessage message) async {
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
        android: AndroidNotificationDetails(
            'Volt_notification_id', 'Volt_notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'));
    await FlutterLocalNotificationsPlugin().show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data.toString());
  }

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      NotificationController().firebaseMessagingForegroundHandler(message);
    });
  }

  void requestPermission(BuildContext context) async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      getToken(context);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provissional permission");
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken(BuildContext context) async {
    await messaging.getToken().then((token) {
      saveToken(token!, context);
      return token;
    }).onError((error, stackTrace) => saveToken("Not Available", context));
  }

  saveToken(String token, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    String mToken = await preference.getString("Token") ?? "";
    if (mToken == "" ||
        (db.adminDetails)['token'] == null ||
        (db.adminDetails['token'] != mToken)) {
      await FirestoreApiReference.adminPath.update({"token": token});
      await preference.setString("Token", token);
    } else {
      null;
    }
  }

/* send notification function handler */

// notification after profile approval of guard
  // approveProfileNotification(ProvidersInformationClass guard) async {
  //   Map<String, dynamic> data = {
  //     "title": "Approval Accepted",
  //     "body": "Your profile has been accepted by admin.",
  //     "route": "/Dashboard",
  //     "createdAt": DateTime.now().toIso8601String(),
  //     "notificationType": "approved",
  //     "receiver": guard.uid,
  //     "isAdmin": false
  //   };
  //   for (var token in guard.tokens) {
  //     await NotificationController()
  //         .sendFCM(data, token.split("?deviceId").first);
  //   }
  //   await NotificationController().uploadNotification("Notifications", data);
  // }

// notification after rejection of guard profile
  // rejectProfileNotification(ProvidersInformationClass guard) async {
  //   Map<String, dynamic> data = {
  //     "title": "Approval Rejected",
  //     "body": "Your account approval request has been rejected by the Admin.",
  //     "route": "/Documents",
  //     "createdAt": DateTime.now().toIso8601String(),
  //     "notificationType": "reject",
  //     "receiver": guard.uid,
  //     "isAdmin": false
  //   };
  //   for (var token in guard.tokens) {
  //     await NotificationController()
  //         .sendFCM(data, token.split("?deviceId").first);
  //   }
  //   await NotificationController().uploadNotification("Notifications", data);
  // }

// document invalid notification function
  // guardDocInvalidNotification(ProvidersInformationClass guard) async {
  //   Map<String, dynamic> data = {
  //     "title": "Invalid KYC documents",
  //     "body":
  //         "Some of your KYC documents are marked as invalid. Please update your documents to complete the KYC process.",
  //     "route": "/Documents",
  //     "createdAt": DateTime.now().toIso8601String(),
  //     "notificationType": "document",
  //     "receiver": guard.uid
  //   };
  //   for (var token in guard.tokens) {
  //     await NotificationController()
  //         .sendFCM(data, token.split("?deviceId").first);
  //   }
  //   NotificationController().uploadNotification("Notifications", data);
  // }

  // payment refund notification
  paymentRefundNotification(
      UserInformationClass user, BookingsClass booking) async {
    Map<String, dynamic> data = {
      "title": "Payment Refund",
      "body":
          "Your payment has been refunded for the ${booking.bookingId} booking",
      "route": "/Notification",
      "createdAt": DateTime.now().toIso8601String(),
      "notificationType": "payment",
      "receiver": user.uid
    };

    for (var token in user.token) {
      sendFCM(data, token.split("?deviceId").first);
    }
    uploadNotification("Notifications", data);
  }
}
