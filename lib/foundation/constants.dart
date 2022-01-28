import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(2, 127, 255, 1);
const onlineColor = Color.fromRGBO(49, 204, 70, 1);
const friendMessageColor = Color.fromRGBO(0, 0, 0, 0.05);
const unselectedWidgetColor = Color.fromRGBO(161, 168, 176, 1);
const Map<String, Color> chatTheme = {
  'default': Color(0xff465fff),
};

final appThemeData = ThemeData(
  primaryColor: primaryColor,
  fontFamily: 'Helvetica Neue',
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: const TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        headline2: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        subtitle1: const TextStyle(
            color: Color(0xff808080),
            fontSize: 15,
            fontWeight: FontWeight.w400),
        headline3: const TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        bodyText1: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        subtitle2: TextStyle(
          color: Colors.black.withAlpha(123),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        button: const TextStyle(color: Color(0xff027fff), fontSize: 16),
      ),
);
