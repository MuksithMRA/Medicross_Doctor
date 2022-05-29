import 'package:flutter/cupertino.dart';

class DoctorProfileListTile {
  IconData icon;
  String title;
  String subTitle;
  void Function()? editOption;
  DoctorProfileListTile({
    required this.icon,
    required this.title,
    required this.subTitle,
    this.editOption,
  });
}
