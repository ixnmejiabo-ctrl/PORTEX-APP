import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/database/database.dart';
import 'navigation/main_layout.dart';
import 'core/widgets/custom_title_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración de ventana solo en desktop
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double width = prefs.getDouble('window_width') ?? 1280;
    double height = prefs.getDouble('window_height') ?? 720;

    runApp(
      MultiProvider(
        providers: [Provider<AppDatabase>(create: (_) => AppDatabase())],
        child: const PortexApp(),
      ),
    );

    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = const Size(800, 600);
      win.size = Size(width, height);
      win.alignment = Alignment.center;
      win.title = "PORTEX";
      win.show();
    });
  } else {
    // Mobile/Web: no window configuration
    runApp(
      MultiProvider(
        providers: [Provider<AppDatabase>(create: (_) => AppDatabase())],
        child: const PortexApp(),
      ),
    );
  }
}

class PortexApp extends StatelessWidget {
  const PortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return MaterialApp(
      title: 'PORTEX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: isDesktop
          ? WindowBorder(
              color: const Color(0xFF2B2B2B),
              width: 1,
              child: Column(
                children: [
                  const CustomTitleBar(),
                  const Expanded(child: MainLayout()),
                ],
              ),
            )
          : const MainLayout(), // Mobile: no custom title bar
    );
  }
}
