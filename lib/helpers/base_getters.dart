import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valt_security_admin_panel/helpers/style_sheet.dart';

class AppServices {
  /* Height and Width Factors */

  // get width of the screen
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // get height of the screen
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // used to add space between two vertical objects
  static addHeight(double space) => SizedBox(height: space);

  // used to add space between two horizontal objects
  static addWidth(double space) => SizedBox(width: space);

// to check the screen is android or web
  static bool isSmallScreen(BuildContext context) =>
      getScreenWidth(context) <= 360;

// rupees currency symbol
  static String getCurrencySymbol = "\u{20B9}";

  /* Navigation and routing */
  static pushTo(BuildContext context, Widget screen) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => screen));

  static pushAndReplace(Widget screen, BuildContext context) =>
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  // navigate to next screen and remove all the screens behind
  static pushAndRemove(Widget screen, BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);

  // navigation and routing with fade transition
  static fadeTransitionNavigation(BuildContext context, Widget screen) =>
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionDuration: const Duration(milliseconds: 1100),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child)),
          (route) => false);

  // navigate to the previous screen or previous state
  static popView(BuildContext context) => Navigator.of(context).pop();

  // function to unfocus the keyboard on tap on screen
  static keyboardUnfocus(BuildContext context) =>
      FocusScope.of(context).unfocus();

  static bool isDarkMode(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark;
  }

  static TextTheme textTheme(BuildContext context) =>
      Theme.of(context).textTheme;
  static ThemeData theme(BuildContext context) => Theme.of(context);

  static customDivider(double padding, [double opacity = 1]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Divider(
        color: AppColors.greyColor.withOpacity(opacity),
      ),
    );
  }

  // format iso String to Date
  static formatDate(dateTime) => DateFormat('EE, MMM dd, yyyy')
      .format(DateTime.parse(dateTime.toString()))
      .toString();

  // Age calculator
  static experienceCalculation(DateTime date) {
    var d = int.parse(DateFormat("dd").format(date));
    var m = int.parse(DateFormat("MM").format(date));
    var y = int.parse(DateFormat("yy").format(date));
    var d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    var m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    var y1 = int.parse(DateFormat("yy").format(DateTime.now()));
    var day = findDays(m1, y1);

    String days = "";
    String months = "";
    String years = "";

    if (d1 - d >= 0) {
      days = "${d1 - d} Days";
    } else {
      days = "${d1 + day - d} Days";
      m1 = m1 - 1;
    }

    if (m1 - m > 0) {
      months = "${m1 - m} Months";
    } else {
      months = "${m1 + 12 - m} Months";
      y1 = y1 - 1;
    }

    years = "${y1 - y} Years";
    return "$years $months";
  }

  static int findDays(int m2, int y2) {
    int day2;
    if (m2 == 1 ||
        m2 == 3 ||
        m2 == 5 ||
        m2 == 7 ||
        m2 == 8 ||
        m2 == 10 ||
        m2 == 12) {
      day2 = 31;
    } else if (m2 == 4 || m2 == 6 || m2 == 9 || m2 == 11) {
      day2 = 30;
    } else {
      if (y2 % 4 == 0) {
        day2 = 29;
      } else {
        day2 = 28;
      }
    }
    return day2;
  }
}
