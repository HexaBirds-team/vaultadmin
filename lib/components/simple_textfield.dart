import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valt_security_admin_panel/components/gradient_components/gradient_image.dart';

import '../controllers/data_validation_controller.dart';
import '../helpers/style_sheet.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField(
      {Key? key,
      required TextEditingController name,
      DataValidationController? validator,
      Function(String)? onChange,
      String hint = "",
      String label = "",
      String suffixIcon = "",
      TextInputType inputType = TextInputType.text,
      bool isObsecure = false,
      bool readOnly = false,
      double borderRadius = 50,
      int maxLines = 1})
      : _name = name,
        _validator = validator,
        _hint = hint,
        _label = label,
        _suffixIcon = suffixIcon,
        _onChange = onChange,
        _readOnly = readOnly,
        _inputType = inputType,
        _isObsecure = isObsecure,
        _maxLines = maxLines,
        _borderRadius = borderRadius,
        super(key: key);

  final TextEditingController _name;
  final DataValidationController? _validator;
  final String _hint;
  final String _label;
  final String _suffixIcon;
  final Function(String)? _onChange;
  final bool _readOnly;
  final TextInputType _inputType;
  final bool _isObsecure;
  final int _maxLines;
  final double _borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: _maxLines,
      obscureText: _isObsecure,
      keyboardType: _inputType,
      readOnly: _readOnly,
      onChanged: _onChange == null ? null : (v) => _onChange!(v),
      controller: _name,
      validator: _validator == null
          ? null
          : (value) => _validator!.validateTextInput(value, _label),
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.sp, vertical: 17.sp),
          hintText: _hint,
          label: _label.isEmpty
              ? null
              : Text(_label, style: GetTextTheme.sf16_regular),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius.r)),
          suffixIcon: _suffixIcon == ""
              ? null
              : Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: ImageGradient(
                      image: _suffixIcon,
                      gradient: AppColors.appGradientColor,
                      height: 20.sp,
                      width: 20.sp))),
    );
  }
}
