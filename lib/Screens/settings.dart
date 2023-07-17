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
import 'package:valt_security_admin_panel/controllers/firebase_controller.dart';
import 'package:valt_security_admin_panel/controllers/firestore_api_reference.dart';
import 'package:valt_security_admin_panel/controllers/snackbar_controller.dart';
import 'package:valt_security_admin_panel/helpers/base_getters.dart';
import 'package:valt_security_admin_panel/helpers/icons_and_images.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../components/gradient_components/gradient_image.dart';
import '../helpers/style_sheet.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // text field controllers
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _morningStartTime = TextEditingController();
  final TextEditingController _morningEndTime = TextEditingController();
  final TextEditingController _eveningStartTime = TextEditingController();
  final TextEditingController _eveningEndTime = TextEditingController();

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
    final morningShift =
        db.getShiftTime.where((element) => element.id == "Morning").toList();
    final eveningShift =
        db.getShiftTime.where((element) => element.id == "Evening").toList();
    _namecontroller.text = (db.adminDetails)['username'].toString();
    _passwordController.text = (db.adminDetails)['password'].toString();
    _morningStartTime.text =
        morningShift.isEmpty ? "" : morningShift.first.startTime;
    _morningEndTime.text =
        morningShift.isEmpty ? "" : morningShift.first.endTime;
    _eveningStartTime.text =
        eveningShift.isEmpty ? "" : eveningShift.first.startTime;
    _eveningEndTime.text =
        eveningShift.isEmpty ? "" : eveningShift.first.endTime;
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
                      AppServices.addHeight(40.h),
                      shiftForm(
                          _morningStartTime,
                          _morningEndTime,
                          "Morning Shift Time",
                          () => updateMorningShift(),
                          "Update Morning Shift"),
                      AppServices.addHeight(40.h),
                      shiftForm(
                          _eveningStartTime,
                          _eveningEndTime,
                          "Evening Shift Time",
                          () => updateEveningShift(),
                          "Update Evening Shift")
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

  shiftForm(
      TextEditingController startTimeController,
      TextEditingController endTimeController,
      String title,
      Function ontap,
      String btnText) {
    var hourStart = startTimeController.text.isEmpty
        ? DateTime.now()
        : DateTime(
            2000,
            01,
            01,
            int.parse(startTimeController.text.split(":").first),
            int.parse(
                startTimeController.text.split(":").last.split(" ").first));
    var hourEnd = endTimeController.text.isEmpty
        ? DateTime.now()
        : DateTime(
            2000,
            01,
            01,
            int.parse(endTimeController.text.split(":").first),
            int.parse(endTimeController.text.split(":").last.split(" ").first));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GetTextTheme.sf18_bold),
        AppServices.addHeight(20.h),
        shiftTextField(() async {
          var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 00));
          startTimeController.text =
              "${time!.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} ${time.period.name}";

          setState(() {});
        }, "Select Start Time", "", startTimeController),
        AppServices.addHeight(20.h),
        shiftTextField(() async {
          var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 00));
          endTimeController.text =
              "${time!.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} ${time.period.name}";

          setState(() {});
        }, "Select End Time", "", endTimeController),
        AppServices.addHeight(45.h),
        ButtonOneExpanded(
            onPressed: () {
              if (startTimeController.text.isNotEmpty &&
                  endTimeController.text.isNotEmpty) {
                ontap();
              } else {
                MySnackBar.error(context, "Please select start and end time");
              }
            },
            btnText: btnText),
      ],
    );
  }

  updateMorningShift() async {
    setState(() {
      loading = true;
    });
    final db = Provider.of<AppDataController>(context, listen: false);
    var shiftData =
        ShiftTimeModel("Morning", _morningStartTime.text, _morningEndTime.text);
    await firestore
        .collection("Shift")
        .doc("Morning")
        .update({"start": _morningStartTime.text, "end": _morningEndTime.text});

    db.getShiftTime.length < 2 &&
            !db.getShiftTime.any((element) => element.id == shiftData.id)
        ? db.addShiftTime(shiftData)
        : db.updateShiftTime(shiftData);
    // loading = false;
    MySnackBar.success(context, "Shift updated successfully");
    setState(() {
      loading = false;
    });
  }

  updateEveningShift() async {
    setState(() {
      loading = true;
    });
    final db = Provider.of<AppDataController>(context, listen: false);
    var shiftData =
        ShiftTimeModel("Evening", _eveningStartTime.text, _eveningEndTime.text);
    await firestore
        .collection("Shift")
        .doc("Evening")
        .update({"start": _eveningStartTime.text, "end": _eveningEndTime.text});
    db.getShiftTime.length < 2 &&
            !db.getShiftTime.any((element) => element.id == shiftData.id)
        ? db.addShiftTime(shiftData)
        : db.updateShiftTime(shiftData);

    MySnackBar.success(context, "Shift updated successfully");

    setState(() {
      loading = false;
    });
  }

  shiftTextField(Function ontap, String hint, String errorText,
      TextEditingController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            ontap();
          },
          controller: controller,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.sp, vertical: 17.sp),
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  borderSide:
                      BorderSide(color: AppColors.blackColor.withOpacity(0.4))),
              suffixIcon: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: ImageGradient(
                      image: AppIcons.calenderIcon,
                      gradient: AppColors.appGradientColor,
                      height: 20.sp,
                      width: 20.sp))),
        ),
        AppServices.addHeight(errorText.isEmpty ? 0 : 3.h),
        errorText.isEmpty
            ? const SizedBox()
            : Text(errorText,
                style: GetTextTheme.sf12_regular
                    .copyWith(color: AppColors.redColor))
      ],
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
