import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/data_validation_controller.dart';
import '../helpers/style_sheet.dart';

class PhoneNumberTextInput extends StatelessWidget {
  const PhoneNumberTextInput({
    Key? key,
    required TextEditingController phone,
    required DataValidationController validator,
  })  : _phone = phone,
        _validator = validator,
        super(key: key);

  final TextEditingController _phone;
  final DataValidationController _validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phone,
      maxLength: 10,
      validator: (value) => _validator.validatePhone(value),
      decoration: InputDecoration(
          prefixText: "+91  ",
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.sp, vertical: 17.sp),
          label: Text("Enter Phone Number", style: GetTextTheme.sf16_regular),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(50.r))),
    );
  }
}
