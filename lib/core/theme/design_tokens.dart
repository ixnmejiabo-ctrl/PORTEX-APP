import 'package:flutter/material.dart';

/// Tokens de diseño - Colores, tipografía, espaciados
/// Estética: Espacial/Galáctica con Material 3
class DesignTokens {
  // ============ COLORES ESPACIALES ============

  // Fondos oscuros
  static const Color deepSpace = Color(
    0xFF0A0E27,
  ); // Azul muy oscuro casi negro
  static const Color darkNebula = Color(0xFF0D1225); // Fondo oscuro
  static const Color cosmicSurface = Color(0xFF1A1F3A); // Superficie

  // Fondos claros
  static const Color lightNebula = Color(0xFFF0F2F8); // Fondo claro
  static const Color lightCosmic = Color(0xFFFFFFFF); // Superficie clara
  static const Color lightSpace = Color(0xFFE8ECFC); // Fondo alternativo claro

  // Acentos Neón
  static const Color cyanNeon = Color(0xFF00F0FF); // Cyan brillante
  static const Color magentaNeon = Color(0xFFFF00FF); // Magenta
  static const Color greenNeon = Color(0xFF39FF14); // Verde neón
  static const Color purpleNeon = Color(0xFF9D4EDD); // Púrpura
  static const Color blueNeon = Color(0xFF4CC9F0); // Azul neón

  // Grises espaciales
  static const Color meteorGray = Color(0xFF8B8D9F);
  static const Color asteroidGray = Color(0xFF5A5D72);
  static const Color darkGray = Color(0xFF2A2E45);

  // ============ COLORES SEMÁFORO (para urgencias) ============
  static const Color urgentRed = Color(0xFFFF3B3B); // 0-2 días
  static const Color warningYellow = Color(0xFFFFD93D); // 3-5 días
  static const Color safeGreen = Color(0xFF6BCF7F); // 6+ días

  // ============ TIPOS DE ACTIVIDAD (colores distintivos) ============
  static const Color typeVideo = Color(0xFFFF6B9D); // Rosa
  static const Color typeImage = Color(0xFF00D9FF); // Cyan
  static const Color typeCampaign = Color(0xFFFFB800); // Naranja/Dorado
  static const Color typePost = Color(0xFF9D4EDD); // Púrpura
  static const Color typeStory = Color(0xFF06FFA5); // Verde agua

  // ============ ESTADOS DE ACTIVIDAD ============
  static const Color statePending = Color(0xFFFFD93D); // Amarillo
  static const Color stateInProgress = Color(0xFF4CC9F0); // Azul
  static const Color stateReady = Color(0xFF06FFA5); // Verde agua
  static const Color stateDelivered = Color(0xFF6BCF7F); // Verde
  static const Color statePublished = Color(0xFF9D4EDD); // Púrpura
  static const Color stateDelayed = Color(0xFFFF3B3B); // Rojo

  // ============ TIPOGRAFÍA ============
  static const String fontFamily =
      'Roboto'; // Google Fonts se configurará en app_theme

  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize32 = 32.0;
  static const double fontSize48 = 48.0;

  // ============ ESPACIADOS ============
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // ============ BORDES Y RADIOS ============
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 999.0;

  // ============ GLASSMORPHISM ============
  static const double glassOpacity = 0.15;
  static const double glassBlur = 20.0;
  static const double glassBorderOpacity = 0.3;

  // ============ ELEVACIONES/SOMBRAS ============
  static BoxShadow glowShadowCyan = BoxShadow(
    color: cyanNeon.withValues(alpha: 0.3),
    blurRadius: 20,
    spreadRadius: 2,
  );

  static BoxShadow glowShadowMagenta = BoxShadow(
    color: magentaNeon.withValues(alpha: 0.3),
    blurRadius: 20,
    spreadRadius: 2,
  );

  static BoxShadow glowShadowPurple = BoxShadow(
    color: purpleNeon.withValues(alpha: 0.3),
    blurRadius: 20,
    spreadRadius: 2,
  );
}
