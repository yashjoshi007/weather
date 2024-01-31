import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData MyTheme() {
  return ThemeData(
    // Colors
    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xFF745E27),                                   // Primary
      onPrimary: Colors.white,                                      // Text/Icon on primary
      primaryContainer: Color(0xFFF4ECDD),                          // Surface primary

      secondary: Color(0xFF0D1426),                          // Text Subdued
      onSecondary: Colors.white,                                    // Text/Icon on secondary

      error: Color(0xFFEF4949),                                     // Critical
      onError: Colors.white,                                        // Text/Icon on critical
      errorContainer: Color(0xFFF7D4D6),                            // Surface critical

      surface: Colors.white,                                        // Surface
      onSurface: Colors.black,                                      // Not needed

      background: Color(0xFFF4F4F4),                                // Background
      onBackground: Colors.black,                                   // Not needed
    ),

    primaryColor: Color(0xFF745E27),
    hintColor: Colors.black,
    errorColor: Color(0xFFEF4949),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Color(0xFFF0EFE8),
    primaryIconTheme: IconThemeData(color: Color(0xFF515B7B),),    // Subdued Icons
    disabledColor: Color(0xFF8E909A),                               // Disabled Text/Icons
    dividerColor: Color(0xFFE1E3E5),                                // Dividers


    // Typography
    fontFamily: 'Plus Jakarta Sans',
    textTheme: const TextTheme(

      headline2: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0D1426),
        letterSpacing: -0.25,
        height: 1.2,
      ),

      headline3: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0D1426),
        letterSpacing: -0.1,
        height: 1.33,
      ),

      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600, // Semi-Bold
        color: Color(0xFF0D1426),
        letterSpacing: -0.1,
        height: 1.4,
      ),

      subtitle1: TextStyle(                                           // Body Large
        fontSize: 18,
        fontWeight: FontWeight.w600, //Semi-bold
        color: Color(0xFF0D1426),
        height: 1.33,
      ),

      bodyText1: TextStyle(                                           // Body Base
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        color: Color(0xFF0D1426),
        height: 1.5,
      ),

      bodyText2: TextStyle(                                           // Body Small
        fontSize: 14,
        fontWeight: FontWeight.w400, // Regular
        color: Color(0xFF4A4E5D),
        height: 1.4,
      ),

      caption: TextStyle(
        fontSize: 10,
        height: 1.2,
        fontWeight: FontWeight.w600, // Medium
        color: Color(0xFF4A4E5D),
      ),
    ),
  );
}