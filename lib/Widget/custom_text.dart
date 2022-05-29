import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final TextAlign? textAlign;
  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.onTap, 
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style:
            TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: textAlign,
      ),
    );
  }
}
