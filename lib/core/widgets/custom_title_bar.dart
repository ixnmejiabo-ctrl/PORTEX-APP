import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E), // Fondo oscuro estilo Mac
      child: WindowTitleBarBox(
        child: Row(
          children: [
            const SizedBox(width: 8),
            // Botones estilo Mac
            Row(
              children: [
                _WindowButton(
                  color: const Color(0xFFFF5F56),
                  onTap: () => appWindow.close(),
                  icon: Icons.close,
                  iconSize: 10,
                ),
                const SizedBox(width: 8),
                _WindowButton(
                  color: const Color(0xFFFFBD2E),
                  onTap: () => appWindow.minimize(),
                  icon: Icons.minimize,
                  iconSize: 10,
                ),
                const SizedBox(width: 8),
                _WindowButton(
                  color: const Color(0xFF27C93F),
                  onTap: () => appWindow.maximizeOrRestore(),
                  icon: Icons.crop_square,
                  iconSize: 10,
                ),
              ],
            ),
            // Área para arrastrar la ventana
            Expanded(child: MoveWindow()),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;

  const _WindowButton({
    required this.color,
    required this.onTap,
    required this.icon,
    required this.iconSize,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
          child: _isHovered
              ? Center(
                  child: Icon(
                    widget.icon,
                    size: 8,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
