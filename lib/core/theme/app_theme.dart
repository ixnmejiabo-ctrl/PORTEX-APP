import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppTheme {
  // ============ TEMA OSCURO (Espacial/Galáctico) ============
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Esquema de color
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: DesignTokens.cyanNeon,
      onPrimary: Colors.black,
      primaryContainer: DesignTokens.darkNebula,
      onPrimaryContainer: DesignTokens.cyanNeon,

      secondary: DesignTokens.magentaNeon,
      onSecondary: Colors.black,
      secondaryContainer: DesignTokens.darkGray,
      onSecondaryContainer: DesignTokens.magentaNeon,

      tertiary: DesignTokens.purpleNeon,
      onTertiary: Colors.black,
      tertiaryContainer: DesignTokens.darkGray,
      onTertiaryContainer: DesignTokens.purpleNeon,

      error: DesignTokens.urgentRed,
      onError: Colors.white,
      errorContainer: DesignTokens.urgentRed.withValues(alpha: 0.2),
      onErrorContainer: DesignTokens.urgentRed,

      surface: DesignTokens.deepSpace,
      onSurface: Colors.white,
      surfaceContainerHighest: DesignTokens.cosmicSurface,
      onSurfaceVariant: DesignTokens.meteorGray,

      outline: DesignTokens.asteroidGray,
      outlineVariant: DesignTokens.darkGray,

      shadow: Colors.black.withValues(alpha: 0.5),
      scrim: Colors.black.withValues(alpha: 0.8),

      inverseSurface: Colors.white,
      onInverseSurface: DesignTokens.deepSpace,
      inversePrimary: DesignTokens.blueNeon,
    ),

    // Tipografía con Google Fonts
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: TextStyle(
          fontSize: DesignTokens.fontSize48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: DesignTokens.fontSize32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: DesignTokens.fontSize24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: DesignTokens.fontSize20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: DesignTokens.fontSize18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: DesignTokens.fontSize16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: DesignTokens.fontSize14,
          color: DesignTokens.meteorGray,
        ),
        bodySmall: TextStyle(
          fontSize: DesignTokens.fontSize12,
          color: DesignTokens.meteorGray,
        ),
        labelLarge: TextStyle(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: DesignTokens.fontSize20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      color: DesignTokens.cosmicSurface.withValues(alpha: 0.5),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.cyanNeon,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space24,
          vertical: DesignTokens.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.cyanNeon,
        side: BorderSide(color: DesignTokens.cyanNeon, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space24,
          vertical: DesignTokens.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.cyanNeon,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space16,
          vertical: DesignTokens.space12,
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.darkGray.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: DesignTokens.asteroidGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: DesignTokens.asteroidGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: DesignTokens.cyanNeon, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: DesignTokens.urgentRed),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space16,
        vertical: DesignTokens.space16,
      ),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: DesignTokens.darkGray,
      thickness: 1,
      space: DesignTokens.space16,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: DesignTokens.darkGray.withValues(alpha: 0.5),
      selectedColor: DesignTokens.cyanNeon.withValues(alpha: 0.3),
      labelStyle: GoogleFonts.inter(
        fontSize: DesignTokens.fontSize12,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space12,
        vertical: DesignTokens.space8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
    ),
  );

  // ============ TEMA CLARO ============
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Esquema de color
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xFF0077C2), // Azul más oscuro para contraste
      onPrimary: Colors.white,
      primaryContainer: DesignTokens.lightSpace,
      onPrimaryContainer: Color(0xFF001E3C),

      secondary: Color(0xFFD946A1), // Magenta más suave
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFCE7F3),
      onSecondaryContainer: Color(0xFF831843),

      tertiary: Color(0xFF7C3AED), // Púrpura
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFEDE9FE),
      onTertiaryContainer: Color(0xFF4C1D95),

      error: Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),

      surface: DesignTokens.lightCosmic,
      onSurface: Color(0xFF1F2937),
      surfaceContainerHighest: DesignTokens.lightNebula,
      onSurfaceVariant: Color(0xFF6B7280),

      outline: Color(0xFFD1D5DB),
      outlineVariant: Color(0xFFE5E7EB),

      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: Colors.black.withValues(alpha: 0.5),

      inverseSurface: Color(0xFF1F2937),
      onInverseSurface: Colors.white,
      inversePrimary: DesignTokens.cyanNeon,
    ),

    // Tipografía
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme.copyWith(
        displayLarge: TextStyle(
          fontSize: DesignTokens.fontSize48,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: DesignTokens.fontSize32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: DesignTokens.fontSize24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        ),
        headlineMedium: TextStyle(
          fontSize: DesignTokens.fontSize20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        headlineSmall: TextStyle(
          fontSize: DesignTokens.fontSize18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        bodyLarge: TextStyle(
          fontSize: DesignTokens.fontSize16,
          color: Color(0xFF374151),
        ),
        bodyMedium: TextStyle(
          fontSize: DesignTokens.fontSize14,
          color: Color(0xFF6B7280),
        ),
        bodySmall: TextStyle(
          fontSize: DesignTokens.fontSize12,
          color: Color(0xFF9CA3AF),
        ),
        labelLarge: TextStyle(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
    ),

    // Similar configuration for light theme components...
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: Color(0xFF111827),
      titleTextStyle: GoogleFonts.inter(
        fontSize: DesignTokens.fontSize20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      color: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0077C2),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space24,
          vertical: DesignTokens.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.lightNebula,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: Color(0xFF0077C2), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space16,
        vertical: DesignTokens.space16,
      ),
    ),
  );
}
