import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_controller.dart';

class FirestoreApiReference {
  static const String notificationUrl = "https://fcm.googleapis.com/fcm/send";

  /* filters of firestore database */

  // guard filter with phone
  static Query<Map<String, dynamic>> getGuardByPhone(String phone) =>
      firestore.collection("Providers").where("phone", isEqualTo: phone);

  // announcement filter with receiver
  static Query<Map<String, dynamic>> getAnnouncement = firestore
      .collection("Announcements")
      .where("receiver", isEqualTo: "guard");

  // offer filter with receiver
  static Query<Map<String, dynamic>> getOffers =
      firestore.collection("Offers").where("receiver", isEqualTo: "guard");

  // notification filter with receiver
  static Query<Map<String, dynamic>> getNotifications(String id) =>
      firestore.collection("Notifications").where("receiver", isEqualTo: id);

  // complaints filter with createdBy
  static Query<Map<String, dynamic>> complaintsQuery(String id) =>
      firestore.collection("Complaints").where("createdBy", isEqualTo: id);

  // likes filter by guardid
  static Query<Map<String, dynamic>> likesQuery(String id) =>
      firestore.collection("Likes").where("GuardId", isEqualTo: id);

  // bookings filter by guardid
  static Query<Map<String, dynamic>> bookingsQuery(String id) =>
      firestore.collection("Bookings").orderBy("GuardId").startAt([id]);

  /* document references */

  // single guard reference
  static DocumentReference<Map<String, dynamic>> guardApi(String id) =>
      firestore.collection("Providers").doc(id);

  // single complaint reference
  static DocumentReference<Map<String, dynamic>> complaintApi(String id) =>
      firestore.collection("Complaints").doc(id);

  // single subscription reference
  static DocumentReference<Map<String, dynamic>> subscriptionApi(String id) =>
      firestore.collection("Subscriptions").doc(id);

  // admin document reference
  static DocumentReference<Map<String, dynamic>> adminPath =
      firestore.collection("Admin").doc("2W9egbPwPac12SKR6Qv2");

/* collection references */

  // category reference
  static CollectionReference<Map<String, dynamic>> categoryPath =
      firestore.collection("Categories");

  // subscription difference reference
  static CollectionReference<Map<String, dynamic>> subDifferencePath(String id) => FirestoreApiReference.categoryPath.doc(id).collection("subscription_difference");

  // service reference
  static CollectionReference<Map<String, dynamic>> servicePath =
      firestore.collection("Services");

  // guard document reference
  static CollectionReference<Map<String, dynamic>> guardDocumentPath(
          String id) =>
      firestore.collection("Providers").doc(id).collection("docs");

  // user document reference
  static CollectionReference<Map<String, dynamic>> userDocumentPath(
          String id) =>
      firestore.collection("Users").doc(id).collection("documents");

  // guard services reference
  static CollectionReference<Map<String, dynamic>> guardServicesPath(
          String id) =>
      firestore.collection("Providers").doc(id).collection("services");

  // users reference
  static CollectionReference<Map<String, dynamic>> usersPath =
      firestore.collection("Users");

  // guards reference
  static CollectionReference<Map<String, dynamic>> guardsPath =
      firestore.collection("Providers");

  // reviews reference
  static CollectionReference<Map<String, dynamic>> reviewsApi =
      firestore.collection("Reviews");

// complains reference
  static CollectionReference<Map<String, dynamic>> complaintsPath =
      firestore.collection("Complaints");

// complaints message reference
  static CollectionReference<Map<String, dynamic>> complaintsMsgPath(
          String id) =>
      firestore.collection("Complaints").doc(id).collection('messages');

  // subscription collection reference
  static CollectionReference<Map<String, dynamic>> subscriptionPath =
      firestore.collection("Subscriptions");

  // banners collection reference
  static CollectionReference<Map<String, dynamic>> bannersPath =
      firestore.collection("Banners");

  // service area collection reference
  static CollectionReference<Map<String, dynamic>> serviceAreaPath =
      firestore.collection("ServiceAreas");

  // bookings collection reference
  static CollectionReference<Map<String, dynamic>> bookingsPath =
      firestore.collection("Bookings");
}
