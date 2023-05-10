// import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:edu_market/components/rating_bar_indicator.dart';
// import 'package:edu_market/controllers/app_functions.dart';
// import 'package:edu_market/helpers/app_services.dart';
// import 'package:edu_market/main.dart';
// import 'package:edu_market/screens/public_profile/details_screens/org_details_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../shimmers/circular_shimmer.dart';
// import '../../controllers/app_data_controller.dart';
// import '../../controllers/widget_creator.dart';
// import '../../helpers/style_sheet.dart';

// class TopRatedOrganizationListHolder extends StatelessWidget {
//   TopRatedOrganizationListHolder({
//     Key? key,
//   }) : super(key: key);

//   final _functions = FunctionsController();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Top Rating ★", style: GetTextTheme.sf16_bold),
//             TextButton(
//                 onPressed: () {},
//                 child: Text("View All", style: GetTextTheme.sf16_regular)),
//           ],
//         ),
//         Consumer<AppDatabase>(builder: (context, data, child) {
//           final topOrgList = data.getAllOrganizationData;
//           return SizedBox(
//             height: 140.h,
//             child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, i) {
//                   final orgTop = topOrgList[i];
//                   return InkWell(
//                     onTap: () => AppServices.pushTo(
//                         context, PublicViewOrgDetails(profile: orgTop)),
//                     child: AspectRatio(
//                       aspectRatio: 0.8,
//                       child: GridTile(
//                           header: Align(
//                             alignment: Alignment.centerRight,
//                             child: Padding(
//                               padding: EdgeInsets.all(5.sp),
//                               child: BouncingWidget(
//                                 duration: const Duration(milliseconds: 100),
//                                 scaleFactor: 1.5,
//                                 onPressed: () =>
//                                     _functions.favOrganization(orgTop, context),
//                                 child: data.isOrgFavorite(orgTop.orgId)
//                                     ? const Icon(Icons.favorite,
//                                         color: AppColors.primaryColor)
//                                     : const Icon(Icons.favorite_border),
//                               ),
//                             ),
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(10.sp),
//                             decoration: WidgetDecoration.containerDecoration_1(
//                                 enableShadow: true),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Container(
//                                   height: 60.sp,
//                                   width: 60.sp,
//                                   decoration: WidgetDecoration
//                                       .circularContainerDecoration_1(),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(100.r),
//                                     child: WidgetImplimentor().addNetworkImage(
//                                         url: orgTop.logo,
//                                         placeHolder:
//                                             const CircularShimmerView()),
//                                   ),
//                                 ),
//                                 Text(orgTop.name,
//                                     textAlign: TextAlign.center,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GetTextTheme.sf14_bold),
//                                 Text("${orgTop.city}, ${orgTop.state}",
//                                     style: GetTextTheme.sf12_regular),
//                                 ItemRatingIndicator(rating: orgTop.rating),
//                               ],
//                             ),
//                           )),
//                     ),
//                   );
//                 },
//                 separatorBuilder: (context, i) => SizedBox(width: 10.w),
//                 itemCount: topOrgList.length),
//           );
//         }),
//       ],
//     );
//   }
// }
