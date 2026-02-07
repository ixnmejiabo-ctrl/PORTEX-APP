import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Widget reutilizable para efecto Glassmorphism
/// Usado en todo el sistema para mantener consistencia visual
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final double opacity;
  final double blur;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = DesignTokens.radiusMedium,
    this.backgroundColor,
    this.opacity = DesignTokens.glassOpacity,
    this.blur = DesignTokens.glassBlur,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = isDark ? DesignTokens.cosmicSurface : Colors.white;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ??
            Border.all(
              color: Colors.white.withValues(
                alpha: DesignTokens.glassBorderOpacity,
              ),
              width: 1,
            ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (backgroundColor ?? defaultBgColor).withValues(
                alpha: opacity,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Variante de GlassContainer para cards de datos (KPIs, stats, etc)
class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool showGlow;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(DesignTokens.space16),
        borderRadius: DesignTokens.radiusLarge,
        border: accentColor != null
            ? Border.all(color: accentColor!, width: 1.5)
            : null,
        boxShadow: showGlow && accentColor != null
            ? [
                BoxShadow(
                  color: accentColor!.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
        child: child,
      ),
    );
  }
}

/// Contenedor con gradiente espacial para headers y secciones destacadas
class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const GradientContainer({
    super.key,
    required this.child,
    this.gradientColors,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColors = isDark
        ? [
            DesignTokens.darkNebula,
            DesignTokens.deepSpace,
            DesignTokens.cosmicSurface.withValues(alpha: 0.8),
          ]
        : [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF22D3EE)];

    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(DesignTokens.space24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? defaultColors,
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
