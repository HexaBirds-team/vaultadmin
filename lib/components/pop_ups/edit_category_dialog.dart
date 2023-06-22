// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/firebase_controller.dart';
import '../../controllers/app_data_controller.dart';
import '../../controllers/app_functions.dart';
import '../../controllers/data_validation_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../loaders/on_view_loader.dart';
import '../simple_textfield.dart';

class EditCategoryDialog extends StatefulWidget {
  CategoryClass category;
  EditCategoryDialog({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  /* Text Input controllers */
  final _name = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _validator = DataValidationController();
  final _appFunctions = FunctionsController();

  final _picker = ImagePicker();

  CroppedFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      _name.text = widget.category.name;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration:
                          WidgetDecoration.containerDecoration_1(context),
                      child: Text(
                          _pickedFile == null ? "Choose Image" : "Change Image",
                          style: GetTextTheme.sf14_regular)),
                ),
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
      "image": _pickedFile == null
          ? widget.category.image
          : await _appFunctions.uploadImageToStorage(File(_pickedFile!.path),
              url: widget.category.image)
    };
    return data;
  }

  onSubmit(AppDataController value) async {
    value.setLoader(true);
    if (_key.currentState!.validate()) {
      var data = await getFormData();
      await FirebaseController(context)
          .editCategoryCallBack(data, widget.category.categoryId);
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
