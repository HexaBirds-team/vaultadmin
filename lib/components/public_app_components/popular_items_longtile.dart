
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/app_data_controller.dart';
// import '../../controllers/widget_creator.dart';
// import '../../helpers/style_sheet.dart';

// class PopularItemDataHolder extends StatelessWidget {
//   const PopularItemDataHolder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final functions = FunctionsController();
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Popular", style: GetTextTheme.sf16_bold),
//             TextButton(
//                 onPressed: () {},
//                 child: Text("View All", style: GetTextTheme.sf16_regular)),
//           ],
//         ),
//         AppServices.addHeight(5.h),
//         Consumer<AppDatabase>(builder: (context, data, child) {
//           final popularList = data.getAllOrganizationData;
//           popularList.sort((a, b) => b.likes.compareTo(a.likes));
//           return SizedBox(
//             height: 130.h,
//             child: ListView.separated(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               itemCount: popularList.length,
//               itemBuilder: (context, i) {
//                 final popular = popularList[i];
//                 return AspectRatio(
//                   aspectRatio: 20 / 9,
//                   child: Container(
//                     decoration: WidgetDecoration.containerDecoration_1(),
//                     child: Row(
//                       children: [
//                         Expanded(
//                             flex: 2,
//                             child: SizedBox(
//                                 height: 130.h,
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.horizontal(
//                                           left: Radius.circular(10.r)),
//                                       child: WidgetImplimentor()
//                                           .addNetworkImage(
//                                               placeHolder: BoxShimmerView(),
//                                               url: popular.bgImage,
//                                               fit: BoxFit.cover),
//                                     ),
//                                     Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Padding(
//                                           padding: EdgeInsets.all(7.sp),
//                                           child: BouncingWidget(
//                                               duration: const Duration(
//                                                   milliseconds: 100),
//                                               scaleFactor: 1.5,
//                                               onPressed: () =>
//                                                   functions.favOrganization(
//                                                       popular, context),
//                                               child: data.isOrgFavorite(
//                                                       popular.orgId)
//                                                   ? const Icon(Icons.favorite,
//                                                       color: AppColors
//                                                           .primaryColor)
//                                                   : const Icon(
//                                                       Icons.favorite_border)),
//                                         ))
//                                   ],
//                                 ))),
//                         Expanded(
//                             flex: 3,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10.w, vertical: 15.h),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(popular.name,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: GetTextTheme.sf16_bold),
//                                   Text(popular.type),
//                                   AppServices.addHeight(7.h),
//                                   Text("${popular.address} ${popular.city}",
//                                       style: GetTextTheme.sf14_regular.copyWith(
//                                           color: AppColors.blackColor
//                                               .withOpacity(0.5))),
//                                   AppServices.addHeight(5.h),
//                                   Row(
//                                     children: [
//                                       Text("(${popular.rating}) "),
//                                       ItemRatingIndicator(
//                                           rating: popular.rating),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               separatorBuilder: (context, i) => SizedBox(width: 10.w),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
