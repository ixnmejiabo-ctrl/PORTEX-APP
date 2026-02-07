import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/database/database.dart';
import 'navigation/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Configuración de ventana
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double width = prefs.getDouble('window_width') ?? 1280;
  double height = prefs.getDouble('window_height') ?? 720;

  WindowOptions windowOptions = WindowOptions(
    size: Size(width, height),
    center: prefs.getBool('window_centered') ?? true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'PORTEX',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => database),
        // ChangeNotifierProvider(create: (_) => ThemeProvider()), // Eliminado
      ],
      child: const PortexApp(),
    ),
  );
}

class PortexApp extends StatefulWidget {
  const PortexApp({super.key});

  @override
  State<PortexApp> createState() => _PortexAppState();
}

class _PortexAppState extends State<PortexApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
    await prefs.setBool(
      'window_centered',
      false,
    ); // Ya no está centrado por defecto si se movió/redimensionó
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context); // Eliminado

    return MaterialApp(
      title: 'PORTEX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Forzar tema oscuro
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Forzar modo oscuro
      home: const MainLayout(),
    );
  }
}
