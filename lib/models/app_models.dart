import 'package:valt_security_admin_panel/controllers/app_functions.dart';

import 'enums.dart';

// class CategoryClass {
//   String name, image, categoryId;

//   CategoryClass(this.name, this.image, this.categoryId);
//   CategoryClass.fromCategory(Map<String, dynamic> json, this.categoryId)
//       : name = json["name"].toString(),
//         image = json['image'].toString();
// }

class CategoryClass {
  String name, image, categoryId;
  ShiftModel monthlyHr;
  ShiftModel monthlyShift;
  ShiftModel dailyHr;
  ShiftModel dailyShift;
  ShiftModel singleHr;
  ShiftModel singleShift;

  CategoryClass(
      this.name,
      this.image,
      this.categoryId,
      this.monthlyHr,
      this.monthlyShift,
      this.dailyHr,
      this.dailyShift,
      this.singleHr,
      this.singleShift);
  CategoryClass.fromCategory(Map<String, dynamic> json, this.categoryId)
      : name = json["name"].toString(),
        monthlyHr = ShiftModel.fromJson(json['monthly']['hourly']),
        monthlyShift = ShiftModel.fromJson(json['monthly']['shift']),
        dailyHr = ShiftModel.fromJson(json['multipleDay']['hourly']),
        dailyShift = ShiftModel.fromJson(json['multipleDay']['shift']),
        singleHr = ShiftModel.fromJson(json['singleDay']['hourly']),
        singleShift = ShiftModel.fromJson(json['singleDay']['shift']),
        image = json['image'].toString();
}

class SubDifferenceModel {
  String pincode, id;
  ShiftModel monthlyHr;
  ShiftModel monthlyShift;
  ShiftModel dailyHr;
  ShiftModel dailyShift;
  ShiftModel singleHr;
  ShiftModel singleShift;

  SubDifferenceModel(this.id, this.pincode, this.monthlyHr, this.monthlyShift,
      this.dailyHr, this.dailyShift, this.singleHr, this.singleShift);
  SubDifferenceModel.fromJson(Map<String, dynamic> json, this.id)
      : pincode = json["pin_code"].toString(),
        monthlyHr = ShiftModel.fromJson(json['monthly']['hourly']),
        monthlyShift = ShiftModel.fromJson(json['monthly']['shift']),
        dailyHr = ShiftModel.fromJson(json['multipleDay']['hourly']),
        dailyShift = ShiftModel.fromJson(json['multipleDay']['shift']),
        singleHr = ShiftModel.fromJson(json['singleDay']['hourly']),
        singleShift = ShiftModel.fromJson(json['singleDay']['shift']);

  Map<String, dynamic> toJson() => {
        "pin_code": pincode,
        "monthly": {
          "hourly": {
            "basic": monthlyHr.basic,
            "standard": monthlyHr.standard,
            "premium": monthlyHr.premium
          },
          "shift": {
            "basic": monthlyShift.basic,
            "standard": monthlyShift.standard,
            "premium": monthlyShift.premium
          }
        },
        "multipleDay": {
          "hourly": {
            "basic": dailyHr.basic,
            "standard": dailyHr.standard,
            "premium": dailyHr.premium
          },
          "shift": {
            "basic": dailyShift.basic,
            "standard": dailyShift.standard,
            "premium": dailyShift.premium
          }
        },
        "singleDay": {
          "hourly": {
            "basic": singleHr.basic,
            "standard": singleHr.standard,
            "premium": singleHr.premium
          },
          "shift": {
            "basic": singleShift.basic,
            "standard": singleShift.standard,
            "premium": singleShift.premium
          }
        }
      };
}

class ShiftModel {
  int basic;
  int standard;
  int premium;
  ShiftModel(this.basic, this.standard, this.premium);

  ShiftModel.fromJson(Map<String, dynamic> json)
      : basic = int.parse(json['basic'].toString()),
        standard = int.parse(json['standard'].toString()),
        premium = int.parse(json['premium'].toString());
}

class UserInformationClass {
  String username, phone, image, uid, dateOfBirth, gender, aadharNo;
  List<String> token;
  bool isBlocked;
  UserInformationClass(this.username, this.phone, this.image, this.uid,
      this.isBlocked, this.token, this.gender, this.dateOfBirth, this.aadharNo);
  UserInformationClass.fromUser(Map<String, dynamic> json, this.uid)
      : username = json['Name'].toString(),
        phone = json["Number"].toString(),
        isBlocked = json['isBlocked'].toString() == "true",
        token = json['token'] == null
            ? []
            : (json['token'] as List).map((e) => e.toString()).toList(),
        gender = json['Gender'] == null ? "" : json['Gender'].toString(),
        dateOfBirth =
            json['dateOfBirth'] == null ? "" : json['dateOfBirth'].toString(),
        aadharNo = json['aadharNo'] == null ? "" : json['aadharNo'].toString(),
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
      experience,
      esicNumber,
      address,
      pfNumber;
  GuardApprovalStatus isApproved;

