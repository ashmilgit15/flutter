import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme with calming, pastel colors
class AppTheme {
  // Color palette - soft and soothing
  static const Color primaryGreen = Color(0xFF8FBC8F);
  static const Color lightGreen = Color(0xFFB4D7B4);
  static const Color paleGreen = Color(0xFFE8F5E8);
  
  static const Color beige = Color(0xFFF5F5DC);
  static const Color lightBeige = Color(0xFFFAF8F3);
  static const Color darkBeige = Color(0xFFD4C5B0);
  
  static const Color accentPink = Color(0xFFFFB6C1);
  static const Color accentLavender = Color(0xFFE6E6FA);
  static const Color accentSky = Color(0xFFB0E0E6);
  
  static const Color textDark = Color(0xFF4A4A4A);
  static const Color textLight = Color(0xFF8A8A8A);
  
  static const Color successGreen = Color(0xFF90EE90);
  static const Color warningYellow = Color(0xFFFFE4B5);
  static const Color errorRed = Color(0xFFFFB6B9);

  /// Get theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: accentPink,
        surface: lightBeige,
        error: errorRed,
      ),
      scaffoldBackgroundColor: lightBeige,
      
      // Typography
      textTheme: GoogleFonts.comfortaaTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: GoogleFonts.comfortaa(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: lightGreen, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: textLight),
      ),
      
      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textLight,
        selectedLabelStyle: GoogleFonts.comfortaa(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.comfortaa(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Gradient backgrounds for different themes
  static LinearGradient get springGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [paleGreen, lightBeige],
      );

  static LinearGradient get summerGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accentSky, paleGreen],
      );

  static LinearGradient get autumnGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [warningYellow, lightBeige],
      );

  static LinearGradient get winterGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accentLavender, lightBeige],
      );

  /// Get gradient by theme name
  static LinearGradient getGradient(String theme) {
    switch (theme) {
      case 'summer':
        return summerGradient;
      case 'autumn':
        return autumnGradient;
      case 'winter':
        return winterGradient;
      default:
        return springGradient;
    }
  }
}
