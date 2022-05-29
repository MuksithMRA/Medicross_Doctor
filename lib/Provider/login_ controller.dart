// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  void onLoadingChanged(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void setLoginState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        notifyListeners();
      } else {
        isLoggedIn = true;
        notifyListeners();
      }
    });
  }
}
