import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(Color onSurfaceColor) {
    return TextTheme(
      // headline-xl
      displayLarge: GoogleFonts.montserrat(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        height: 48 / 40,
        letterSpacing: -0.02 * 40,
        color: onSurfaceColor,
      ),
      // headline-lg
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 40 / 32,
        color: onSurfaceColor,
      ),
      // headline-md
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: onSurfaceColor,
      ),
      // body-lg
      bodyLarge: GoogleFonts.beVietnamPro(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 28 / 18,
        color: onSurfaceColor,
      ),
      // body-md
      bodyMedium: GoogleFonts.beVietnamPro(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 24 / 16,
        color: onSurfaceColor,
      ),
      // label-md
      labelMedium: GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        color: onSurfaceColor,
      ),
    );
  }

  // price-display
  static TextStyle priceStyle({required Color color}) {
    return GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      height: 1.0,
      color: color,
    );
  }
}
