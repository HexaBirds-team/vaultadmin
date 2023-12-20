import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/full_screen_loader.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';
import 'package:valt_security_admin_panel/models/enums.dart';

import '../../../controllers/notification_controller.dart';
import '../../../helpers/style_sheet.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  /* Global keys */
  // form key
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  /* Text field controllers */
  final _titleController = TextEditingController();
  final _discountController = TextEditingController();
  final _msgController = TextEditingController();
  final offerCode = TextEditingController();

  /* enums instances */
  // announcement type instance 1.) announcement 2.) offer;
  AnnouncementType type = AnnouncementType.announcement;

  // receiver type instance 1.) user 2.) guard;
  AnnouncementReceiverType receiverType = AnnouncementReceiverType.user;

  // datetime values
  DateTime? expiryDate;

  // string values
  // String offerCode = "";

  // bool values
  bool isCodeAvailable = false;
  bool isPromoCode = false;
  bool autoGenerateCode = false;
  bool discountInRupees = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    var unExpiredOffers = db.getOffers
        .where((element) =>
            element.isPromoCode &&
            DateTime.parse(element.expiryDate)
                    .difference(DateTime.now())
                    .inMinutes >
                0)
        .toList();
    return GestureDetector(
      onTap: () => AppServices.keyboardUnfocus(context),
      child: Scaffold(

          // appbar
          appBar: customAppBar(
              autoLeading: true,
              context: context,
              title: const Text("Create Announcement/Offer")),

          // body of scaffold
          body: Stack(
            children: [
              Form(
                  key: _key,
                  child: SafeArea(
                      child: ListView(
                    padding: EdgeInsets.all(15.sp),
                    children: [
                      // title text field
                      SimpleTextField(
                          name: _titleController,
                          validator: DataValidationController(),
                          label: "Title"),
                      AppServices.addHeight(15.h),

                      // description or message text field
                      SimpleTextField(
                          name: _msgController,
                          validator: DataValidationController(),
                          label: "Message"),
                      AppServices.addHeight(15.h),

                      // select announcement or offer row
                      Row(
                        children: [
                          // announcement radio button
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Radio<AnnouncementType>(
                                      value: AnnouncementType.announcement,
                                      groupValue: type,
                                      onChanged: (value) =>
                                          setState(() => type = value!)),
                                  Text("Announcement",
                                      style: GetTextTheme.sf16_regular)
                                ],
                              ),
                            ),
                          ),

                          // offer radio button
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Radio<AnnouncementType>(
                                      value: AnnouncementType.offer,
                                      groupValue: type,
                                      onChanged: (value) =>
                                          setState(() => type = value!)),
                                  Expanded(
                                    child: Text("Offer",
                                        style: GetTextTheme.sf16_regular),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /* Extra widgets if offer is selected */
                      type == AnnouncementType.offer
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppServices.addHeight(10.h),

                                // ispromocode checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isPromoCode,
                                        onChanged: (v) => setState(() {
                                              isPromoCode = v!;
                                            })),
                                    AppServices.addWidth(10.w),
                                    Text("Is Promo Code Available",
                                        style: GetTextTheme.sf16_medium),
                                  ],
                                ),

                                // generate offer code button
                                !isPromoCode
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  // maxLength: 7,
                                                  onChanged: (value) {
                                                    if (unExpiredOffers.any(
                                                        (element) =>
                                                            element.offerCode
                                                                .trim() ==
                                                            value.trim())) {
                                                      setState(() =>
                                                          isCodeAvailable =
                                                              true);
                                                    } else {
                                                      isCodeAvailable = false;
                                                    }
                                                    if (value.length == 7) {
                                                      AppServices
                                                          .keyboardUnfocus(
                                                              context);
                                                    }
                                                    setState(() {});
                                                  },
                                                  // onEditingComplete: () {

                                                  // },
                                                  controller: offerCode,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.sp,
                                                              vertical: 17.sp),
                                                      hintText:
                                                          "Enter Promocode",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.r)),
                                                      suffixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.w),
                                                        child: TextButton(
                                                            onPressed: () {
                                                              generateOfferCode();
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                                    minimumSize:
                                                                        Size
                                                                            .zero,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 10
                                                                            .w),
                                                                    tapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,

                                                                    // splashFactory: ,

                                                                    foregroundColor:
                                                                        AppColors
                                                                            .primary1),
                                                            child: const Text(
                                                                "Auto Generate")),
                                                      )),
                                                ),
                                              ),
                                              offerCode.text.length == 7 &&
                                                      !isCodeAvailable
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: Icon(
                                                          Icons.check_circle,
                                                          size: 25.sp,
                                                          color: AppColors
                                                              .greenColor),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                          isCodeAvailable
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.h),
                                                  child: Text(
                                                      "The code is currently active. Please use another code.",
                                                      style: GetTextTheme
                                                          .sf12_regular
                                                          .copyWith(
                                                              color: AppColors
                                                                  .redColor)),
                                                )
                                              : offerCode.text.length == 7
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4.h),
                                                      child: Text(
                                                          "Code should contain 7 letters",
                                                          style: GetTextTheme
                                                              .sf12_regular),
                                                    ),
                                        ],
                                      ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [

                                //     ElevatedButton(
                                //         onPressed: () {},
                                //         child: const Text("Generate Offer Code")),
                                //     AppServices.addWidth(40.w),
                                //     Text(offerCode,
                                //         style: GetTextTheme.sf18_bold),
                                //   ],
                                // ),
                                AppServices.addHeight(15.h),

                                // discount text field
                                Row(
                                  children: [
                                    Expanded(
                                      child: SimpleTextField(
                                          inputType: TextInputType.number,
                                          name: _discountController,
                                          label:
                                              "Discount in ${discountInRupees ? AppServices.getCurrencySymbol : "%"}"),
                                    ),
                                    AppServices.addWidth(10.w),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            discountInRupees =
                                                !discountInRupees;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 15.h),
                                            backgroundColor: discountInRupees
                                                ? AppColors.greenColor
                                                : AppColors.grey100),
                                        child: Text(
                                            "In ${AppServices.getCurrencySymbol}",
                                            style: GetTextTheme.sf14_bold
                                                .copyWith(
                                                    color: discountInRupees
                                                        ? AppColors.whiteColor
                                                        : AppColors
                                                            .blackColor)))
                                  ],
                                ),
                                AppServices.addHeight(20.h),

                                // expiry date text
                                Text("Select Expiry Date",
                                    style: GetTextTheme.sf18_bold),
                                AppServices.addHeight(5.h),

                                // expiry date picker
                                CalendarDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 10),
                                    onDateChanged: (v) => setState(() {
                                          expiryDate = v;
                                        })),
                              ],
                            )
                          : const SizedBox(),

                      AppServices.addHeight(20.h),

                      // select receiver text
                      Text("Select Receiver", style: GetTextTheme.sf18_bold),
                      AppServices.addHeight(5.h),

                      /* row to select offer/announcement receiver type (user or guard) */
                      Row(
                        children: [
                          // user radio button
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Radio<AnnouncementReceiverType>(
                                      value: AnnouncementReceiverType.user,
                                      groupValue: receiverType,
                                      onChanged: (value) => setState(
                                          () => receiverType = value!)),
                                  Text("User", style: GetTextTheme.sf16_regular)
                                ],
                              ),
                            ),
                          ),

                          // guard radio button
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Radio<AnnouncementReceiverType>(
                                      value: AnnouncementReceiverType.guard,
                                      groupValue: receiverType,
                                      onChanged: (value) => setState(
                                          () => receiverType = value!)),
                                  Expanded(
                                    child: Text("Guard",
                                        style: GetTextTheme.sf16_regular),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppServices.addHeight(40.h),

                      // button to save data
                      ButtonOneExpanded(
                          onPressed: () => onSave(), btnText: "Save")
                    ],
                  ))),
              Consumer<AppDataController>(builder: (context, data, child) {
                return data.appLoading
                    ? const FullScreenLoader()
                    : const SizedBox();
              })
            ],
          )),
    );
  }

  // function to generate random offer code
  generateOfferCode() {
    final db = Provider.of<AppDataController>(context, listen: false);
    var unExpiredOffers = db.getOffers.where((element) =>
        element.isPromoCode &&
        DateTime.parse(element.expiryDate)
                .difference(DateTime.now())
                .inMinutes >
            0);
    String code = FunctionsController().generateId();
    if (unExpiredOffers.any((element) => element.offerCode == code)) {
      isCodeAvailable = true;
    } else {
      isCodeAvailable = false;
    }

    offerCode.text = code;
    setState(() {});
  }

