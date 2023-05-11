import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import 'enums.dart';

class CategoryClass {
  String name, image, categoryId;

  CategoryClass(this.name, this.image, this.categoryId);
  CategoryClass.fromCategory(Map<Object?, Object?> json, this.categoryId)
      : name = json["name"].toString(),
        image = json['image'].toString();
}

class UserInformationClass {
  String username, phone, image, uid, token, dateOfBirth, gender, aadharNo;
  bool isBlocked;
  List<DocsClass> documents;
  UserInformationClass(
      this.username,
      this.phone,
      this.image,
      this.uid,
      this.isBlocked,
      this.token,
      this.gender,
      this.dateOfBirth,
      this.documents,
      this.aadharNo);
  UserInformationClass.fromUser(Map<Object?, Object?> json, this.uid)
      : username = json['Name'].toString(),
        phone = json["Number"].toString(),
        isBlocked = json['isBlocked'].toString() == "true",
        token = json['token'] == null ? "" : json['token'].toString(),
        gender = json['Gender'] == null ? "" : json['Gender'].toString(),
        dateOfBirth =
            json['dateOfBirth'] == null ? "" : json['dateOfBirth'].toString(),
        aadharNo = json['aadharNo'] == null ? "" : json['aadharNo'].toString(),
        documents = json["documents"] == null
            ? []
            : FunctionsController().getDocs(json['documents'] as List<Object?>),
        image = json["ProfileImage"].toString();
}

class ProvidersInformationClass {
  String uid,
      name,
      phone,
      qualification,
      dateOfBirth,
      profileImage,
      city,
      category,
      description,
      createdAt,

      // address,
      token;
  GuardApprovalStatus isApproved;

  bool isGunAvailable, isBlocked;
  String latitude, longitude;
  List<GuardServices> services;
  List<DocsClass> documents;
  ProvidersInformationClass(
      this.uid,
      this.name,
      this.phone,
      this.qualification,
      this.dateOfBirth,
      this.profileImage,
      this.isGunAvailable,
      this.city,
      this.latitude,
      // this.address,
      this.longitude,
      this.services,
      this.isApproved,
      this.createdAt,
      this.token,
      this.description,
      this.isBlocked,
      this.category,
      this.documents);
  ProvidersInformationClass.fromUser(Map<Object?, Object?> json, this.uid)
      : name = json['name'].toString(),
        phone = json['phone'].toString(),
        qualification = json['qualification'].toString(),
        dateOfBirth = json['dateOfBirth'].toString(),
        profileImage =
            json['profileImage'] == null ? "" : json['profileImage'].toString(),
        city = json["City"] == null || json['City'].toString() == "NA"
            ? ""
            : json['City'].toString(),
        isGunAvailable =
            json['isGunAvailable'].toString() == "true" ? true : false,
        latitude =
            json["Location"] == null || json['Location'].toString() == "NA"
                ? ""
                : json["Location"].toString().split(",").first,
        longitude =
            json["Location"] == null || json['Location'].toString() == "NA"
                ? ""
                : json["Location"].toString().split(",").last,
        // address = FunctionsController().getLocation(
        //     json["Location"] == null || json['Location'].toString() == "NA"
        //         ? ""
        //         : json["Location"].toString().split(",").first,
        //     json["Location"] == null || json['Location'].toString() == "NA"
        //         ? ""
        //         : json["Location"].toString().split(",").last),
        services = json['services'] == null
            ? []
            : FunctionsController()
                .getServices(json['services'] as Map<Object?, Object?>),
        isApproved = GuardApprovalStatus.values.firstWhere(
            (element) => element.name == json['isApproved'].toString()),
        createdAt = json['CreatedAt'].toString(),
        category = json['Category'].toString(),
        isBlocked = json['isBlocked'].toString() == "true",
        description =
            json['description'] == null ? "" : json['description'].toString(),
        token = json['msgToken'].toString(),
        documents = json["docs"] == null
            ? []
            : FunctionsController().getDocs(json['docs'] as List<Object?>);
}

class GuardServices {
  String title, serviceId;
  GuardServices(this.title, this.serviceId);
  GuardServices.fromService(Map<Object?, Object?> json, this.serviceId)
      : title = json['title'].toString();
}

class DocsClass {
  String name, image;
  DocumentState status;
  DocsClass(this.name, this.image, this.status);
  DocsClass.fromDocs(Map<Object?, Object?> json)
      : image = json['document'] == null ? "" : json['document'].toString(),
        status = json['documentState'] == null
            ? DocumentState.posted
            : DocumentState.values.firstWhere(
                (element) => element.name == json['documentState'].toString()),
        name = json['title'].toString();
}

