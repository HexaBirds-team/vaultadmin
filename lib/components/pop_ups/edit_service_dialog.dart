// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/firebase_controller.dart';
import '../../controllers/data_validation_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../simple_textfield.dart';

class EditServiceDialog extends StatefulWidget {
  ServiceClass service;
  EditServiceDialog({Key? key, required this.service}) : super(key: key);

  @override
  State<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<EditServiceDialog> {
  final _serviceController = TextEditingController();
  final _validator = DataValidationController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  var dropdownValue;

  @override
  void initState() {
    super.initState();
    getStuff();
  }

  getStuff() {
    final db = Provider.of<AppDataController>(context, listen: false);
    CategoryClass category = db.getUserCategories.firstWhere((element) =>
        element.categoryId.trim() == widget.service.categoryId.trim());
    setState(() {
      dropdownValue = category;
      _serviceController.text = widget.service.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context, listen: false);
    return Form(
      key: _key,
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), side: BorderSide.none),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Services", style: GetTextTheme.sf18_bold),
              AppServices.addHeight(10.h),
              SimpleTextField(
                name: _serviceController,
                validator: _validator,
                label: "Enter Service Name",
                hint: "ATM security",
              ),
              AppServices.addHeight(10.h),
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: AppColors.greyColor)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: dropdownValue,
                          items: db.getUserCategories
                              .map<DropdownMenuItem<CategoryClass>>(
                                  (e) => DropdownMenuItem<CategoryClass>(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                              .toList(),
                          onChanged: (v) => setState(() {
                                dropdownValue = v;
                              })))),
              AppServices.addHeight(20.h),
              Row(
                children: [
                  Expanded(
                      child: ButtonOneExpanded(
                          onPressed: () => AppServices.popView(context),
                          btnText: "Cancel",
                          enableColor: true,
                          disableGradient: true,
                          btnColor: AppColors.blackColor.withOpacity(0.15),
                          btnTextColor: true,
                          btnTextClr: AppColors.blackColor)),
                  AppServices.addWidth(15.w),
                  Expanded(
                      child: ButtonOneExpanded(
                          onPressed: () => onUpdate(db), btnText: "Update"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

// categoryId

  onUpdate(AppDataController value) async {
    final adminCallbacks = FirebaseController(context);
    value.setLoader(true);
    if (_key.currentState!.validate()) {
      Map<String, dynamic> data = {
        "name": _serviceController.text,
        "categoryId": dropdownValue.categoryId
      };
      await adminCallbacks.updateService(data, widget.service.serviceId);
      value.setLoader(false);
    } else {
      value.setLoader(false);
      null;
    }
  }
}
