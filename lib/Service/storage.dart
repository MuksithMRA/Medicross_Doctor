import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('user/doctors/${_auth.currentUser?.uid}').putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getFile() async {
    firebase_storage.Reference result =
        storage.ref('user/doctors/').child(_auth.currentUser?.uid ?? '');

    String url = await result.getDownloadURL().then((value) {
    
      return value.toString();
    }).catchError((error, stackrace) {
      debugPrint("error : $stackrace");
    });
    return url;
  }

  
}
