// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/custom_appbar.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/full_screen_loader.dart';
import 'package:valt_security_admin_panel/components/simple_textfield.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // text field controllers
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Global Form key
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool loading = false;
  @override
  void initState() {
    super.initState();
    getstuff();
  }

  getstuff() {
    final db = Provider.of<AppDataController>(context, listen: false);

    _namecontroller.text = (db.adminDetails)['username'].toString();
    _passwordController.text = (db.adminDetails)['password'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppServices.keyboardUnfocus(context),
      child: Scaffold(
        appBar: customAppBar(
            context: context,
            title: const Text("Update Profile"),
            autoLeading: true),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SimpleTextField(
                          name: _namecontroller,
                          label: "Username",
                          validator: DataValidationController()),
                      AppServices.addHeight(20.h),
                      SimpleTextField(
                          label: "Password",
                          isObsecure: true,
                          name: _passwordController,
                          validator: DataValidationController()),
                      AppServices.addHeight(45.h),
                      ButtonOneExpanded(
                          onPressed: () => onUpdate(), btnText: "Update"),
                    ],
                  ),
                ),
              ),
            ),
            loading ? const FullScreenLoader() : const SizedBox()
          ],
        ),
      ),
    );
  }

  onUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      final db = Provider.of<AppDataController>(context, listen: false);
      await FirestoreApiReference.adminPath.update({
        "username": _namecontroller.text,
        "password": _passwordController.text
      }).then((value) async {
        final snapshot = await FirestoreApiReference.adminPath.get();
        final data = snapshot.data()!;
        db.setAdminDetails(data);
        setState(() => loading = false);
      });
    } else {
      null;
    }
  }
}
