class ValidationController {
  //Email Validation
  static String? isEmailValidated(String? email) {
    if (email != null) {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        return null;
      } else {
        return "Please enter valid Email";
      }
    } else {
      return "Please enter Email";
    }
  }

  //Full Name Validation
  static String? isFullNameValid(String? name) {
    if (name == null || name.isEmpty) {
      return "Please enter full name";
    } else {
      return null;
    }
  }

  //Phone number validation
  static String? isPhoneNumberValid(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Please enter Phone number";
    } else if (phone.length < 9) {
      return "Please enter valid phone number";
    } else {
      return null;
    }
  }

  //Zoom Link Validation
  static String? isZoomLinkValid(String? zoomLink) {
    if (zoomLink == null || zoomLink.isEmpty) {
      return "Please enter zoom link";
    }
    return null;
  }

  //Hourly rate Validation
  static String? isHourlyRateValid(String? rate) {
    if (rate == null || rate.isEmpty) {
      return "Please valid hourly rate";
    }
    return null;
  }

  //New Password Validation
  static String? isNewPassValidated(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter password";
    } else if (password.length < 6) {
      return "Password should more than 6 characters";
    } else {
      return null;
    }
  }

  //Confirm Password Validation
  static String? isConfirmPassValidated(String? newPass, String? confirmPass) {
    if (confirmPass == null || confirmPass.isEmpty) {
      return "Please confirm password";
    } else if (newPass != confirmPass) {
      return "Passwords doesn't match";
    } else {
      return null;
    }
  }

  //Common null Validator
  static String? commonValidator(String? val, String message) {
    if (val == null || val.isEmpty) {
      return message;
    }
    return null;
  }
}
