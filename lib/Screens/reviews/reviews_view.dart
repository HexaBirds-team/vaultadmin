// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/reviews/review_tile.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';

import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class ReviewsView extends StatefulWidget {
  const ReviewsView({super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  double ratings = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  getSession() async {
    await FirebaseController(context).getReviews();
    ratings = 0.0;
    final db = Provider.of<AppDataController>(context, listen: false);
    final reviewsList = db.getReviews;
    final totalRating = reviewsList
        .map((e) => e.ratings)
        .toList()
        .reduce((value, element) => value + element);
    // for (var review in reviewsList) {
    //   ratings += review.ratings;
    // }
    ratings = totalRating / reviewsList.length;
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    final allReviews = db.getReviews;
    allReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: customAppBar(
          context: context,
          title: const Text("Reviews"),
          autoLeading: true,
          action: <Widget>[
            loading
                ? const Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator.adaptive()))
                : const SizedBox(),
            AppServices.addWidth(20.w)
          ]),
      body: SafeArea(
          child: allReviews.isEmpty
              ? RefreshIndicator.adaptive(
                  onRefresh: () => getSession(),
                  child: ListView(
                    padding: EdgeInsets.all(20.sp),
                    // shrinkWrap: true,
                    children: [
                      AppServices.addHeight(
                          AppServices.getScreenHeight(context) * 0.25),
                      AppServices.getEmptyIcon(
                          "There are not any reviews yet.", "No Reviews Found")
                    ],
                  ),
                )
              : RefreshIndicator.adaptive(
                  onRefresh: () => getSession(),
                  child: ListView(
                    padding: EdgeInsets.all(20.sp),
                    children: [
                      Center(
                        child: Text(
                            (ratings.isNaN ? 0 : ratings).toStringAsFixed(1),
                            style: GetTextTheme.sf40_bold),
                      ),
                      AppServices.addHeight(5.h),
                      Center(
                        child: RatingBar(
                            ignoreGestures: true,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemSize: 25.sp,
                            initialRating: ratings.isNaN ? 0 : ratings,
                            ratingWidget: RatingWidget(
                                full: const Icon(Icons.star,
                                    color: AppColors.yellowColor),
                                half: const Icon(Icons.star_half,
                                    color: AppColors.yellowColor),
                                empty: const Icon(Icons.star_border,
                                    color: AppColors.yellowColor)),
                            onRatingUpdate: (rating) {}),
                      ),
                      Center(
                        child: Text(
                          "based on ${allReviews.length} reviews",
                          style: GetTextTheme.sf14_regular,
                        ),
                      ),
                      AppServices.addHeight(20.h),
                      Wrap(
                        runSpacing: 8,
                        children: [
                          linearprogressbar(
                              "Excellent",
                              AppColors.greenColor,
                              (FunctionsController.filterReviewList(
                                                  allReviews, 4.5, 5.0)
                                              .length /
                                          allReviews.length)
                                      .isNaN
                                  ? 0
                                  : FunctionsController.filterReviewList(
                                              allReviews, 4.5, 5.0)
                                          .length /
                                      allReviews.length),
                          linearprogressbar(
                              "Very Good",
                              AppColors.lightgreenColor,
                              (FunctionsController.filterReviewList(
                                                  allReviews, 3.5, 4.4)
                                              .length /
                                          allReviews.length)
                                      .isNaN
                                  ? 0
                                  : FunctionsController.filterReviewList(
                                              allReviews, 3.5, 4.4)
                                          .length /
                                      allReviews.length),
                          linearprogressbar(
                              "Good",
                              AppColors.yellowColor,
                              (FunctionsController.filterReviewList(
                                                  allReviews, 2.5, 3.4)
                                              .length /
                                          allReviews.length)
                                      .isNaN
                                  ? 0
                                  : FunctionsController.filterReviewList(
                                              allReviews, 2.5, 3.4)
                                          .length /
                                      allReviews.length),
                          linearprogressbar(
                              "Bad",
                              AppColors.orangeColor.withOpacity(0.6),
                              (FunctionsController.filterReviewList(
                                                  allReviews, 1.5, 2.4)
                                              .length /
                                          allReviews.length)
                                      .isNaN
                                  ? 0
                                  : FunctionsController.filterReviewList(
                                              allReviews, 1.5, 2.4)
                                          .length /
                                      allReviews.length),
                          linearprogressbar(
                              "Very Bad",
                              AppColors.redColor,
                              (FunctionsController.filterReviewList(
                                                  allReviews, 0, 1.4)
                                              .length /
                                          allReviews.length)
                                      .isNaN
                                  ? 0
                                  : FunctionsController.filterReviewList(
                                              allReviews, 0, 1.4)
                                          .length /
                                      allReviews.length),
                        ],
                      ),
                      ListView.builder(
                          padding: EdgeInsets.only(top: 30.h),
                          itemCount: allReviews.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return ReviewsTile(review: allReviews[i]);
                          })
                    ],
                  ),
                )),
    );
  }

  Row linearprogressbar(String title, Color progressColor, double percentage) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: GetTextTheme.sf16_regular,
          ),
        ),
        Expanded(
            flex: 2,
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 8.sp,
              percent: percentage,
              backgroundColor: AppColors.grey50,
              progressColor: progressColor,
            ))
      ],
    );
  }
}
