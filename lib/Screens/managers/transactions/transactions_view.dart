import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

import '../../../components/pop_ups/download_report_dialog.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  getTransactions() async {
    await FirebaseController(context).getPayments();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final transactions = db.getPayments;
    transactions.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff6200ED),
          foregroundColor: AppColors.whiteColor,
          title: const Text("Transactions"),
          actions: <Widget>[
            loading
                ? const Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: AppColors.whiteColor,
                        )))
                : TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return const DownloadTranReportDialog();
                          });
                    },
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.symmetric(vertical: 2.h),
                      foregroundColor: AppColors.whiteColor,
                    ),
                    child: Text(
                      "Download\nReport",
                      style: GetTextTheme.sf12_medium,
                    )),
            AppServices.addWidth(20.w)
          ]),
      body: SafeArea(
          child: transactions.isEmpty
              ? RefreshIndicator.adaptive(
                  onRefresh: () => getTransactions(),
                  child: ListView(
                    padding: EdgeInsets.all(20.sp),
                    // shrinkWrap: true,
                    children: [
                      AppServices.addHeight(
                          AppServices.getScreenHeight(context) * 0.25),
                      AppServices.getEmptyIcon(
                          "You don't have any transactions yet.",
                          "No Transactions Yet",
                          image: AppImages.noTransactionPng)
                    ],
                  ),
                )
              : RefreshIndicator.adaptive(
                  onRefresh: () => getTransactions(),
                  child: ListView.builder(
                      padding: EdgeInsets.all(15.sp),
                      itemCount: transactions.length,
                      itemBuilder: (context, i) {
                        var transaction = transactions[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.sp),
                                decoration:
                                    WidgetDecoration.containerDecoration_1(
                                        context),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12.sp),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.amber.shade100),
                                          child: Image.asset(
                                            transaction.paymentMethod == "card"
                                                ? AppImages.cardImg
                                                : transaction.paymentMethod ==
                                                        "upi"
                                                    ? AppImages.upiImg
                                                    : AppImages.netBankingImg,
                                            height: 25.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        AppServices.addWidth(10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "${AppServices.getCurrencySymbol} ${transaction.amount}",
                                                  style:
                                                      GetTextTheme.sf16_bold),
                                              Text(transaction.description,
                                                  style: GetTextTheme
                                                      .sf12_regular
                                                      .copyWith(
                                                          color: AppColors
                                                              .greyColor))
                                            ],
                                          ),
                                        ),
                                        AppServices.addWidth(20.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(transaction.userId ==
                                                    db.adminDetails['id']
                                                ? "Debit"
                                                : "Credit"),
                                            AppServices.addHeight(2.h),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                  color: transaction.status ==
                                                          "Success"
                                                      ? AppColors.greenColor
                                                      : AppColors.redColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r)),
                                              child: Text(
                                                transaction.status,
                                                style: GetTextTheme.sf14_medium
                                                    .copyWith(
                                                        color: AppColors
                                                            .whiteColor),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AppServices.addHeight(2.h),
                              Text(
                                DateFormat("dd MMM yyyy")
                                    .format(transaction.createdOn),
                                style: GetTextTheme.sf12_regular,
                              )
                            ],
                          ),
                        );
                      }),
                )),
    );
  }
}