// function to reset entire form
  resetForm() {
    _titleController.clear();
    _msgController.clear();
    _discountController.clear();
    offerCode.clear();
    type = AnnouncementType.announcement;
    receiverType = AnnouncementReceiverType.user;
    setState(() {});
  }

// function to send notification and update offer to firebase
  onSave() async {
    Map<String, dynamic> data = {
      "title": _titleController.text.trim(),
      "body": _msgController.text.trim(),
      "createdAt": DateTime.now().toIso8601String(),
      "receiver": receiverType.name,
      "notificationType": "announcement",
      "isAdmin": true,
      "route": "/Notification"
    };

    Map<String, dynamic> couponData = {
      "title": _titleController.text.trim(),
      "body": _msgController.text.trim(),
      "ExpiryDate": expiryDate == null ? "" : expiryDate!.toIso8601String(),
      "createdAt": DateTime.now().toIso8601String(),
      "receiver": receiverType.name,
      "isPromoCode": isPromoCode,
      "OfferCode": isPromoCode ? offerCode.text : "",
      "discount": _discountController.text
    };

    Map<String, dynamic> offerNotificationData = {
      "title": _titleController.text.trim(),
      "body": _msgController.text.trim(),
      "ExpiryDate": expiryDate == null ? "" : expiryDate!.toIso8601String(),
      "createdAt": DateTime.now().toIso8601String(),
      "receiver": receiverType.name,
      "OfferCode": offerCode.text,
      "discount": _discountController.text,
      "route": "/Offer",
      "notificationType": "offers",
      "isRupeesDiscount": discountInRupees
    };
    final db = Provider.of<AppDataController>(context, listen: false);

    if (_key.currentState!.validate()) {
      db.setLoader(true);
      if (type == AnnouncementType.announcement) {
        await NotificationController()
            .uploadNotification("Notifications", data);
      } else {
        if (discountInRupees
            ? _discountController.text.isEmpty
            : int.parse(_discountController.text) > 100 ||
                int.parse(_discountController.text) <= 0) {
          MySnackBar.error(context, "Please enter a valid discount amount");
        } else if (isPromoCode && offerCode.text.length != 7) {
          MySnackBar.error(context, "Offer code should contain 7 letters.");
        } else {
          await NotificationController()
              .uploadNotification("Offers", couponData);
          await NotificationController()
              .uploadNotification("Notifications", offerNotificationData);
        }

        // db.addOffers(OfferClass(
        //     key,
        //     couponData['title'],
        //     couponData['body'],
        //     couponData['receiver'],
        //     couponData['ExpiryDate'],
        //     couponData['OfferCode'],
        //     couponData['discount'],
        //     DateTime.parse(couponData['createdAt']),
        //     false));
      }
      if (!isPromoCode) {
        if (receiverType == AnnouncementReceiverType.user) {
          List<UserInformationClass> users = db.getAllUsers;
          for (var user in users) {
            user.token.isEmpty
                ? null
                : {
                    for (var token in user.token)
                      {
                        NotificationController().sendFCM(
                            type == AnnouncementType.announcement
                                ? data
                                : couponData,
                            token.split("?deviceId").first)
                      }
                  };
          }
          db.setLoader(false);
        }
        if (receiverType == AnnouncementReceiverType.guard) {
          List<ProvidersInformationClass> guards = db.getAllProviders;
          for (var guard in guards) {
            guard.tokens == []
                ? null
                : {
                    for (var token in guard.tokens)
                      {
                        NotificationController().sendFCM(
                            type == AnnouncementType.announcement
                                ? data
                                : couponData,
                            token.split("?deviceId").first)
                      }
                  };
          }
          db.setLoader(false);
        }
      }

      resetForm();
      db.setLoader(false);
    }
  }
}
