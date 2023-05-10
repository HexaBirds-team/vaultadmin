// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rating_dialog/rating_dialog.dart';

// import '../../controllers/app_functions.dart';
// import '../../controllers/widget_creator.dart';
// import '../../helpers/style_sheet.dart';
// class OrganizationRatingDialog extends StatelessWidget {
//   const OrganizationRatingDialog({
//     super.key,
//   });


//   @override
//   Widget build(BuildContext context) {
//     return
//      RatingDialog(
//         image: ClipRRect(
//           borderRadius: BorderRadius.circular(200.r),
//           child: WidgetImplimentor()
//               .addNetworkImage(url: profile.logo, height: 65.sp),
//         ),
//         title: Text("Rate ${profile.name}",
//             textAlign: TextAlign.center, style: GetTextTheme.sf18_bold),
//         submitButtonText: "Submit",
//         enableComment: true,
//         commentHint: "What you think about ${profile.name}...",
//         starSize: 20.sp,
//         onSubmitted: (v) =>
//             functions.postReview(v.comment, v.rating, profile.orgId));
//   }
// }
