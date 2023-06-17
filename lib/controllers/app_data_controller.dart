// import 'package:flutter/material.dart';

// import '../models/data_classes.dart';

import 'package:flutter/material.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

class AppDataController extends ChangeNotifier {
//   /* Auth Credential Handler */
//   dynamic authcreds;
//   setCredentials(dynamic data) {
//     authcreds = data;
//   }

//   /* Registration Data Handler */
//   Map<String, dynamic> _regData = {};
//   Map<String, dynamic> get getRegisterationData => _regData;
//   setRegistrationData(Map<String, dynamic> data) {
//     _regData = data;
//     notifyListeners();
//   }

  /* App Loading Handler */
  bool _loading = false;
  bool get appLoading => _loading;
  setLoader(bool status) {
    _loading = status;
    notifyListeners();
  }

  /* User Category handler */
  List<CategoryClass> _userType = [];
  List<CategoryClass> get getUserCategories => _userType;
  setUserCategoryList(List<CategoryClass> data) {
    _userType = data;
    notifyListeners();
  }

  bool isCategoryAvailable(String categoryId) {
    return _userType.any((element) => element.categoryId == categoryId);
  }

  addNewCategory(CategoryClass category) {
    _userType.add(category);
    notifyListeners();
  }

  updateCategory(CategoryClass category) {
    int i = _userType
        .indexWhere((element) => element.categoryId == category.categoryId);
    _userType[i] = category;
    notifyListeners();
  }

  removeCategory(String categoryId) {
    _userType.removeWhere((element) => element.categoryId == categoryId);
    notifyListeners();
  }

  /* Providers Data Handler */
  List<ProvidersInformationClass> _providerList = [];
  List<ProvidersInformationClass> get getAllProviders => _providerList;
  setProvidersData(List<ProvidersInformationClass> data) {
    _providerList = data;
    notifyListeners();
  }

  updateProviderAddress(String id, String address) {
    int i = _providerList.indexWhere((element) => element.uid == id);
    _providerList[i].address = address;
    notifyListeners();
  }

  updateProviderBlockStatus(String id, bool isblock) {
    int i = _providerList.indexWhere((element) => element.uid == id);
    _providerList[i].isBlocked = isblock;
    notifyListeners();
  }

  updateProviderRatings(String id, double rating) {
    int i = _providerList.indexWhere((element) => element.uid == id);
    _providerList[i].rating = rating;
    notifyListeners();
  }

  bool isProviderAvailable(String profileId) {
    return _providerList.any((element) => element.uid == profileId);
  }

  addNewProviderData(ProvidersInformationClass profile) {
    _providerList.add(profile);
    notifyListeners();
  }

//   removeProfileData(String profileId) {
//     _orgList.removeWhere((element) => element.orgId == profileId);
//     notifyListeners();
//   }

  updateProfile(ProvidersInformationClass profile) {
    int index =
        _providerList.indexWhere((element) => element.uid == profile.uid);
    _providerList[index] = profile;
    notifyListeners();
  }

  updateApproval(String profileId) {
    int index = _providerList.indexWhere((element) => element.uid == profileId);
    index == 0
        ? _providerList.first.isApproved = GuardApprovalStatus.approved
        : _providerList[index].isApproved = GuardApprovalStatus.approved;
    notifyListeners();
  }

  updateRejection(String profileId) {
    int index = _providerList.indexWhere((element) => element.uid == profileId);
    print(index);
    index == 0
        ? _providerList.first.isApproved = GuardApprovalStatus.rejected
        : _providerList[index].isApproved = GuardApprovalStatus.rejected;
    notifyListeners();
  }

  List<UserInformationClass> _users = [];
  List<UserInformationClass> get getAllUsers => _users;

  setUsersListData(List<UserInformationClass> data) {
    _users = data;
    notifyListeners();
  }

  addNewUser(UserInformationClass data) {
    _users.add(data);
    notifyListeners();
  }

  updateUser(String id, String name) {
    int index = _users.indexWhere((element) => element.uid == id);
    _users[index].username = name;
    notifyListeners();
  }

/* All Complaints List */
  List<ComplaintsClass> _complaints = [];
  List<ComplaintsClass> get getAllComplaints => _complaints;

  setComplaintsData(List<ComplaintsClass> data) {
    _complaints = data;
    notifyListeners();
  }

  addNewComplaint(ComplaintsClass complaint) {
    _complaints.add(complaint);
    notifyListeners();
  }

/* all services List */
  List<ServiceClass> _services = [];
  List<ServiceClass> get getAllServices => _services;

  setServiceData(List<ServiceClass> data) {
    _services = data;
    notifyListeners();
  }

  addService(ServiceClass service) {
    _services.add(service);
    notifyListeners();
  }

  updateServices(String id, ServiceClass data) {
    int index = _services.indexWhere((element) => element.serviceId == id);
    _services[index] = data;
    notifyListeners();
  }

  removeService(String id) {
    _services.removeWhere((element) => element.serviceId == id);
    notifyListeners();
  }

/* All Bookings Handler */
  List<BookingsClass> _bookings = [];
  List<BookingsClass> get getBookings => _bookings;

  setBookingsList(List<BookingsClass> bookings) {
    _bookings = bookings;
    notifyListeners();
  }

  addNewBooking(BookingsClass booking) {
    _bookings.add(booking);
    notifyListeners();
  }

/* Admin Details */
  Map<String, dynamic>? _admin;
  Map<String, dynamic> get adminDetails => _admin!;

  setAdminDetails(Map<String, dynamic> data) {
    _admin = data;
    notifyListeners();
  }

  /* Reviews handler */
  List<ReviewsModel> _reviews = [];
  List<ReviewsModel> get getReviews => _reviews;

  addReview(ReviewsModel review) {
    _reviews.add(review);
    notifyListeners();
  }

  addAllReviews(List<ReviewsModel> reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  /* Notifications handler */
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get getNotifications => _notifications;

  addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  setNotifications(List<NotificationModel> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  /* banners handler */
  List<BannersClass> _banners = [];
  List<BannersClass> get getBanners => _banners;

  setBanners(List<BannersClass> banners) {
    _banners = banners;
    notifyListeners();
  }

  addBanner(BannersClass banner) {
    _banners.add(banner);
    notifyListeners();
  }

  deleteBanner(String bannerId) {
    _banners.removeWhere((element) => element.bannerId == bannerId);
    notifyListeners();
  }

  /* subscriptions handler */
  List<SubscriptionClass> _subscriptions = [];
  List<SubscriptionClass> get getSubscriptions => _subscriptions;

  setSubscriptions(List<SubscriptionClass> data) {
    _subscriptions = data;
    notifyListeners();
  }

  updateSubscriptions(String id, String amount) {
    final i = _subscriptions.indexWhere((element) => element.id == id);
    _subscriptions[i].amount = amount;
    notifyListeners();
  }

  /* service area handler */
  List<ServiceAreaClass> _serviceArea = [];
  List<ServiceAreaClass> get getserviceArea => _serviceArea;

  setServiceArea(List<ServiceAreaClass> data) {
    _serviceArea = data;
    notifyListeners();
  }

  addServiceArea(ServiceAreaClass data) {
    _serviceArea.add(data);
    notifyListeners();
  }

  updateServiceArea(String id, String pincode) {
    int i = _serviceArea.indexWhere((element) => element.id == id);
    _serviceArea[i].pincode = pincode;
    notifyListeners();
  }
}
