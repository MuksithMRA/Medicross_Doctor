import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Model/register_user.dart';
import '../Provider/error_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("doctors");

  Future<String?> signUpWithEmailAndPassword(RegisterUser registerUser) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: registerUser.email.trim(),
        password: registerUser.password,
      );

      if (result.user?.uid != null) {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(registerUser.fullName);

        await _collectionReference.doc(result.user?.uid).set({
          "fullName": registerUser.fullName,
          "email": registerUser.email.trim(),
          "city": registerUser.city,
          "phone": registerUser.phoneNumber,
          "uid": result.user?.uid,
          "hourly_rate": registerUser.hourlyRate,
          "specialization": registerUser.specialization,
          "reviewCount": 0,
          "ratingCount": "0",
          "availability": true,
          "type": "doctor",
          "profilePic":
              "https://firebasestorage.googleapis.com/v0/b/doctor-app-52b40.appspot.com/o/doctor.jpg?alt=media&token=38a43056-a744-4b1c-8c8a-20ca488fdd9d"
        });
      }

      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ErrorProvider.message = "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        ErrorProvider.message = "The account already exists for that email";
      }
    } on FirebaseException catch (e) {
      ErrorProvider.message = e.code;
    } catch (e) {
      ErrorProvider.message = e.toString();
    }
    return null;
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ErrorProvider.message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        ErrorProvider.message = "Wrong password provided for that user";
      } else {
        ErrorProvider.message = "Something went wrong , please try again";
      }
      return null;
    } catch (e) {
      ErrorProvider.message = "$e";
      return null;
    }
  }

  Future<String?> signOut() async {
    await _auth.signOut().then((value) {
      return value;
    }).catchError((error, stackrace) {
      debugPrint(stackrace);
      return null;
    });
    return null;
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final cred = EmailAuthProvider.credential(
          email: user?.email ?? "", password: currentPassword);
      await user?.reauthenticateWithCredential(cred);
      await user?.updatePassword(newPassword).then((value) {
        AuthService().signOut();
      });
    } on FirebaseException catch (e) {
      ErrorProvider.message = e.code;
    } catch (e) {
      ErrorProvider.message = "Something went wrong , please try again";
    }
  }
}
