import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E335A);
  static const Color secondaryColor = Color(0xFF1C1B33);
  static const Color accentColor = Color(0xFF48319D);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5936B4), Color(0xFF362A84)],
  );

  // Text Styles
  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get bodyMedium =>
      GoogleFonts.poppins(fontSize: 15, color: Colors.white70);

  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 96,
    fontWeight: FontWeight.w200,
    color: Colors.white,
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: secondaryColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: secondaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: displayLarge,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyMedium: bodyMedium,
      ),
    );
  }
}