class ServiceClass {
  String name, categoryId, serviceId;
  ServiceClass(this.categoryId, this.name, this.serviceId);
  ServiceClass.fromService(Map<Object?, Object?> json, this.serviceId)
      : name = json['name'].toString(),
        categoryId = json['categoryId'].toString();
}

class ComplaintsClass {
  String complaintId, bookingRef, complaint, complaintBy, createdOn, type;
  ComplaintStatus status;
  ComplaintsClass(this.complaintId, this.bookingRef, this.complaint,
      this.complaintBy, this.createdOn, this.status, this.type);
  ComplaintsClass.fromComplaint(Map<Object?, Object?> json, this.complaintId)
      : bookingRef = json['bookingRef'].toString(),
        complaint = json['complaint'].toString(),
        complaintBy = json['createdBy'].toString(),
        createdOn = json['createdOn'].toString(),
        status = ComplaintStatus.values
            .firstWhere((element) => element.name == json['status'].toString()),
        type = json['type'].toString();
}

class BookingsClass {
  String id,
      address,
      category,
      bookingStatus,
      type,
      paymentStatus,
      reportingDate,
      reportingTime,
      bookingId,
      bookingDuration,
      bookingCategory,
      bookingCategoryImg,
      userId;
  DateTime bookingTime;
  List<String> guards;
  int price;
  double lat, lng;
  BookingsClass(
      this.id,
      this.address,
      this.category,
      this.bookingStatus,
      this.type,
      this.paymentStatus,
      this.reportingDate,
      this.reportingTime,
      this.userId,
      this.guards,
      this.bookingId,
      this.price,
      this.lat,
      this.bookingTime,
      this.bookingDuration,
      this.bookingCategory,
      this.bookingCategoryImg,
      this.lng);
  BookingsClass.fromBooking(Map<Object?, Object?> json, this.id)
      : address = json['Address'].toString(),
        category = json['BookingCategory'].toString(),
        bookingStatus = json['BookingStatus'].toString(),
        type = json['BookingType'].toString(),
        paymentStatus = json['PaymentStatus'].toString(),
        reportingDate = json['ReportingDate'].toString(),
        reportingTime = json['ReportingTime'].toString(),
        userId = json['UserId'].toString(),
        guards = json['GuardId'] == null
            ? []
            : (json['GuardId'] as List).map((e) => e.toString()).toList(),
        bookingId = json['BookingId'].toString(),
        lat = double.parse(json['LatLng'].toString().split(",").first),
        lng = double.parse(json['LatLng'].toString().split(",").last),
        bookingDuration = json['BookingDuration'].toString(),
        bookingCategory = json['BookingCategory'].toString(),
        bookingTime = DateTime.parse(json['CreatedAt'].toString()),
        bookingCategoryImg = json['BookingImage'].toString(),
        price = int.parse(json['MembershipPrice'].toString());
}

class SubscriptionClass {
  String id, amount, plan, type;
  SubscriptionClass(this.id, this.amount, this.plan, this.type);

  SubscriptionClass.fromSubscription(Map<Object?, Object?> json, this.id)
      : amount = json['amount'].toString(),
        plan = json['plan'].toString(),
        type = json['planType'].toString();
}

class NotificationModel {
  String id, title, msg, notificationType, route;
  DateTime time;
  NotificationModel(this.id, this.title, this.msg, this.notificationType,
      this.route, this.time);

  NotificationModel.fromNotification(Map<Object?, Object?> json, this.id)
      : title = json['title'].toString(),
        msg = json['body'].toString(),
        notificationType = json['notificationType'].toString(),
        route = json['route'].toString(),
        time = DateTime.parse(json['createdAt'].toString());
}

class BannersClass {
  String banner;
  String bannerId;
  BannersClass(this.banner, this.bannerId);
  BannersClass.fromBanner(Map<Object?, Object?> banner, this.bannerId)
      : banner = banner['banner'].toString();
}

class ReviewsModel {
  String id;
  String name;
  String description;
  String profileImage;
  double ratings;
  String senderId;
  DateTime createdAt;
  ReviewsModel(this.id, this.name, this.description, this.profileImage,
      this.ratings, this.senderId, this.createdAt);
  ReviewsModel.fromJson(Map<Object?, Object?> json, this.id)
      : name = json["Name"].toString(),
        description = json["Description"].toString(),
        profileImage = json["ProfileImage"].toString(),
        ratings = double.parse(json["Ratings"].toString()),
        senderId = json["SenderId"].toString(),
        createdAt = DateTime.parse(json["CreatedAt"].toString());
}
