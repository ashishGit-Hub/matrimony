import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstant {
  static const Color appColor = Colors.teal;
  static const Color black = Colors.black;
static const Color bgcolor=Color(0xFF3629B7);
static const Color textfieldcolor=Color(0xFF7A7A7A);
static const Color signupcolor=Color(0xFF3E58E0);
static const Color accountcolor=Color(0xFF757575);
static const Color buttoncolor=Color(0xFF00BF41);
static const Color gridColorOne = Color(0xFF89A6F0);
  static const Color gridColortwo = Color(0xFFFFC969);
  static const Color gridColorthree = Color(0xFFFC72AA);
  static const Color gridColorfour = Color(0xFF47E76F);
  static const Color notifyColor=Color(0xFFFFA451);
  static const Color nowColor=Color(0xFF3F80FD);
  static const Color barColor=Color(0xFFFFC690);
  static const Color grey=Color(0xFF6D6D6D);



}

class Palette {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF00AA88,
    <int, Color>{
      50: Color(0xFF00AA88), //10%
      100: Color(0xFF00AA88), //20%
      200: Color(0xFF00AA88), //30%
      300: Color(0xFF00AA88), //40%
      400: Color(0xFF00AA88), //50%
      500: Color(0xFF00AA88), //60%
      600: Color(0xFF00AA88), //70%
      700: Color(0xFF00AA88), //80%
      800: Color(0xFF00AA88), //90%
      900: Color(0xFF00AA88), //100%
    },
  );

  static const LinearGradient gradientYellow = LinearGradient(
    colors: [Color(0xFFFFDB4C), Color(0xFFFFD127), Color(0xFFFFC700)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.5, 1],
  );
}