  bool isGunAvailable, isBlocked, isVerified;
  String latitude, longitude;
  List<dynamic> tokens;
  String promotion;
  ProvidersInformationClass(
      this.uid,
      this.name,
      this.phone,
      this.qualification,
      this.dateOfBirth,
      this.profileImage,
      this.isGunAvailable,
      this.esicNumber,
      this.pfNumber,
      this.city,
      this.latitude,
      this.experience,
      this.longitude,
      this.promotion,
      this.isApproved,
      this.createdAt,
      this.tokens,
      this.description,
      this.isBlocked,
      this.isVerified,
      this.address,
      this.category);
  ProvidersInformationClass.fromUser(Map<String, dynamic> json, this.uid)
      : name = FunctionsController().titleCase(json['name'].toString()),
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
        experience = json['Experience'].toString(),
        promotion =
            json['Promotion'] == null ? "basic" : json['Promotion'].toString(),
        isApproved = GuardApprovalStatus.values.firstWhere(
            (element) => element.name == json['isApproved'].toString()),
        createdAt = json['CreatedAt'].toString(),
        category = json['Category'].toString(),
        isBlocked = json['isBlocked'].toString() == "true",
        isVerified = json['isVerified'] == null
            ? false
            : json['isVerified'].toString() == "true",
        description =
            json['description'] == null ? "" : json['description'].toString(),
        esicNumber =
            json['esicNumber'] == null ? "" : json['esicNumber'].toString(),
        pfNumber = json['pfNumber'] == null ? "" : json['pfNumber'].toString(),
        address = "",
        tokens = json['msgToken'] ?? [];
}

class GuardServices {
  String title, serviceId, categoryId;
  GuardServices(this.title, this.serviceId, this.categoryId);
  GuardServices.fromService(Map<String, dynamic> json, this.serviceId)
      : title = json['name'].toString(),
        categoryId =
            json['categoryId'] == null ? "" : json['categoryId'].toString();
}

class DocsClass {
  String name, image, id;
  DocumentState status;
  DocsClass(this.name, this.image, this.status, this.id);
  DocsClass.fromDocs(Map<String, dynamic> json, this.id)
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
  ServiceClass.fromService(Map<String, dynamic> json, this.serviceId)
      : name = json['name'].toString(),
        categoryId = json['categoryId'].toString();
}

class ComplaintsClass {
  String id;
  String name;
  String complaint;
  String complaintId;
  String complaintBy;
  String createdBy;
  String type;
  String bookingRef;
  String createdOn;
  ComplaintStatus status;
  ComplaintsClass(
      this.id,
      this.name,
      this.complaint,
      this.type,
      this.bookingRef,
      this.createdOn,
      this.status,
      this.complaintId,
      this.complaintBy,
      this.createdBy);
  ComplaintsClass.fromComplaint(Map<String, dynamic> json, this.id)
      : name = json["userName"].toString(),
        complaint = json["complaint"].toString(),
        type = json["type"].toString(),
        bookingRef = json["bookingRef"].toString(),
        createdOn = json["createdOn"].toString(),
        complaintId = json['complaintId'].toString(),
        complaintBy = json['complaintBy'].toString(),
        createdBy = json['createdBy'].toString(),
        status = ComplaintStatus.values
            .firstWhere((element) => element.name == json['status'].toString());
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
      paymentId,
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
      this.paymentId,
      this.price,
      this.lat,
      this.bookingTime,
      this.bookingDuration,
      this.bookingCategory,
      this.bookingCategoryImg,
      this.lng);
  BookingsClass.fromBooking(Map<String, dynamic> json, this.id)
      : address = json['Address'].toString(),
        category = json['BookingCategory'].toString(),
        bookingStatus = json['BookingStatus'].toString(),
        type = json['BookingType'].toString(),
        paymentStatus = json['PaymentStatus'].toString(),
        reportingDate = json['ReportingDate'].toString(),
        reportingTime = FunctionsController.timeConversion(
            json['ReportingTime'].toString(), json['DutyType']),
        userId = json['UserId'].toString(),
        guards = json['GuardId'] == null
            ? []
            : (json['GuardId'] as List).map((e) => e.toString()).toList(),
        bookingId = json['BookingId'].toString(),
        lat = double.parse(json['LatLng'].toString().split(",").first),
        lng = double.parse(json['LatLng'].toString().split(",").last),
        paymentId = json['PaymentId'].toString(),
        bookingDuration = json['BookingDuration'].toString(),
        bookingCategory = json['BookingCategory'].toString(),
        bookingTime = DateTime.parse(json['CreatedAt'].toString()),
        bookingCategoryImg = json['BookingImage'].toString(),
        price = int.parse(json['MembershipPrice'].toString());
}

