// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:edu_market/components/fancy_popus/awesome_dialogs.dart';
// import 'package:edu_market/controllers/app_data_controller.dart';
// import 'package:edu_market/controllers/app_functions.dart';
// import 'package:edu_market/controllers/snackbar_controller.dart';
// import 'package:edu_market/main.dart';
// import 'package:edu_market/models/data_classes.dart';
// import 'package:edu_market/screens/admin/admin_dashboard.dart';
// import 'package:edu_market/screens/auth/auth_home.dart';
// import 'package:edu_market/screens/auth/organization_register_form.dart';
// import 'package:edu_market/screens/auth/otp_view.dart';
// import 'package:edu_market/screens/auth/user_register_form.dart';
// import 'package:edu_market/screens/public_profile/public_dashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_number/mobile_number.dart';
// import 'package:provider/provider.dart';

// import '../components/pop_ups/sim_number_selector.dart';
// import '../helpers/app_services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../models/enums.dart';

class AuthController {
  approveProfile(String profileId, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    final path = database.ref('Providers/$profileId');
    await path.update({"isApproved": true});
    db.updateApproval(profileId);
    db.setLoader(false);
  }

  approveAllProfile(List<String> profiles, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    for (var profileId in profiles) {
      final path = database.ref('Providers/$profileId');
      await path.update({"isApproved": true});
      db.updateApproval(profileId);
    }
    db.setLoader(false);
  }

