// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/app_data_controller.dart';
// import '../../controllers/widget_creator.dart';
// import '../../helpers/base_getters.dart';
// import '../../helpers/style_sheet.dart';

// class PublicViewCategoryList extends StatefulWidget {
//   const PublicViewCategoryList({Key? key}) : super(key: key);

//   @override
//   State<PublicViewCategoryList> createState() => _PublicViewCategoryListState();
// }

// class _PublicViewCategoryListState extends State<PublicViewCategoryList> {
//   bool expandCategory = false;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text("Categories", style: GetTextTheme.sf16_bold),
//         AppServices.addHeight(10.h),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 400),
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//           alignment: Alignment.center,
//           decoration: WidgetDecoration.containerDecoration_1(),
//           child: Consumer<AppDatabase>(builder: (context, data, child) {
//             final categories = data.getUserCategories;
//             return GridView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 itemCount: expandCategory
//                     ? categories.length + 1
//                     : (categories.length <= 9 ? categories.length : 10),
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     crossAxisSpacing: 10.w,
//                     mainAxisSpacing: 15.h,
//                     childAspectRatio: 1),
//                 itemBuilder: (context, i) {
//                   return (expandCategory ? i != categories.length : i != 9)
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             WidgetImplimentor()
//                                 .addNetworkImage(url: categories[i].icon),
//                             AppServices.addHeight(3.h),
//                             Text(categories[i].name)
//                           ],
//                         )
//                       : InkWell(
//                           onTap: () =>
//                               setState(() => expandCategory = !expandCategory),
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 35,
//                             width: 35,
//                             decoration: WidgetDecoration
//                                 .circularContainerDecoration_1(),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 expandCategory
//                                     ? const SizedBox()
//                                     : Text((categories.length - 9).toString(),
//                                         style: GetTextTheme.sf16_bold),
//                                 Icon(
//                                   expandCategory
//                                       ? Icons.keyboard_arrow_up
//                                       : Icons.keyboard_arrow_down_outlined,
//                                   color: AppColors.blackColor.withOpacity(0.3),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                 });
//           }),
//         ),
//       ],
//     );
//   }
// }
