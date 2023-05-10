// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../controllers/admin_callback_controller.dart';
import '../../controllers/app_data_controller.dart';
import '../../controllers/app_functions.dart';
import '../../controllers/data_validation_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../loaders/on_view_loader.dart';
import '../simple_textfield.dart';

class AddNewCategoryPopUp extends StatefulWidget {
  const AddNewCategoryPopUp({Key? key}) : super(key: key);

  @override
  State<AddNewCategoryPopUp> createState() => _AddNewCategoryPopUpState();
}

class _AddNewCategoryPopUpState extends State<AddNewCategoryPopUp> {
  /* Text Input controllers */
  final _name = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _validator = DataValidationController();
  final _adminCallbacks = AdminCallbacksController();
  final _appFunctions = FunctionsController();

  final _picker = ImagePicker();

  CroppedFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    final dt = Provider.of<AppDataController>(context);

    return Form(
        key: _key,
        child: SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          contentPadding: EdgeInsets.all(15.sp),
          title: Text("Category Detail", style: GetTextTheme.sf16_bold),
          children: [
            SizedBox(width: AppServices.getScreenWidth(context)),
            SimpleTextField(
                name: _name,
                validator: _validator,
                label: "Category Name",
                hint: "Security Guard"),
            AppServices.addHeight(15.h),
            Row(
              children: [
                InkWell(
                  onTap: () => onImagePicked(),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 15),
                      decoration: WidgetDecoration.containerDecoration_1(context),
                      child: Text("Choose Image",
                          style: GetTextTheme.sf14_regular)),
                ),
                AppServices.addWidth(10.w),
                _pickedFile == null
                    ? const SizedBox()
                    : Expanded(
                        child: SizedBox(
                            child: Text(_pickedFile!.path.split('/').last,
                                style: GetTextTheme.sf12_regular)))
              ],
            ),
            AppServices.addHeight(7.h),
            const Divider(thickness: 1.5),
            AppServices.addHeight(7.h),
            Consumer<AppDataController>(
                builder: (context, data, child) => data.appLoading
                    ? const OnViewLoader()
                    : Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  child: ButtonOneExpanded(
                                      onPressed: () =>
                                          AppServices.popView(context),
                                      btnText: "Cancel",
                                      enableColor: true,
                                      disableGradient: true,
                                      btnColor:
                                          AppColors.blackColor.withOpacity(0.2),
                                      btnTextColor: true,
                                      btnTextClr: AppColors.blackColor))),
                          AppServices.addWidth(10),
                          Expanded(
                              child: SizedBox(
                            child: ButtonOneExpanded(
                                onPressed: () => onSubmit(data),
                                btnText: "Save"),
                          )),
                        ],
                      ))
          ],
        ));
  }

  Future<Map<String, dynamic>> getFormData() async {
    Map<String, dynamic> data = {
      "name": _name.text.trim(),
      "image": await _appFunctions.uploadImageToStorage(File(_pickedFile!.path))
    };
    return data;
  }

  onSubmit(AppDataController value) async {
    value.setLoader(true);
    if (_key.currentState!.validate()) {
      var data = await getFormData();
      await _adminCallbacks.addNewCategoryCallback(data, context);
      value.setLoader(false);
    } else {
      value.setLoader(false);
      null;
    }
  }

  onImagePicked() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final croppedImage = await FunctionsController()
        .cropImage(path: picked.path, squareRatio: true);
    setState(() => _pickedFile = croppedImage);
  }
}