class SubscriptionClass {
  String id, amount, plan, type;
  SubscriptionClass(this.id, this.amount, this.plan, this.type);

  SubscriptionClass.fromSubscription(Map<String, dynamic> json, this.id)
      : amount = json['amount'].toString(),
        plan = json['plan'].toString(),
        type = json['planType'].toString();
}

class ServiceAreaClass {
  String id, pincode, city, dayTime, nightTime;
  ServiceAreaClass(
      this.id, this.pincode, this.city, this.dayTime, this.nightTime);
  ServiceAreaClass.fromJson(Map<String, dynamic> json, this.id)
      : pincode = json['pincode'],
        dayTime = json['day'],
        nightTime = json['night'],
        city = json['city'];
}

class NotificationModel {
  String id, title, msg, notificationType, route;
  DateTime time;
  bool isAdmin;
  NotificationModel(this.id, this.title, this.msg, this.notificationType,
      this.route, this.time, this.isAdmin);

  NotificationModel.fromNotification(Map<Object?, Object?> json, this.id)
      : title = json['title'].toString(),
        msg = json['body'].toString(),
        notificationType = json['notificationType'].toString(),
        route = json['route'].toString(),
        isAdmin = json['isAdmin'] == null
            ? false
            : json['isAdmin'].toString() == "true",
        time = json['createdAt'].toString().contains("T")
            ? DateTime.parse(json['createdAt'].toString())
            : DateTime.fromMillisecondsSinceEpoch(
                int.parse(json['createdAt'].toString()));
}

class BannersClass {
  String banner;
  String bannerId;
  BannersClass(this.banner, this.bannerId);
  BannersClass.fromBanner(Map<String, dynamic> banner, this.bannerId)
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
  ReviewsModel.fromJson(Map<String, dynamic> json, this.id)
      : name = json["Name"].toString(),
        description = json["Description"].toString(),
        profileImage = json["ProfileImage"].toString(),
        ratings = double.parse(json["Ratings"].toString()),
        senderId = json["SenderId"].toString(),
        createdAt = DateTime.parse(json["CreatedAt"].toString());
}

// announcement/offers class

class OfferClass {
  String id, title, description, receiver, expiryDate, offerCode, discount;
  DateTime createdAt;

  bool isDisabled, isPromoCode, isRupeesDiscount;
  OfferClass(
      this.id,
      this.title,
      this.description,
      this.receiver,
      this.expiryDate,
      this.offerCode,
      this.discount,
      this.createdAt,
      this.isPromoCode,
      this.isDisabled,
      this.isRupeesDiscount);
  OfferClass.fromJson(Map<Object?, Object?> json, this.id)
      : title = json['title'].toString(),
        description = json['body'].toString(),
        receiver = json['receiver'].toString(),
        expiryDate =
            json['ExpiryDate'] == null ? "" : json['ExpiryDate'].toString(),
        isPromoCode = json['isPromoCode'].toString() == "true",
        offerCode =
            json['OfferCode'] == null ? "" : json['OfferCode'].toString(),
        isRupeesDiscount = json['isRupeesDiscount'].toString() == "true",
        isDisabled = json['isDisabled'] == null
            ? false
            : json['isDisabled'].toString() == "true",
        discount = json['discount'] == null ? "" : json['discount'].toString(),
        createdAt = DateTime.parse(json['createdAt'].toString());
}

// payments model
class PaymentModel {
  String id,
      amount,
      category,
      packageName,
      paymentId,
      status,
      userId,
      userName,
      description,
      paymentMethod;
  DateTime createdOn;

  PaymentModel(
      this.id,
      this.amount,
      this.category,
      this.packageName,
      this.paymentMethod,
      this.paymentId,
      this.status,
      this.userId,
      this.description,
      this.userName,
      this.createdOn);

  PaymentModel.fromJson(Map<String, dynamic> json, this.id)
      : amount = json['amount'] == null ? "" : json['amount'].toString(),
        category = json['category'] ?? "",
        packageName = json['packageName'] ?? "",
        paymentId = json['paymentId'] ?? "",
        paymentMethod = json['payment_method'] ?? "",
        status = json['status'] ?? "",
        description = json['description'] ?? "",
        userId = json['userId'] ?? "",
        userName = json['userName'] ?? "",
        createdOn = DateTime.parse(json['createdOn']);
}

class ShiftTimeModel {
  String id, startTime, endTime;
  ShiftTimeModel(this.id, this.startTime, this.endTime);

  ShiftTimeModel.fromShift(Map<String, dynamic> json, this.id)
      : startTime = json['start'],
        endTime = json['end'];
}
