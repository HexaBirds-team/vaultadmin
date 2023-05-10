// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/app_data_controller.dart';
// import '../../controllers/auth_controller.dart';
// import '../../helpers/style_sheet.dart';

// class SimNumberSelector extends StatefulWidget {
//   List<SimCard> cards;
//   SimNumberSelector({Key? key, required this.cards}) : super(key: key);

//   @override
//   State<SimNumberSelector> createState() => _SimNumberSelectorState();
// }

// class _SimNumberSelectorState extends State<SimNumberSelector> {
//   final functions = AuthController();
//   @override
//   Widget build(BuildContext context) {
//     final database = Provider.of<AppDatabase>(context);
//     return SimpleDialog(
//       title: Text("Select Number", style: GetTextTheme.sf16_bold),
//       children: [
//         const Divider(),
//         ...widget.cards
//             .map((e) => ListTile(
//                   onTap: database.appLoading
//                       ? null
//                       : () => functions.phoneAuth("+91${e.number}", context),
//                   leading: Container(
//                       alignment: Alignment.center,
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                           color: AppColors.blackColor.withOpacity(0.1),
//                           shape: BoxShape.circle),
//                       child: Text("${e.countryPhonePrefix}",
//                           style: GetTextTheme.sf16_regular)),
//                   title: Text("${e.number}"),
//                 ))
//             .toList(),
//         database.appLoading
//             ? const Center(
//                 child: SizedBox(
//                     height: 24, width: 24, child: CircularProgressIndicator()))
//             : const SizedBox()
//       ],
//     );
//   }
// }
