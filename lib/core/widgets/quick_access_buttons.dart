import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/glass_container.dart';
import '../../features/tasks/presentation/widgets/task_form_modal.dart';
import '../../features/clients/presentation/widgets/client_form_modal.dart';

/// Widget de botones de acceso rápido para el Dashboard
class QuickAccessButtons extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTaskCreated;
  final VoidCallback onClientCreated;
  final Function(int)? onNavigate;

  const QuickAccessButtons({
    super.key,
    required this.isDark,
    required this.onTaskCreated,
    required this.onClientCreated,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: Icons.add_task_rounded,
            label: 'Nueva Tarea',
            color: DesignTokens.cyanNeon,
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => TaskFormModal(),
              );
              if (result == true) {
                onTaskCreated();
              }
            },
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: Icons.person_add_rounded,
            label: 'Nuevo Cliente',
            color: DesignTokens.purpleNeon,
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => ClientFormModal(),
              );
              if (result == true) {
                onClientCreated();
              }
            },
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildQuickActionButton(
            context,
            icon: Icons.assessment_rounded,
            label: 'Ver Reportes',
            color: DesignTokens.warningYellow,
            onTap: () {
              if (onNavigate != null) {
                onNavigate!(5);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navegación no disponible'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(DesignTokens.space20),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: DesignTokens.space12),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSize14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}