  Future<void> updateDocumentStatus(DocsClass document, String id, String docId,
      DocumentState status, BuildContext context) async {
    final db = Provider.of<AppDataController>(context, listen: false);
    db.setLoader(true);
    final path = database.ref("Providers/$id/docs/$docId");
    await path.update({"documentState": status.name});
    db.setLoader(false);
  }

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//   final FunctionsController _appFunctions = FunctionsController();
//   bool initialized = false;
//   dynamic credentials;

//   String publicName = "student";

//   List<String> loadMsgList = [
//     "Loading..",
//     "Initializing..",
//     "Uploading Media..",
//     "Finalizing..",
//     "Logging In..",
//     "Signing Up..",
//     "Please wait..",
//     "Updating.."
//   ];

//   Future<void> initMobileNumbers(BuildContext context) async {
//     if (!await MobileNumber.hasPhonePermission) {
//       await MobileNumber.requestPhonePermission;
//       return;
//     }
//     try {
//       final cards = await MobileNumber.getSimCards;

//       if (cards != null && cards.isNotEmpty) {
//         showDialog(
//             context: context,
//             builder: (context) => StatefulBuilder(
//                 builder: (context, state) => SimNumberSelector(cards: cards)));
//       }
//     } on PlatformException catch (e) {
//       MySnackBar.error(context, e.message.toString());
//     }
//   }

//   onPhoneSubmit(String phone, BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     try {
//       database.setLoader(true);
//       bool isUser = await findUser(phone, context);
//       if (isUser) {
//         phoneAuth(phone, context);
//       } else {
//         MySnackBar.info(context,
//             "You are not registered with us. Please register your profile");
//         AppServices.pushAndRemove(context, UserRegisterForm(phone: phone));
//         database.setLoader(false);
//       }
//     } on FirebaseException catch (e) {
//       MySnackBar.error(context, e.message.toString());
//     } on SocketException {
//       MySnackBar.error(context, "Internet Error");
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> phoneAuth(String phone, BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.setLoader(true);
//     try {
//       await _auth.verifyPhoneNumber(
//           timeout: const Duration(seconds: 60),
//           phoneNumber: phone,
//           verificationCompleted: (PhoneAuthCredential credential) async {
//             verifyOtp(context, credential);
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             database.setLoader(false);
//             MySnackBar.error(context, e.message.toString());
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             preference.setString("phone", phone);
//             AppServices.pushTo(
//                 context, OtpView(verificationId: verificationId));
//             database.setLoader(false);
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {});
//     } on FirebaseException catch (e) {
//       database.setLoader(false);
//       MySnackBar.error(context, e.message.toString());
//     } on SocketException catch (error) {
//       database.setLoader(false);
//       MySnackBar.error(context, error.message.toString());
//     }
//   }

//   verifyOtp(BuildContext context, AuthCredential authCredentials) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.setLoader(true);
//     try {
//       final creds = await _auth.signInWithCredential(authCredentials);
//       preference.setString("uid", creds.user!.uid);
//       if (creds.additionalUserInfo!.isNewUser) {
//         Map<String, dynamic> authData = database.getRegisterationData;
//         authData.addAll({
//           "uid": creds.user!.uid,
//           "phone": preference.getString("phone").toString()
//         });
//         await _database.ref("users/${creds.user!.uid}").set(authData);
//       }
//       await _appFunctions.getUserProfile(context);
//       getAuthRouting(creds.user!.uid, context);
//     } on FirebaseAuthException catch (e) {
//       database.setLoader(false);
//       MySnackBar.error(context, e.message.toString());
//     } on SocketException catch (error) {
//       database.setLoader(false);
//       MySnackBar.error(context, error.message.toString());
//     } catch (e) {
//       database.setLoader(false);
//     }
//   }

//   getAuthRouting(String uid, BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     final personalInfoAvailable = await verifyUser(uid);
//     if (!personalInfoAvailable) {
//       AppServices.pushAndRemove(context, UserRegisterForm());
//     } else {
//       if (database.getUserPersonalData.userType.toLowerCase() == publicName) {
//         AppServices.pushAndRemove(context, const PublicDashboardView());
//         database.setLoader(false);
//       } else if (database.getUserPersonalData.userType.toLowerCase() ==
//           "admin") {
//         AppServices.pushAndRemove(context, const AdminDashboard());
//         database.setLoader(false);
//       } else {
//         bool orgAvailable = await verifyOrganization(uid);
//         if (orgAvailable) {
//           await _appFunctions.getOrganizationProfile(context);
//           getOrganizationRouting(context);
//         } else {
//           AppServices.pushAndRemove(
//               context, const OrganizationRegistrationForm());
//           database.setLoader(false);
//         }
//       }
//     }
//   }

//   getOrganizationRouting(BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     final profile =
//         database.getOrganizationInformation as OrganizationProfileClass;
//     if (profile.isApproved) {
//       database.setLoader(false);
//       MySnackBar.success(context, "Welcome ${profile.name}");
//     } else {
//       preference.remove("uid");
//       database.setLoader(false);
//       await FacnyDialogController()
//           .approvalPendingDialog(context,
//               () => AppServices.pushAndRemove(context, const AuthHomeView()))
//           .show();
//     }
//   }

//   Future<bool> verifyUser(String uid) async {
//     final snapshot = await _database.ref("users/$uid/email").get();
//     if (snapshot.exists) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> findUser(String phone, BuildContext context) async {
//     try {
//       final snapshot = await _database.ref("users").get();
//       final userList = snapshot.children;
//       bool isAvailable = userList.any((element) =>
//           (element.value as Map<Object?, Object?>)['phone'].toString() ==
//           phone);
//       return isAvailable;
//     } on FirebaseException catch (e) {
//       MySnackBar.error(context, e.message.toString());
//       return false;
//     } on SocketException {
//       MySnackBar.error(context, "Internet Error");
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> verifyOrganization(String uid) async {
//     final snapshot = await _database.ref("Providers/$uid").get();
//     if (snapshot.exists) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   setPersonalInfo(Map<String, dynamic> data, BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.setLoader(true);
//     final path = _database.ref("users/${preference.getString("uid")}");
//     await path.update(data);
//     database.setLoader(false);
//     MySnackBar.success(context, "Profile Successfully Updated");
//     data['user_type'] == "Student"
//         ? null
//         : AppServices.pushAndRemove(
//             context, const OrganizationRegistrationForm());
//   }

//   setOrganizationInfo(Map<String, dynamic> data, BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.setLoader(true);
//     final path = _database.ref("Providers/${preference.getString("uid")}");
//     await path.set(data);
//     database.setLoader(false);
//     preference.remove("uid");
//     MySnackBar.success(context, "Business Profile Successfully Updated");
//   }

//   logoutUser(BuildContext context) async {
//     final database = Provider.of<AppDatabase>(context, listen: false);
//     database.setLoader(true);
//     Future.delayed(const Duration(milliseconds: 300), () {
//       database.setLoader(false);
//       preference.remove("uid").then(
//           (value) => AppServices.pushAndRemove(context, const AuthHomeView()));
//     });
//   }
}
