// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/GuardAccount/guard_profile.dart';
import 'package:valt_security_admin_panel/Screens/managers/complaints/complaints_tab_bar.dart';
import 'package:valt_security_admin_panel/Screens/managers/users/user_profile_view.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../../../components/custom_appbar.dart';
import '../../../../helpers/base_getters.dart';
import '../../../../helpers/style_sheet.dart';
import '../../../components/gradient_components/gradient_icon.dart';
import '../../../components/simple_textfield.dart';
import '../../../controllers/data_validation_controller.dart';
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
  List<dynamic> complaints = [];
  @override
  void initState() {
    super.initState();
    getUrl();
    setState(() {
      status = widget.data.status;
    });
  }

  getUrl() async {
    complaints =
        await FirebaseController(context).getComplaintMessages(widget.data.id);
    // print(complaints);
    if (!mounted) return;
    setState(() {});
  }

  String message = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    List<UserInformationClass> user = db.getAllUsers
        .where((element) => element.uid == widget.data.createdBy)
        .toList();
    List<ProvidersInformationClass> guard = db.getAllProviders
        .where((e) => e.uid == widget.data.createdBy)
        .toList();
    print("************  Bottom Value ***************");
    print(MediaQuery.of(context).viewInsets.bottom);
    return WillPopScope(
      onWillPop: () async {
        AppServices.pushAndReplace(const ComplaintsTabBarView(), context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(
          context: context,
          title: Text("Complaint Details", style: GetTextTheme.sf20_bold),
          autoLeading: true,
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
            children: [
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: WidgetDecoration.containerDecoration_1(context),
                //  BoxDecoration(
                //     borderRadius: BorderRadius.circular(15.r),
                //     color: Theme.of(context).primaryColor,
                //     boxShadow: [
                //       BoxShadow(
                //           color: AppColors.greyColor.withOpacity(0.4),
                //           blurRadius: 8)
                //     ]),
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.network(
                            widget.data.complaintBy == "user"
                                ? user.first.image
                                : guard.first.profileImage,
                            height: 70.sp,
                            width: 70.sp,
                            fit: BoxFit.cover)),
                    //  CachedNetworkImage(
                    //     height: 70.sp,
                    //     width: 70.sp,
                    //     imageUrl: widget.data.complaintBy == "user"
                    //         ? user.first.image
                    //         : guard.first.profileImage,
                    //     fit: BoxFit.cover)),
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
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.greenColor,
                            foregroundColor: AppColors.whiteColor),
                        onPressed: () {
                          widget.data.complaintBy == "user"
                              ? AppServices.pushTo(
                                  context, UserProfileView(user: user.first))
                              : AppServices.pushTo(
                                  context,
                                  GuardProfileView(
                                      providerDetails: guard.first));
                        },
                        child: const Text("View Profile"))
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 25.sp, horizontal: 15.sp),
                width: AppServices.getScreenWidth(context),
                margin: EdgeInsets.symmetric(vertical: 30.h),
                decoration: WidgetDecoration.containerDecoration_1(context),
                // BoxDecoration(
                //     borderRadius: BorderRadius.circular(15.r),
                //     color: Theme.of(context).primaryColor,
                //     boxShadow: [
                //       BoxShadow(
                //           color: AppColors.greyColor.withOpacity(0.4),
                //           blurRadius: 8)
                //     ]),
                child: Column(
                  children: [
                    /* complaint number and status row */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /* complaint number column */
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
                        /* status  column */
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
                                        color:
                                            status == ComplaintStatus.resolved
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
                                        style: GetTextTheme.sf16_medium
                                            .copyWith(
                                                color: status ==
                                                        ComplaintStatus
                                                            .processing
                                                    ? AppColors.yellowColor
                                                    : AppColors.redColor)),
                                    onSelected: (v) async {
                                      setState(() {
                                        status = v;
                                      });
                                      print(status);
                                      db.updateComplaintStatus(
                                          widget.data.id, status);
                                      await FirestoreApiReference.complaintsPath
                                          .doc(widget.data.id)
                                          .update({"status": v.name});
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
              // const TextField(),
              ...List.generate(complaints.length, (index) {
                var data = complaints[index];
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
                    top: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SimpleTextField(
                              name: _msgController,
                              validator: DataValidationController(),
                              label: "Message",
                              onChange: (v) => {
                                    setState(() => message = v),
                                  }),
                        ),
                        AppServices.addWidth(10.sp),
                        loading
                            ? const OnViewLoader()
                            : IconButton(
                                onPressed: () async {
                                  var now = DateTime.now().toIso8601String();
                                  Map<String, dynamic> data = {
                                    "msg": message,
                                    "sentOn": now
                                  };
                                  if (message.isNotEmpty) {
                                    setState(() {
                                      loading = true;
                                    });
                                    final path = firestore
                                        .collection("Complaints")
                                        .doc(widget.data.id)
                                        .collection("messages");

                                    await path.add(data);
                                    complaints.add(data);
                                    message = "";
                                    _msgController.clear();
                                    loading = false;
                                    setState(() {});
                                  }
                                },
                                icon: GradientIcon(Icons.send, 40.sp,
                                    AppColors.appGradientColor))
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
