import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/database/database.dart';
import '../core/theme/design_tokens.dart';
import '../core/widgets/glass_container.dart';

/// Sidebar con efecto glassmorphism y navegación principal
class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _nombreEmpresa = 'MeLA Node';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final config = await db.obtenerConfiguracionEmpresa();
    if (config != null && config.nombreEmpresa.isNotEmpty) {
      if (mounted) {
        setState(() {
          _nombreEmpresa = config.nombreEmpresa;
        });
      }
    }

    // Escuchar cambios
    db.watchConfiguracionEmpresa().listen((config) {
      if (mounted) {
        setState(() {
          _nombreEmpresa = (config != null && config.nombreEmpresa.isNotEmpty)
              ? config.nombreEmpresa
              : 'MeLA Node';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      width: 280,
      padding: const EdgeInsets.symmetric(
        vertical: DesignTokens.space24,
        horizontal: DesignTokens.space16,
      ),
      borderRadius: 0,
      blur: 30,
      opacity: isDark ? 0.2 : 0.8,
      child: Column(
        children: [
          // Logo y nombre de la empresa
          _buildHeader(context, isDark),

          const SizedBox(height: DesignTokens.space32),

          // Items de navegación (Parte Superior)
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Inicio',
                  index: 0,
                  isSelected: widget.selectedIndex == 0,
                  context: context,
                ),
                _buildNavItem(
                  icon: Icons.task_alt_rounded,
                  label: 'Tareas',
                  index: 1,
                  isSelected: widget.selectedIndex == 1,
                  context: context,
                ),
                _buildNavItem(
                  icon: Icons.people_rounded,
                  label: 'Clientes',
                  index: 2,
                  isSelected: widget.selectedIndex == 2,
                  context: context,
                ),
                _buildNavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Calendario',
                  index: 3,
                  isSelected: widget.selectedIndex == 3,
                  context: context,
                ),
              ],
            ),
          ),

          // Separador y Sección Inferior
          const Divider(height: DesignTokens.space32),

          // Items Inferiores (Servicios, Reportes, Empresa)
          Column(
            children: [
              _buildNavItem(
                icon: Icons.shopping_basket_rounded,
                label: 'Servicios',
                index: 4,
                isSelected: widget.selectedIndex == 4,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.picture_as_pdf_rounded,
                label: 'Reportes',
                index: 5,
                isSelected: widget.selectedIndex == 5,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.business_rounded,
                label: 'Empresa',
                index: 6,
                isSelected: widget.selectedIndex == 6,
                context: context,
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space16),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.2, duration: 200.ms);
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: DesignTokens.cyanNeon.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: DesignTokens.space12),
        // Nombre de la empresa dinámico
        Text(
          _nombreEmpresa,
          style: TextStyle(
            fontSize: DesignTokens.fontSize20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF111827),
            shadows: [
              Shadow(
                color: DesignTokens.cyanNeon.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: DesignTokens.space4),
        Text(
          'PORTEX System',
          style: TextStyle(
            fontSize: DesignTokens.fontSize12,
            color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calcular colores y estilos antes de construir el widget
    final Color baseTextColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color baseIconColor = isDark
        ? DesignTokens.meteorGray
        : const Color(0xFF6B7280);

    final Color selectedColor = isDark
        ? DesignTokens.cyanNeon
        : const Color(0xFF0077C2);

    final Color itemColor = isSelected ? selectedColor : baseTextColor;
    final Color iconColor = isSelected ? selectedColor : baseIconColor;
    final FontWeight fontWeight = isSelected
        ? FontWeight.w600
        : FontWeight.normal;

    final Color backgroundColor = isSelected
        ? (isDark
              ? DesignTokens.cyanNeon.withValues(alpha: 0.2)
              : const Color(0xFF0077C2).withValues(alpha: 0.1))
        : Colors.transparent;

    final Border? border = isSelected
        ? Border.all(
            color: isDark
                ? DesignTokens.cyanNeon.withValues(alpha: 0.5)
                : const Color(0xFF0077C2).withValues(alpha: 0.3),
            width: 1,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemSelected(index),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space16,
              vertical: DesignTokens.space12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              color: backgroundColor,
              border: border,
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: DesignTokens.space12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize14,
                    fontWeight: fontWeight,
                    color: itemColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
