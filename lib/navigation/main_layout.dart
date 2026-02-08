import 'package:flutter/material.dart';
import '../core/theme/design_tokens.dart';
import 'sidebar.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/clients/presentation/clients_screen.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/services/presentation/services_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

/// Layout principal con Sidebar y área de contenido
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              backgroundColor: isDark
                  ? DesignTokens.cosmicSurface.withValues(alpha: 0.95)
                  : const Color(0xFFF8F9FA),
              elevation: 0,
              title: Text(
                'PORTEX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: isDark
                  ? DesignTokens.cosmicSurface.withValues(alpha: 0.95)
                  : const Color(0xFFF8F9FA),
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.of(context).pop(); // Close drawer after selection
                },
              ),
            )
          : null,
      body: Container(
        // Fondo con gradiente espacial
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    DesignTokens.deepSpace,
                    DesignTokens.darkNebula,
                    DesignTokens.cosmicSurface.withValues(alpha: 0.5),
                  ]
                : [Color(0xFFF0F2F8), Color(0xFFE8ECFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          children: [
            // Desktop: Show sidebar
            if (!isMobile)
              Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),

            // Área de contenido principal
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
                child: _buildScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(
          onNavigate: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      case 1:
        return const TasksScreen();
      case 2:
        return const ClientsScreen();
      case 3:
        return const CalendarScreen();
      case 4:
        return const ServicesScreen();
      case 5:
        return const ReportsScreen();
      case 6:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }
}
