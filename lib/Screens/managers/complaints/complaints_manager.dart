// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/managers/complaints/complaint_details_view.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';

import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';
import '../../../models/enums.dart';

class ComplaintsManager extends StatefulWidget {
  String status;
  ComplaintsManager({super.key, this.status = "pending"});

  @override
  State<ComplaintsManager> createState() => _ComplaintsManagerState();
}

class _ComplaintsManagerState extends State<ComplaintsManager> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final complaints = db.getAllComplaints
        .where((element) => element.status.name == widget.status)
        .toList();
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: complaints.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppIcons.emptyIcon,
                          height: 70.sp,
                        ),
                        AppServices.addHeight(10.h),
                        Text("No Data Found", style: GetTextTheme.sf18_bold),
                        Text("There are no new complaints available.",
                            style: GetTextTheme.sf14_regular)
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: complaints.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      final data = complaints[i];
                      return InkWell(
                        onTap: () => AppServices.pushTo(
                            context, ComplaintDetailsView(data: data)),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.sp, horizontal: 10.sp),
                          padding: const EdgeInsets.fromLTRB(15, 7, 0, 15),
                          width: AppServices.getScreenWidth(context),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.4),
                                width: 1.5.sp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Complaint Number",
                                          style: GetTextTheme.sf12_regular
                                              .copyWith(
                                                  color: AppColors.greyColor)),
                                      AppServices.addHeight(5.h),
                                      Text(data.complaintId,
                                          style: GetTextTheme.sf16_medium),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Status",
                                        style: GetTextTheme.sf12_regular
                                            .copyWith(
                                                color: AppColors.greyColor),
                                      ),
                                      Text(
                                          data.status.name.replaceFirst(
                                              data.status.name[0],
                                              data.status.name[0]
                                                  .toUpperCase()),
                                          style: GetTextTheme.sf16_medium
                                              .copyWith(
                                                  color: data.status ==
                                                          ComplaintStatus
                                                              .resolved
                                                      ? AppColors.greenColor
                                                      : data.status ==
                                                              ComplaintStatus
                                                                  .processing
                                                          ? AppColors
                                                              .yellowColor
                                                          : AppColors
                                                              .redColor)),
                                    ],
                                  ),
                                  AppServices.addWidth(20.w)
                                ],
                              ),
                              AppServices.addHeight(10.h),
                              Text(
                                data.complaint,
                                style: GetTextTheme.sf14_regular,
                              ),
                              AppServices.addHeight(10.h),
                              Text(
                                  DateFormat('EEEE, MMMM dd, yyyy')
                                      .format(DateTime.parse(data.createdOn)),
                                  style: GetTextTheme.sf12_regular
                                      .copyWith(color: AppColors.greyColor)),
                            ],
                          ),
                        ),
                      );
                    })));
  }
}
