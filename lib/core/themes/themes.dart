import 'package:dreemz/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppThemes {
  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.questrial().fontFamily,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      primary: AppColors.colorPrimary,
      surface: Colors.white,
      seedColor: AppColors.colorPrimary,
      onPrimaryContainer: Colors.black,
      primaryContainer: AppColors.colorPrimary,
    ),
    appBarTheme: AppBarTheme(backgroundColor: AppColors.colorPrimary),
    primaryIconTheme: const IconThemeData(weight: 10, color: Colors.black),
    pageTransitionsTheme: _pageTransitionsTheme,
    buttonTheme: ButtonThemeData(height: 48, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
  );
}
