import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal, // New Teal primary color
    scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light gray background
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal, // Teal for AppBar
      foregroundColor: Colors.white, // White text on the app bar
      titleTextStyle: GoogleFonts.lato(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.openSans(
          color: Colors.black87,
          fontSize: 18), // Dark gray text for readability
      bodyMedium: GoogleFonts.openSans(
          color: Colors.black87, fontSize: 16), // Slightly smaller text
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.tealAccent, // Lighter teal for FAB
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFFF6F61), // Coral accent for buttons
    ),
    // Added custom color for SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.teal.shade700, // Teal background for SnackBar
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal, // Keep Teal as primary color
    scaffoldBackgroundColor:
        Color(0xFF2D2D2D), // Dark gray background for dark theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal.shade700, // Darker teal for the AppBar
      foregroundColor: Colors.white, // White text for AppBar
      titleTextStyle: GoogleFonts.lato(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.openSans(
          color: Colors.white, fontSize: 18), // White text on dark background
      bodyMedium: GoogleFonts.openSans(color: Colors.white, fontSize: 16),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.tealAccent, // Lighter teal FAB for dark theme
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFFF6F61), // Coral accent for buttons
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor:
          Colors.teal.shade700, // Dark teal background for SnackBar
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
