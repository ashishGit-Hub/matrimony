import 'package:flutter/material.dart';

import 'color_constant.dart';
import 'dimension.dart';


mixin AppTextStyle {
  static TextStyle regularInterText({
    double? height,
    Color color = ColorConstant.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px15,
    Color decorationColor = Colors.transparent,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle regularInfoInterText({
    double? height,
   Color color = ColorConstant.appColor,
    bool isUnderline = false,
    double fontSize = Dimensions.px14,
    Color decorationColor = Colors.transparent,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle mediumInterText({
    double? height,
    Color color = ColorConstant.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px19,
    Color decorationColor = Colors.transparent,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle semiBoldInterText({
    double? height,
    Color color = ColorConstant.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px15,
    Color decorationColor = Colors.transparent,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle boldInterText({
    double? height,
    Color color = ColorConstant.black,
    bool isUnderline = false,
    double fontSize = Dimensions.px15,
    Color decorationColor = Colors.transparent,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: height,
      decoration: isUnderline ? TextDecoration.underline : decoration,
      decorationColor: decorationColor,
    );
  }
}
