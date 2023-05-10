// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valt_security_admin_panel/components/loaders/on_view_loader.dart';
import 'package:valt_security_admin_panel/controllers/data_validation_controller.dart';
import 'package:valt_security_admin_panel/models/app_models.dart';

import '../../controllers/admin_callback_controller.dart';
import '../../controllers/app_data_controller.dart';
import '../../helpers/base_getters.dart';
import '../../helpers/style_sheet.dart';
import '../expanded_btn.dart';
import '../simple_textfield.dart';

class UpdateSubscriptionDialog extends StatefulWidget {
  SubscriptionClass data;
  UpdateSubscriptionDialog({super.key, required this.data});

  @override
  State<UpdateSubscriptionDialog> createState() =>
      _UpdateSubscriptionDialogState();
}

class _UpdateSubscriptionDialogState extends State<UpdateSubscriptionDialog> {
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _adminCallbacks = AdminCallbacksController();

  @override
  void initState() {
    super.initState();
    setState(() {
      amountController.text = widget.data.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataController>(context);
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
                AppServices.addHeight(25.h),
                SimpleTextField(
                  inputType: TextInputType.number,
                  name: amountController,
                  validator: DataValidationController(),
                  label: "Enter Subscription Price",
                ),
                AppServices.addHeight(30.h),
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
                                  onPressed: () => onUpdate(db),
                                  btnText: "Update"))
                        ],
                      )
              ],
            ),
          ),
        ));
  }

  onUpdate(AppDataController value) async {
    value.setLoader(true);
    if (_key.currentState!.validate()) {
      await _adminCallbacks.updateSubscription(
          amountController.text, widget.data.id, context);
      value.setLoader(false);
    } else {
      value.setLoader(false);
      null;
    }
  }
}
