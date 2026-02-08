import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/design_tokens.dart';
import 'glass_container.dart';

class CreatorInfoDialog extends StatelessWidget {
  const CreatorInfoDialog({super.key});

  Future<void> _launchWhatsApp() async {
    // Replace with actual number if provided, currently using a placeholder or generic link
    // Updated with user provided number
    final Uri url = Uri.parse('https://wa.me/59169457392');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: GlassContainer(
          width: 350,
          padding: const EdgeInsets.all(DesignTokens.space32),
          borderRadius: DesignTokens.radiusLarge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.cyanNeon.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // Using app logo as requested
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space24),

              // Nombre y Startup
              Text(
                'Ian Mejía',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: DesignTokens.space4),
              Text(
                'MeLA Node',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize16,
                  color: DesignTokens.cyanNeon,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: DesignTokens.space16),

              // Rol y Descripción
              Text(
                'Lead Developer, creador de PORTEX',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: DesignTokens.fontSize14,
                  color: isDark
                      ? DesignTokens.meteorGray
                      : const Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: DesignTokens.space24),

              // Mensaje
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.space16,
                  vertical: DesignTokens.space12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  '"El control es la libertad!"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize14,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ),

              const SizedBox(height: DesignTokens.space32),

              // Versión
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize12,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.3),
                ),
              ),

              const SizedBox(height: DesignTokens.space16),

              // Botón de Contacto
              _buildContactButton(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton(bool isDark) {
    return InkWell(
      onTap: _launchWhatsApp,
      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space24,
          vertical: DesignTokens.space12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF25D366), // WhatsApp Green
              const Color(0xFF128C7E),
            ],
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.messenger_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Contactar por WhatsApp',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: DesignTokens.fontSize14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
