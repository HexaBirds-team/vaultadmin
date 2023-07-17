// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_data_controller.dart';
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';

import '../../controllers/data_validation_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../simple_textfield.dart';

class AddServiceAreaDialog extends StatefulWidget {
  const AddServiceAreaDialog({Key? key}) : super(key: key);

  @override
  State<AddServiceAreaDialog> createState() => _AddServiceAreaDialogState();
}

class _AddServiceAreaDialogState extends State<AddServiceAreaDialog> {
  final _pinCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _validator = DataValidationController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
              Text("Add Service Area", style: GetTextTheme.sf18_bold),
              AppServices.addHeight(25.h),
              SimpleTextField(
                  name: _pinCodeController,
                  validator: _validator,
                  inputType: TextInputType.number,
                  label: "Enter Service Area Pincode"),
              AppServices.addHeight(15.h),
              SimpleTextField(
                  name: _cityController,
                  validator: _validator,
                  label: "Enter Service Area Name"),
              AppServices.addHeight(20.h),
              db.appLoading
                  ? const OnViewLoader()
                  : Row(
                      children: [
                        Expanded(
                            child: ButtonOneExpanded(
                                onPressed: () => AppServices.popView(context),
                                btnText: "Cancel",
                                enableColor: true,
                                disableGradient: true,
                                btnColor:
                                    AppColors.blackColor.withOpacity(0.15),
                                btnTextColor: true,
                                btnTextClr: AppColors.blackColor)),
                        AppServices.addWidth(15.w),
                        Expanded(
                            child: ButtonOneExpanded(
                                onPressed: () => onSave(db), btnText: "Save"))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

// categoryId

  onSave(AppDataController value) async {
    if (_key.currentState!.validate()) {
      await FirebaseController(context)
          .addServiceArea(_pinCodeController.text, _cityController.text);
    } else {
      null;
    }
  }
}
