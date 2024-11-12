import 'package:flutter/material.dart';

class CommonTheme {
  static const deepPurpleColor = Color(0xff16102a);
  static const medPurpleColor = Color(0xff32294D);
  static const purpleColor = Color(0xff623dd4);
  static const lightPurpleColor = Color(0xffB56CFF);
  static const lightMidPurpleColor = Color(0xff6D59AB);
  static const blackColor = Color(0xff000000);
  static const whiteColor = Color(0xffFFFFFF);
  static const redColor = Color.fromARGB(255, 254, 103, 89);
  static const buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color> [
      Color(0xff623dd4),
      Color(0xffb56cff)
    ]
  );

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: deepPurpleColor,
    primarySwatch: Colors.deepPurple,
    useMaterial3: true,
    textTheme: const TextTheme(
      // White Text
      displayLarge: TextStyle(
        color: whiteColor,
        fontSize: 33,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.bold
      ),
      displayMedium: TextStyle(
        color: whiteColor,
        fontSize: 20,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.bold
      ),
      displaySmall: TextStyle(
        color: whiteColor,
        fontSize: 19,
        fontFamily: 'Open Sans'
      ),
      bodySmall: TextStyle(
        color: redColor,
        fontSize: 21,
        fontFamily: 'Open Sans'
      )
    )
  );

  static TextStyle getSmallTextStyle(BuildContext context) {
    return TextStyle(
      color: whiteColor,
      fontFamily: "Open Sans",
      fontSize: MediaQuery.of(context).size.width * 0.04
    );
  }

  static TextStyle getMediumTextStyle(BuildContext context) {
    return TextStyle(
      color: whiteColor,
      fontFamily: "Open Sans",
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.width * 0.055
    );
  }

  static TextStyle getLargeTextStyle(BuildContext context) {
    return TextStyle(
      color: whiteColor,
      fontFamily: "Open Sans",
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.width * 0.085
    );
  }

  static TextStyle getErrorTextStyle(BuildContext context) {
    return TextStyle(
      color: redColor,
      fontFamily: "Open Sans",
      fontSize: MediaQuery.of(context).size.width * 0.043
    );
  }
}