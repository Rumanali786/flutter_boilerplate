import 'dart:math';

import 'package:flutter/material.dart';

import '../utils_export.dart';

class ScaleSize {
  /// Calculates a custom `TextScaler` for responsive text scaling.
  static TextScaler textScaler(BuildContext context, {double maxScale = 2}) {
    final width = MediaQuery.of(context).size.width;

    // Calculate scaling factor based on screen width.
    double scaleFactor = (width / 1400) * maxScale;

    // Ensure scaling factor is within [1, maxScale].
    scaleFactor = max(1, min(scaleFactor, maxScale));

    return TextScaler.linear(scaleFactor); // Return a `TextScaler` instance.
  }
}

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: false,
    primaryColor: AppColors.primaryColor,
    primarySwatch: const MaterialColor(0xff0F5936, <int, Color>{
      900: Color(0xFF674010),
      800: Color(0xff784a13),
      700: Color(0xFF8a5516),
      600: Color(0xFF9b5f18),
      500: Color(0xFF9b5f18),
      400: Color(0xFFac6a1b),
      300: Color(0xFFb47932),
      200: Color(0xFFbd8849),
      100: Color(0xFFc5975f),
      50: Color(0xFFcda676),
    }),
    scaffoldBackgroundColor: Colors.white,
    textTheme: customTextTheme,
  );
}


const TextTheme customTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 96,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  displayMedium: TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  displaySmall: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontFamily: FontFamily.arabicFont,
    color: Colors.black,
  ),
  headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: FontFamily.arabicFont,
    color: Colors.black,
  ),
  titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
  labelSmall: TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.black),
);



ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    primarySwatch: const MaterialColor(0xff0F5936, <int, Color>{
      900: Color(0xFFcda676),
      800: Color(0xFFc5975f),
      700: Color(0xFFbd8849),
      600: Color(0xFFb47932),
      500: Color(0xFFac6a1b),
      400: Color(0xFF9b5f18),
      300: Color(0xFF8a5516),
      200: Color(0xff784a13),
      100: Color(0xFF674010),
      50: Color(0xff0F5936),
    }),
    scaffoldBackgroundColor: const Color(0xFF121212),
    // Or any dark tone
    textTheme: customDarkTextTheme,
  );
}

const TextTheme customDarkTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 96,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  displayMedium: TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  displaySmall: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontFamily: FontFamily.arabicFont,
    color: Colors.white,
  ),
  headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: FontFamily.arabicFont,
    color: Colors.white,
  ),
  titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
  labelSmall: TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamily: FontFamily.arabicFont,
      color: Colors.white),
);


final gradientDecoration = BoxDecoration(
  color: AppColors.primaryColor,
  gradient: LinearGradient(
    colors: [
      Color(0xffAC6A1B),
      Color(0xffF5EBAD),
      Color(0xffAC6A1B),
      Color(0xffF5EBAD),
      Color(0xffAC6A1B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
