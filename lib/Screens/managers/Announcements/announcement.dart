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
  AnnouncementType type = AnnouncementType.announcement;
  AnnouncementReceiverType receiverType = AnnouncementReceiverType.user;
  final _titleController = TextEditingController();
  final _discountController = TextEditingController();
  final _msgController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  DateTime? expiryDate;

  String offerCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
            autoLeading: true,
            context: context,
            title: const Text("Create Announcement/Offer")),
        body: Stack(
          children: [
            Form(
                key: _key,
                child: SafeArea(
                    child: ListView(
                  padding: EdgeInsets.all(15.sp),
                  children: [
                    SimpleTextField(
                        name: _titleController,
                        validator: DataValidationController(),
                        label: "Title"),
                    AppServices.addHeight(15.h),
                    SimpleTextField(
                        name: _msgController,
                        validator: DataValidationController(),
                        label: "Message"),
                    AppServices.addHeight(15.h),
                    // Text("Select Type", style: GetTextTheme.sf18_bold),
                    // AppServices.addHeight(5.h),s
                    Row(
                      children: [
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

                    type == AnnouncementType.offer
                        ? Column(
                            children: [
                              AppServices.addHeight(10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        String code =
                                            FunctionsController().generateId();
                                        setState(() {
                                          offerCode = code;
                                        });
                                      },
                                      child: const Text("Generate Offer Code")),
                                  AppServices.addWidth(40.w),
                                  Text(offerCode,
                                      style: GetTextTheme.sf18_bold),
                                ],
                              ),
                              AppServices.addHeight(15.h),
                              SimpleTextField(
                                  inputType: TextInputType.number,
                                  name: _discountController,
                                  label: "Discount in %"),
                            ],
                          )
                        : const SizedBox(),
                    AppServices.addHeight(20.h),
                    type == AnnouncementType.announcement
                        ? const SizedBox()
                        : Column(mainAxisSize: MainAxisSize.min, children: [
                            Text("Select Expiry Date",
                                style: GetTextTheme.sf18_bold),
                            AppServices.addHeight(5.h),
                            CalendarDatePicker(
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 10),
                                onDateChanged: (v) => setState(() {
                                      expiryDate = v;
                                    })),
                          ]),
                    AppServices.addHeight(20.h),
                    Text("Select Receiver", style: GetTextTheme.sf18_bold),
                    AppServices.addHeight(5.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Row(
                              children: [
                                Radio<AnnouncementReceiverType>(
                                    value: AnnouncementReceiverType.user,
                                    groupValue: receiverType,
                                    onChanged: (value) =>
                                        setState(() => receiverType = value!)),
                                Text("User", style: GetTextTheme.sf16_regular)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Row(
                              children: [
                                Radio<AnnouncementReceiverType>(
                                    value: AnnouncementReceiverType.guard,
                                    groupValue: receiverType,
                                    onChanged: (value) =>
                                        setState(() => receiverType = value!)),
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
        ));
  }

  resetForm() {
    _titleController.clear();
    _msgController.clear();
    _discountController.clear();
    offerCode = "";
    type = AnnouncementType.announcement;
    receiverType = AnnouncementReceiverType.user;
    setState(() {});
  }

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
      "OfferCode": offerCode,
      "discount": _discountController.text
    };

    Map<String, dynamic> offerNotificationData = {
      "title": _titleController.text.trim(),
      "body": _msgController.text.trim(),
      "ExpiryDate": expiryDate == null ? "" : expiryDate!.toIso8601String(),
      "createdAt": DateTime.now().toIso8601String(),
      "receiver": receiverType.name,
      "OfferCode": offerCode,
      "discount": _discountController.text,
      "route": "/Offer",
      "notificationType": "offers"
    };
    final db = Provider.of<AppDataController>(context, listen: false);

    if (_key.currentState!.validate()) {
      db.setLoader(true);
      if (type == AnnouncementType.announcement) {
        await NotificationController()
            .uploadNotification("Notifications", data);
      } else {
        if (_discountController.text.isEmpty || offerCode.isEmpty) {
          MySnackBar.error(context, "Please complete the Offer's details");
        } else {
          await NotificationController()
              .uploadNotification("Offers", couponData);
          await NotificationController()
              .uploadNotification("Notifications", offerNotificationData);

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
      }
      if (receiverType == AnnouncementReceiverType.user) {
        List<UserInformationClass> users = db.getAllUsers;
        for (var user in users) {
          user.token == ""
              ? null
              : NotificationController().sendFCM(
                  type == AnnouncementType.announcement ? data : couponData,
                  user.token);
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
                          token)
                    }
                };
        }
        db.setLoader(false);
      }

      resetForm();
      db.setLoader(false);
    }
  }
}
