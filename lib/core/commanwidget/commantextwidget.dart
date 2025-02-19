import 'package:flutter/material.dart';

class CommonTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final double? wordSpacing;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final TextStyle? customStyle;
  final String? fontFamily; // Added fontFamily parameter

  const CommonTextWidget({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.wordSpacing,
    this.fontStyle,
    this.decoration,
    this.customStyle,
    this.fontFamily, // Added fontFamily parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: customStyle ??
          TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            fontStyle: fontStyle,
            decoration: decoration,
            fontFamily: fontFamily, // Apply fontFamily here
          ),
    );
  }
}
