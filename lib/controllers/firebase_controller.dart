// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../Screens/BottomNavBar/bottom_nav_bar.dart';
import '../helpers/base_getters.dart';
import 'app_data_controller.dart';
import 'app_settings_controller.dart';

// instance of firebase authentication.
final auth = FirebaseAuth.instance;

// instance of firebase Database.
final database = FirebaseDatabase.instance;

// instance of firebase Storage.
final storage = FirebaseStorage.instance;

// instance of firebase notifications;
FirebaseMessaging messaging = FirebaseMessaging.instance;

// instance of firebase cloud storage;
final firestore = FirebaseFirestore.instance;

class FirebaseController {
  BuildContext context;
  FirebaseController(this.context);

  AppDataController db() =>
      Provider.of<AppDataController>(context, listen: false);

// login function
  onLogin(String username, String password) async {
    db().setLoader(true);
    try {
      final path = await FirestoreApiReference.adminPath.get();
      final data = path.data()!;
      if (data['username'].toString() == username &&
          data['password'].toString() == password) {
        db().setAdminDetails(data);
        await preference.setBool("isLogin", true);
        AppServices.pushAndRemove(BottomNavBar(), context);
        db().setLoader(false);
      } else {
        MySnackBar.error(context, "Username or password doesn't match");
        db().setLoader(false);
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      db().setLoader(false);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      db().setLoader(false);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      db().setLoader(false);
    }
  }

  /* Manage Category Callbacks */

// function to add new category
  // addNewCategoryCallback(
  //   Map<String, dynamic> data,
  // ) async {
  //   try {
  //     await FirestoreApiReference.categoryPath.add(data).then((value) =>
  //         db().addNewCategory(CategoryClass.fromCategory(data, value.id)));

  //     AppServices.pushTo(context, screen)
  //   } on FirebaseException catch (e) {
  //     MySnackBar.error(context, e.message.toString());
  //     AppServices.popView(context);
  //   } on SocketException {
  //     MySnackBar.info(context, "Internet Error");
  //     AppServices.popView(context);
  //   } catch (e) {
  //     MySnackBar.error(context, e.toString());
  //     AppServices.popView(context);
  //   }
  // }

  // function to edit  category
  editCategoryCallBack(Map<String, dynamic> data, String id) async {
    try {
      await FirestoreApiReference.categoryPath.doc(id).update(data).then(
          (value) => db().updateCategory(CategoryClass.fromCategory(data, id)));

      MySnackBar.success(context, "category updated successfully");
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
    }
  }

  // function to delete category from database

  deleteCategoryCallBack(String id) async {
    try {
      await FirestoreApiReference.categoryPath
          .doc(id)
          .delete()
          .then((value) => db().removeCategory(id));
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
    }
  }

// function to get categories
  getUserCategory() async {
    try {
      final snapshot = await FirestoreApiReference.categoryPath.get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs;
        db().setUserCategoryList(data
            .map((e) => CategoryClass.fromCategory(e.data(), e.id.toString()))
            .toList());
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

// function to add subscription
  addNewCategoryCallback(
    Map<String, dynamic> data,
  ) async {
    try {
      final snapshot = await FirestoreApiReference.categoryPath.add(data);
      db().addNewCategory(CategoryClass.fromCategory(data, snapshot.id));
      var differenceData = db().getSubDifference;
      if (differenceData.isNotEmpty) {
        for (var difference in differenceData) {
          await FirestoreApiReference.subDifferencePath(snapshot.id)
              .add(difference.toJson());
        }
      }
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(
          context, "Add Category error : \n${e.message.toString()}");
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, "Add Category error : \n${e.toString()}");
    }
  }

// function to add services
  addNewServiceCallback(
    Map<String, dynamic> data,
  ) async {
    try {
      await FirestoreApiReference.servicePath.add(data).then((value) => db()
          .addService(
              ServiceClass(data['categoryId'], data['name'], value.id)));
      MySnackBar.success(context, "New Service added successfully");
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
    }
  }

// function to update services
  updateService(
    Map<String, dynamic> data,
    String id,
  ) async {
    try {
      await FirestoreApiReference.servicePath.doc(id).update(data).then(
          (value) => db().updateServices(
              id, ServiceClass(data['categoryId'], data['name'], id)));
      MySnackBar.success(context, "Service updated successfully");
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
    }
  }

// function to delete service
  deleteService(String id) async {
    db().setLoader(true);
    try {
      await FirestoreApiReference.servicePath
          .doc(id)
          .delete()
          .then((value) => db().removeService(id));
      AppServices.popView(context);
      db().setLoader(false);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
      db().setLoader(false);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
      db().setLoader(false);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
      db().setLoader(false);
    }
  }

// function to update subscriptions
  updateSubscription(
    String amount,
    String id,
  ) async {
    try {
      await FirestoreApiReference.subscriptionApi(id)
          .update({'amount': amount}).then(
              (value) => db().updateSubscriptions(id, amount));

      MySnackBar.success(context, "Subscription updated successfully");
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
    }
  }

// function to get subscriptions
  getSubscriptions() async {
    try {
      await FirestoreApiReference.subscriptionPath.get().then((value) => db()
          .setSubscriptions(value.docs
              .map((e) => SubscriptionClass.fromSubscription(e.data(), e.id))
              .toList()));
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

// function to get users
  getUsersList() async {
    try {
      final snapshot = await FirestoreApiReference.usersPath.get();
      if (snapshot.docs.isNotEmpty) {
        final datalist = snapshot.docs;
        db().setUsersListData(datalist
            .map(
                (e) => UserInformationClass.fromUser(e.data(), e.id.toString()))
            .toList());
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

// function to get guards
  getGuardsList() async {
    try {
      final snapshot = await FirestoreApiReference.guardsPath.get();
      if (snapshot.docs.isNotEmpty) {
        final datalist = snapshot.docs;
        // print((datalist.first.data())['msgToken']);
        db().setProvidersData(datalist
            .map((e) =>
                ProvidersInformationClass.fromUser(e.data(), e.id.toString()))
            .toList());

        for (var guard in db().getAllProviders) {
          Placemark? place = guard.latitude == ""
              ? null
              : await FunctionsController().convertLatLngToAddress(
                  double.parse(guard.latitude),
                  double.parse(guard.longitude),
                  context);
          db().updateProviderAddress(
              guard.uid,
              place == null
                  ? ""
                  : '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}');
        }
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

  Future<List<DocsClass>> getUserDocs(String id) async {
    try {
      List<DocsClass> snapshot = [];
      var services = await FirestoreApiReference.userDocumentPath(id).get();
      snapshot =
          services.docs.map((e) => DocsClass.fromDocs(e.data(), e.id)).toList();
      return snapshot;
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      return [];
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      return [];
    } catch (e) {
      MySnackBar.error(context, e.toString());
      return [];
    }
  }

  getServiceArea() async {
    try {
      List<ServiceAreaClass> snapshot = [];
      var services = await FirestoreApiReference.serviceAreaPath.get();
      db().setServiceArea(services.docs
          .map((e) => ServiceAreaClass.fromJson(e.data(), e.id))
          .toList());
      return snapshot;
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      return [];
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      return [];
    } catch (e) {
      MySnackBar.error(context, e.toString());
      return [];
    }
  }

  // function to get reviews
  getReviews() async {
    try {
      final snapshot = await FirestoreApiReference.reviewsApi.get();
      if (snapshot.docs.isNotEmpty) {
        db().addAllReviews(snapshot.docs
            .map((e) => ReviewsModel.fromJson(e.data(), e.id.toString()))
            .toList());
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

  // function to get complaints
  getComplaints() async {
    try {
      final snapshot = await FirestoreApiReference.complaintsPath.get();
      if (snapshot.docs.isNotEmpty) {
        var complaintLists = snapshot.docs
            .map(
                (e) => ComplaintsClass.fromComplaint(e.data(), e.id.toString()))
            .toList();
        db().setComplaintsData(complaintLists);
      } else {
        null;
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      print(e);
    }
  }

  // function to get complaints messages
  Future<List<dynamic>> getComplaintMessages(String id) async {
    List<dynamic> messages = [];
    try {
      final snapshot = await FirestoreApiReference.complaintsMsgPath(id).get();
      if (snapshot.docs.isNotEmpty) {
        messages = snapshot.docs.map((e) => e.data()).toList();
      } else {}
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
    return messages;
  }

  // function to get bookings
  getBookings() async {
    try {
      final path = FirestoreApiReference.bookingsPath;
      final snapshot = await path.get();
      if (snapshot.docs.isNotEmpty) {
        var bookingLists = snapshot.docs
            .map((e) => BookingsClass.fromBooking(e.data(), e.id.toString()))
            .toList();

        db().setBookingsList(bookingLists);
      } else {
        null;
      }
    } on FirebaseException catch (e) {
      MySnackBar.error(context, "Bookings error\n${e.message.toString()}");
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, "Bookings error\n${e.toString()}");
    }
  }

//  function to get guard documents
  Future<List<DocsClass>> getGuardDocs(String id) async {
    try {
      List<DocsClass> snapshot = [];
      var services = await FirestoreApiReference.guardDocumentPath(id).get();
      snapshot =
          services.docs.map((e) => DocsClass.fromDocs(e.data(), e.id)).toList();
      return snapshot;
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      return [];
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      return [];
    } catch (e) {
      MySnackBar.error(context, e.toString());
      return [];
    }
  }

// function to get guard services
  Future<List<GuardServices>> getGuardServices(String id) async {
    try {
      List<GuardServices> snapshot = [];

      var services = await FirestoreApiReference.guardServicesPath(id).get();
      snapshot = services.docs
          .map((e) => GuardServices.fromService(e.data(), e.id))
          .toList();

      return snapshot;
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      return [];
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      return [];
    } catch (e) {
      MySnackBar.error(context, e.toString());
      return [];
    }
  }

// function to delete banner
  deleteBanner(String banner, String id) async {
    db().setLoader(true);
    try {
      await storage.refFromURL(banner).delete();
      await FirestoreApiReference.bannersPath
          .doc(id)
          .delete()
          .then((value) => db().deleteBanner(id));

      db().setLoader(false);
      AppServices.popView(context);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      db().setLoader(false);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      db().setLoader(false);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      db().setLoader(false);
    }
  }

  addBanner(String? bannerId) async {
    bool isValid = bannerId != null;
    if (isValid) {
      try {
        Map<String, dynamic> data = {
          "banner": bannerId,
        };
        await FirestoreApiReference.bannersPath
            .add(data)
            .then((value) => db().addBanner(BannersClass(bannerId, value.id)));

        db().setLoader(false);
        AppServices.popView(context);
      } on FirebaseException catch (e) {
        MySnackBar.error(context, e.message.toString());
        db().setLoader(false);
      } on SocketException {
        MySnackBar.info(context, "Internet Error");
        db().setLoader(false);
      } catch (e) {
        MySnackBar.error(context, e.toString());
        db().setLoader(false);
      }
    } else {
      db().setLoader(false);
      MySnackBar.error(context, "Please select a banner.");
    }
  }

  getBanners() async {
    try {
      await FirestoreApiReference.bannersPath.get().then((value) => db()
          .setBanners(value.docs
              .map((e) => BannersClass.fromBanner(e.data(), e.id))
              .toList()));
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

  // function to add service area
  addServiceArea(String pincode) async {
    try {
      db().setLoader(true);

      await FirestoreApiReference.serviceAreaPath
          .add({"pincode": pincode}).then((value) =>
              db().addServiceArea(ServiceAreaClass(value.id, pincode)));
      AppServices.popView(context);
      db().setLoader(false);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
      db().setLoader(false);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
      db().setLoader(false);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
      db().setLoader(false);
    }
  }

  // function to edit service area
  editServiceArea(String pincode, String id) async {
    try {
      db().setLoader(true);

      await FirestoreApiReference.serviceAreaPath
          .doc(id)
          .update({"pincode": pincode}).then(
              (value) => db().updateServiceArea(id, pincode));
      AppServices.popView(context);
      db().setLoader(false);
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
      AppServices.popView(context);
      db().setLoader(false);
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
      AppServices.popView(context);
      db().setLoader(false);
    } catch (e) {
      MySnackBar.error(context, e.toString());
      AppServices.popView(context);
      db().setLoader(false);
    }
  }

  // function to get all services
  getServices() async {
    try {
      await FirestoreApiReference.servicePath.get().then((value) => db()
          .setServiceData(value.docs
              .map((e) => ServiceClass.fromService(e.data(), e.id))
              .toList()));
    } on FirebaseException catch (e) {
      MySnackBar.error(context, e.message.toString());
    } on SocketException {
      MySnackBar.info(context, "Internet Error");
    } catch (e) {
      MySnackBar.error(context, e.toString());
    }
  }

  // function to add service
}
