// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/expanded_btn.dart';
import 'package:valt_security_admin_panel/components/loaders/full_screen_loader.dart';
import 'package:valt_security_admin_panel/controllers/app_functions.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';

import '../../../controllers/app_data_controller.dart';
import '../../../helpers/base_getters.dart';
import '../../../helpers/icons_and_images.dart';
import '../../../helpers/style_sheet.dart';

enum BannerImgState { pick, upload, uploaded }

class AddBannerBottomSheet extends StatefulWidget {
  const AddBannerBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddBannerBottomSheet> createState() => _AddBannerBottomSheetState();
}

class _AddBannerBottomSheetState extends State<AddBannerBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  BannerImgState state = BannerImgState.pick;

  final ImagePicker _picker = ImagePicker();

  CroppedFile? _bannerFile;

  XFile? _bannerImg;

  bool isLoading = false;

  var _bannerId;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
    return SafeArea(
        child: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Banner Image", style: GetTextTheme.sf18_bold),
                AppServices.addHeight(20.h),
                Align(
                    alignment: Alignment.center,
                    child: state != BannerImgState.pick && _bannerFile != null
                        ? Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.file(File(_bannerFile!.path))),
                              AppServices.addHeight(15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonOneExpanded(
                                        onPressed: () => onImagePick(db),
                                        btnText: "Edit Banner",
                                        enableColor: true,
                                        disableGradient: true,
                                        btnColor: AppColors.blackColor
                                            .withOpacity(0.2),
                                        btnTextColor: true,
                                        btnTextClr: AppColors.blackColor),
                                  ),
                                  AppServices.addWidth(15.w),
                                  Expanded(
                                    child: ButtonOneExpanded(
                                      onPressed: state == BannerImgState.upload
                                          ? () => uploadMedia(db)
                                          : null,
                                      btnText: state == BannerImgState.upload
                                          ? "Upload Banner"
                                          : "Uploaded",
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: () => onImagePick(db),
                                child: Image.asset(
                                  AppIcons.imageFile,
                                  height: 120.sp,
                                  width: 120.sp,
                                ),
                              ),
                              AppServices.addHeight(10.h),
                              Text("Add Banner by clicking on above Image.",
                                  style: GetTextTheme.sf14_regular.copyWith(
                                      color: AppColors.blackColor
                                          .withOpacity(0.4))),
                            ],
                          )),
              ],
            ),
          ),
        ),
        db.appLoading ? const FullScreenLoader() : const SizedBox()
      ],
    ));
  }

  /* Image Picker Handler */
  onImagePick(AppDataController controller) async {
    var value = await _picker.pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() => _bannerImg = value);
      await cropImage(controller);
    } else {
      null;
    }
  }

  /* Crop Image Handler */
  Future<void> cropImage(AppDataController controller) async {
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: _bannerImg!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: AppColors.primary1,
              toolbarWidgetColor: AppColors.whiteColor,
              initAspectRatio: CropAspectRatioPreset.ratio16x9,
              hideBottomControls: true,
              lockAspectRatio: true),
          IOSUiSettings(title: 'Image Cropper'),
        ]);
    if (croppedImage != null) {
      setState(() {
        _bannerFile = croppedImage;
        state = BannerImgState.upload;
      });
    } else {
      null;
    }
  }

  uploadMedia(AppDataController db) async {
    db.setLoader(true);
    final path = storage.ref("Banners/${DateTime.now().toIso8601String()}");
    await path.putFile(File(_bannerFile!.path));
    final url = await path.getDownloadURL();
    setState(() {
      _bannerId = url;
    });
    addBanner(db);
  }

  Future<void> addBanner(AppDataController controller) async {
    bool isValid = _descriptionController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _bannerId != null;
    if (isValid) {
      // setState(() => isLoading = true);
      try {
        Map<String, dynamic> data = {
          "description": _descriptionController.text.trim(),
          "details": _detailsController.text.trim(),
          "address": _addressController.text.trim(),
          "phone": _phoneController.text.trim(),
          "name": _nameController.text.trim(),
          "banner": _bannerId,
        };

        await database.ref("Banners").push().set(data);

        setState(() {});
        controller.setLoader(false);
        AppServices.popView(context);
      } catch (e) {
        controller.setLoader(false);
        print(e);
      }
    } else {
      // setState(() => isLoading = false);
      MySnackBar.error(context, "All fields are mandatory");
    }
  }
}
