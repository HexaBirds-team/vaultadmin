// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../app_config.dart';
import 'app_data_controller.dart';
import 'app_functions.dart';
import 'app_settings_controller.dart';

class NotificationController {
  sendFCM(Map<String, dynamic> snapshot, String to) async {
    final Map<String, dynamic> data = {
      'priority': 'high',
      "notification": {
        "title": snapshot['title'].toString(),
        "body": snapshot['body'].toString()
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
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

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
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
    });
  }

  saveToken(String token, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    String mToken = await preference.getString("Token") ?? "";
    if (mToken == "" ||
        (db.adminDetails)['token'] == null ||
        (db.adminDetails['token'] != mToken)) {
      await database.ref("Admin").update({"token": token});
      await preference.setString("Token", token);
    } else {
      null;
    }
  }
}
