import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/register_user.dart';

class RegisterController extends ChangeNotifier {
  String? countryCode;
  String? fullName;
  String? email;
  String? city;
  String? phoneNumber;
  String? zoomLink;
  String? specialization;
  String? newPassword;
  String? confirmPassword;
  bool isLoading = false;
  String? hourlyRate;

  void onLoadingChanged(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void onChangeCountryCode({String? val}) {
    debugPrint(val);
    if (val != null) {
      countryCode = val;
      notifyListeners();
    }
  }

  void setSpecialization(String? val) {
    if (val != null) {
      specialization = val;
      notifyListeners();
    }
  }

  void setCity(String? val) {
    if (val != null) {
      city = val;
      notifyListeners();
    }
  }

  void setFullName({String? value}) {
    fullName = value;
    notifyListeners();
  }

  void setEmail({String? value}) {
    email = value;
    notifyListeners();
  }

  void setPhone({String? value}) {
    debugPrint(countryCode);
    phoneNumber = countryCode ?? "+94" + value.toString();
    notifyListeners();
  }

  void setZoomLink({String? value}) {
    zoomLink = value;
    notifyListeners();
  }

  void setHourlyRate({String? value}) {
    hourlyRate = value;
    notifyListeners();
  }

  void setnewPassword({String? value}) {
    newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword({String? value}) {
    confirmPassword = value;
    notifyListeners();
  }

  RegisterUser onRegister(BuildContext context) {
    RegisterUser registerUser = RegisterUser(
      hourlyRate: hourlyRate.toString(),
      city: city.toString(),
      email: email.toString(),
      fullName: fullName.toString(),
      password: newPassword.toString(),
      phoneNumber: phoneNumber.toString(),
      specialization: specialization.toString(),
    );
    return registerUser;
  }
}
