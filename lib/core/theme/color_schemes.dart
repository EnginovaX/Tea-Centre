import 'package:flutter/material.dart';

class AppColorSchemes {
  static const Color primary = Color(0xFF8F4E00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFF9933);
  static const Color onPrimaryContainer = Color(0xFF693800);
  static const Color secondary = Color(0xFF934B19);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFA26A);
  static const Color onSecondaryContainer = Color(0xFF783603);
  static const Color tertiary = Color(0xFF60603E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFB5B48B);
  static const Color onTertiaryContainer = Color(0xFF464626);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color surface = Color(0xFFFFF8F5);
  static const Color onSurface = Color(0xFF1E1B18);
  static const Color surfaceContainerHighest = Color(0xFFE9E1DC);
  static const Color onSurfaceVariant = Color(0xFF554336);
  static const Color outline = Color(0xFF887364);
  static const Color outlineVariant = Color(0xFFDBC2B0);
  static const Color shadow = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF34302C);
  static const Color onInverseSurface = Color(0xFFF8EFEA);
  static const Color inversePrimary = Color(0xFFFFB77A);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: inversePrimary,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: inversePrimary,
    onPrimary: onPrimaryContainer,
    primaryContainer: primary,
    onPrimaryContainer: inversePrimary,
    secondary: secondaryContainer,
    onSecondary: onSecondaryContainer,
    secondaryContainer: secondary,
    onSecondaryContainer: secondaryContainer,
    tertiary: tertiaryContainer,
    onTertiary: onTertiaryContainer,
    tertiaryContainer: tertiary,
    onTertiaryContainer: tertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: inverseSurface,
    onSurface: onInverseSurface,
    onSurfaceVariant: outlineVariant,
    outline: outlineVariant,
    outlineVariant: outline,
    shadow: shadow,
    inverseSurface: surface,
    onInverseSurface: onSurface,
    inversePrimary: primary,
  );
}
