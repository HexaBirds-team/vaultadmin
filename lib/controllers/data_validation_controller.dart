class DataValidationController {
  /* Phone Number Validation Handler */
  validatePhone(String? value) {
    if (value == null) {
      return "Please enter phone number";
    } else if (value.length < 10) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  validateTextInput(String? value, String valuetype) {
    if (value == null || value.isEmpty) {
      return "Please enter $valuetype";
    } else {
      return null;
    }
  }
}
