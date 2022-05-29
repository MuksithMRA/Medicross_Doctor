import 'package:flutter/material.dart';

showEditDialog(BuildContext context, Widget dialog) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return dialog;
      });
}
