import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final double radius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? suffixIconOnPressed;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool isPassword;
  final TextEditingController? controller;
  final int? maxLines;
  final void Function()? onTap;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool isUnderlineField;
  const CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.radius = 10,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.isPassword = false,
    this.controller,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.isUnderlineField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      controller: controller,
      obscureText: isPassword,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
        suffixIcon:
            IconButton(onPressed: suffixIconOnPressed, icon: Icon(suffixIcon)),
        border: isUnderlineField
            ? const UnderlineInputBorder()
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
      ),
    );
  }
}
