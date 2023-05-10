// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/Screens/BottomNavBar/bottom_nav_bar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/app_settings_controller.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import '../../helpers/app_theme.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
// Text Field Controllers
  final _name = TextEditingController();
  final _password = TextEditingController();

//Global Form key
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppServices.keyboardUnfocus(context),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppServices.addHeight(50.h),
                    Text("Let's Sign You In", style: GetTextTheme.sf35_bold),
                    AppServices.addHeight(15),
                    Text("Welcome back Admin, you've been missed!",
                        style: GetTextTheme.sf18_regular.copyWith(
                            color: Appthemes(context: context)
                                .isDarkMode()
                                .withOpacity(0.5))),
                    AppServices.addHeight(70.h),
                    SimpleTextField(
                        name: _name,
                        validator: DataValidationController(),
                        label: "Username"),
                    AppServices.addHeight(20.h),
                    SimpleTextField(
                      name: _password,
                      isObsecure: true,
                      validator: DataValidationController(),
                      label: "Password",
                    ),
                    AppServices.addHeight(45.h),
                    loading
                        ? const OnViewLoader()
                        : ButtonOneExpanded(
                            onPressed: () => onContinue(),
                            btnText: "Continue",
                            gradient: AppColors.appGradientColor),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  onContinue() async {
    final db = Provider.of<AppDataController>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final path = await database.ref('Admin').get();
      final data = path.value as Map<Object?, Object?>;
      if (data['username'].toString() == _name.text &&
          data['password'].toString() == _password.text) {
        db.setAdminDetails(data);
        await preference.setBool("isLogin", true);
        AppServices.pushAndRemove(BottomNavBar(), context);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        MySnackBar.error(context, "Username or password doesn't match");
      }
    } else {
      null;
    }
  }
}
