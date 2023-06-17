// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_icon.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../../components/custom_appbar.dart';
import '../../../../helpers/base_getters.dart';
import '../../../../helpers/style_sheet.dart';
import '../../../models/enums.dart';

class ComplaintDetailsView extends StatefulWidget {
  ComplaintsClass data;
  ComplaintDetailsView({super.key, required this.data});

  @override
  State<ComplaintDetailsView> createState() => _ComplaintDetailsViewState();
}

class _ComplaintDetailsViewState extends State<ComplaintDetailsView> {
  final _msgController = TextEditingController();

  ComplaintStatus status = ComplaintStatus.resolved;
  List<Map<String, dynamic>> complaints = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.data.status;
    });
    getUrl();
  }

  getUrl() async {
    complaints = await FirebaseController(context)
        .getComplaintMessages(widget.data.complaintId);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    List<UserInformationClass> user = db.getAllUsers
        .where((element) => element.uid == widget.data.createdBy)
        .toList();
    List<ProvidersInformationClass> guard = db.getAllProviders
        .where((e) => e.uid == widget.data.createdBy)
        .toList();
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: Text("Complaint Details", style: GetTextTheme.sf20_bold),
        autoLeading: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
          children: [
            InkWell(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.greyColor.withOpacity(0.4),
                          blurRadius: 8)
                    ]),
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: CachedNetworkImage(
                            height: 70.sp,
                            width: 70.sp,
                            imageUrl: widget.data.complaintBy == "user"
                                ? user.first.image
                                : guard.first.profileImage,
                            fit: BoxFit.cover)),
                    AppServices.addWidth(20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.data.complaintBy == "user"
                                  ? user.first.username
                                  : guard.first.name,
                              style: GetTextTheme.sf16_medium),
                          AppServices.addHeight(5.h),
                          Text(
                              "phone : ${widget.data.complaintBy == "user" ? user.first.phone : guard.first.phone}",
                              style: GetTextTheme.sf14_regular
                                  .copyWith(color: AppColors.greyColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25.sp, horizontal: 15.sp),
              width: AppServices.getScreenWidth(context),
              margin: EdgeInsets.symmetric(vertical: 30.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.greyColor.withOpacity(0.4),
                        blurRadius: 8)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Complaint Number",
                            style: GetTextTheme.sf12_regular.copyWith(
                                color: AppColors.greyColor.withOpacity(0.6)),
                          ),
                          AppServices.addHeight(5.h),
                          Text(widget.data.complaintId,
                              style: GetTextTheme.sf16_medium),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Status",
                            style: GetTextTheme.sf12_regular.copyWith(
                                color: AppColors.greyColor.withOpacity(0.6)),
                          ),
                          status == ComplaintStatus.resolved ||
                                  status == ComplaintStatus.cancelled
                              ? Text(
                                  status.name.replaceFirst(status.name[0],
                                      status.name[0].toUpperCase()),
                                  style: GetTextTheme.sf16_medium.copyWith(
                                      color: status == ComplaintStatus.resolved
                                          ? AppColors.greenColor
                                          : AppColors.redColor))
                              : PopupMenuButton<ComplaintStatus>(
                                  itemBuilder: (context) {
                                    return ComplaintStatus.values
                                        .where((element) =>
                                            element !=
                                            ComplaintStatus.cancelled)
                                        .map((e) {
                                      return PopupMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      );
                                    }).toList();
                                  },
                                  child: Text(
                                      status.name.replaceFirst(status.name[0],
                                          status.name[0].toUpperCase()),
                                      style: GetTextTheme.sf16_medium.copyWith(
                                          color: status ==
                                                  ComplaintStatus.processing
                                              ? AppColors.yellowColor
                                              : AppColors.redColor)),
                                  onSelected: (v) async {
                                    await FirestoreApiReference.complaintsPath
                                        .doc(widget.data.complaintId)
                                        .update({"status": v.name});

                                    setState(() {
                                      status = v;
                                    });
                                  },
                                )
                        ],
                      ),
                    ],
                  ),
                  AppServices.addHeight(20.h),
                  Text("Date Time",
                      style: GetTextTheme.sf12_regular.copyWith(
                          color: AppColors.greyColor.withOpacity(0.7))),
                  AppServices.addHeight(10.h),
                  Text(
                      DateFormat('EEEE, MMMM dd, yyyy')
                          .format(DateTime.parse(widget.data.createdOn)),
                      style: GetTextTheme.sf16_medium),
                  AppServices.addHeight(5.h),
                  Text(
                      DateFormat("hh:mm a")
                          .format(DateTime.parse(widget.data.createdOn)),
                      style: GetTextTheme.sf14_regular),
                  AppServices.addHeight(20.h),
                  Text("Detailed Complaint",
                      style: GetTextTheme.sf12_regular.copyWith(
                          color: AppColors.greyColor.withOpacity(0.7))),
                  AppServices.addHeight(5.h),
                  Text(widget.data.complaint,
                      textAlign: TextAlign.center,
                      style: GetTextTheme.sf16_medium),
                  AppServices.addHeight(20.h),
                  Text("Booking Reference Number",
                      style: GetTextTheme.sf12_regular.copyWith(
                          color: AppColors.greyColor.withOpacity(0.7))),
                  AppServices.addHeight(5.h),
                  Text(widget.data.bookingRef,
                      textAlign: TextAlign.center,
                      style: GetTextTheme.sf16_medium),
                ],
              ),
            ),
            FirebaseAnimatedList(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                query: getUrl(),
                itemBuilder: (context, snapshot, animation, i) {
                  var data = snapshot.value as Map<Object?, Object?>;
                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "➤   ${DateFormat("EEEE, MMMM dd, yyyy").format(DateTime.parse(data['sentOn'].toString()))}",
                            style: GetTextTheme.sf14_bold),
                        AppServices.addHeight(8.h),
                        Text(
                          data['msg'].toString(),
                          style: GetTextTheme.sf16_regular,
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
      bottomNavigationBar: status == ComplaintStatus.resolved ||
              status == ComplaintStatus.cancelled
          ? null
          : Padding(
              padding: EdgeInsets.all(20.sp).copyWith(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10.sp,
                  top: 10.sp),
              child: Row(
                children: [
                  Expanded(
                    child: SimpleTextField(
                        name: _msgController,
                        validator: DataValidationController(),
                        label: "Message"),
                  ),
                  AppServices.addWidth(10.sp),
                  InkWell(
                      onTap: _msgController.text.isEmpty
                          ? null
                          : () async {
                              final path = database
                                  .ref(
                                      "Complaints/${widget.data.complaintId}/messages")
                                  .push();
                              await path.set({
                                "msg": _msgController.text,
                                "sentOn": DateTime.now().toIso8601String()
                              });
                              _msgController.clear();
                            },
                      child: GradientIcon(
                          Icons.send, 40.sp, AppColors.appGradientColor))
                ],
              ),
            ),
    );
  }
}
