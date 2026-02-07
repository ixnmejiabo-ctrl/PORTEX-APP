import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/database/database.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';

/// Pantalla de Configuración de Empresa
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreEmpresaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final config = await db.obtenerConfiguracionEmpresa();

    if (config != null) {
      setState(() {
        _nombreEmpresaController.text = config.nombreEmpresa;
        _direccionController.text = config.direccion;
        _telefonoController.text = config.contacto;
        _emailController.text = config.responsable; // Mapped to Responsable
      });
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final db = Provider.of<AppDatabase>(context, listen: false);
    final existingConfig = await db.obtenerConfiguracionEmpresa();

    if (existingConfig != null) {
      final updatedConfig = existingConfig.copyWith(
        nombreEmpresa: _nombreEmpresaController.text,
        direccion: _direccionController.text,
        contacto: _telefonoController.text,
        responsable: _emailController.text, // Mapped field
      );
      await db.actualizarConfiguracionEmpresa(updatedConfig);
    } else {
      final nuevaConfig = ConfiguracionEmpresaCompanion(
        nombreEmpresa: drift.Value(_nombreEmpresaController.text),
        direccion: drift.Value(_direccionController.text),
        contacto: drift.Value(_telefonoController.text),
        responsable: drift.Value(_emailController.text), // Mapped field
      );
      await db.insertarConfiguracionEmpresa(nuevaConfig);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Configuración guardada correctamente'),
          backgroundColor: DesignTokens.safeGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.space32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(isDark).animate().fadeIn(duration: 200.ms),

            const SizedBox(height: DesignTokens.space32),

            // Formulario de empresa
            GlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de la Empresa',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSize20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: DesignTokens.space24),

                    _buildTextField(
                      'Nombre de la Empresa',
                      _nombreEmpresaController,
                      Icons.business_rounded,
                      isDark,
                    ),
                    const SizedBox(height: DesignTokens.space16),
                    _buildTextField(
                      'Dirección',
                      _direccionController,
                      Icons.location_on_rounded,
                      isDark,
                    ),
                    const SizedBox(height: DesignTokens.space16),
                    _buildTextField(
                      'Teléfono',
                      _telefonoController,
                      Icons.phone_rounded,
                      isDark,
                    ),
                    const SizedBox(height: DesignTokens.space16),
                    _buildTextField(
                      'Email',
                      _emailController,
                      Icons.email_rounded,
                      isDark,
                    ),

                    const SizedBox(height: DesignTokens.space24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: Icon(Icons.save_rounded),
                        label: Text('Guardar Configuración'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignTokens.purpleNeon,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: DesignTokens.space16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 50.ms, duration: 200.ms),

            const SizedBox(height: DesignTokens.space24),

            // Sección de backup
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Copia de Seguridad',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  Text(
                    'Guarda y restaura los datos de la aplicación',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize14,
                      color: isDark
                          ? DesignTokens.meteorGray
                          : Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: DesignTokens.space24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              // Obtener ruta de la BD
                              final dbFolder =
                                  await getApplicationDocumentsDirectory();
                              final dbPath = p.join(dbFolder.path, 'portex.db');

                              // Llamar al servicio de backup (pedirá ubicación)
                              final backupPath =
                                  await BackupService.backupDatabase(dbPath);

                              if (mounted) {
                                if (backupPath != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Backup guardado en: $backupPath',
                                      ),
                                      backgroundColor: DesignTokens.safeGreen,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  // Usuario canceló
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al crear backup: $e'),
                                    backgroundColor: DesignTokens.urgentRed,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            Icons.backup_rounded,
                            color: DesignTokens.cyanNeon,
                          ),
                          label: Text('Crear Backup'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DesignTokens.cyanNeon,
                            side: BorderSide(
                              color: DesignTokens.cyanNeon,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.space16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Seleccionar archivo
                            final backupPath =
                                await BackupService.pickBackupFile();

                            if (backupPath != null && mounted) {
                              // Confirmar restauración
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Restaurar Base de Datos'),
                                  content: Text(
                                    'ADVERTENCIA: Esta acción sobrescribirá TODOS los datos actuales con los del backup seleccionado.\n\nLa aplicación se cerrará automáticamente para aplicar los cambios.\n\n¿Deseas continuar?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        'Restaurar y Cerrar',
                                        style: TextStyle(
                                          color: DesignTokens.urgentRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && mounted) {
                                try {
                                  // CRITICAL: Cerrar conexión a la BD actual
                                  final db = Provider.of<AppDatabase>(
                                    context,
                                    listen: false,
                                  );
                                  await db.close();

                                  final dbFolder =
                                      await getApplicationDocumentsDirectory();
                                  final dbPath = p.join(
                                    dbFolder.path,
                                    'portex.db',
                                  );

                                  final success =
                                      await BackupService.restoreDatabase(
                                        dbPath,
                                        backupPath,
                                      );

                                  if (mounted) {
                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Restauración completada. Cerrando aplicación...',
                                          ),
                                          backgroundColor:
                                              DesignTokens.safeGreen,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      // Esperar para ver el mensaje
                                      await Future.delayed(
                                        Duration(seconds: 2),
                                      );
                                      exit(0);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al restaurar: Archivo bloqueado o inválido.',
                                          ),
                                          backgroundColor:
                                              DesignTokens.urgentRed,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      // Nota: Si falló, la BD podría estar cerrada. Idealmente reiniciaríamos.
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error crítico: $e'),
                                        backgroundColor: DesignTokens.urgentRed,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          icon: Icon(
                            Icons.restore_rounded,
                            color: DesignTokens.warningYellow,
                          ),
                          label: Text('Restaurar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DesignTokens.warningYellow,
                            side: BorderSide(
                              color: DesignTokens.warningYellow,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.space16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Icon(Icons.settings_rounded, color: DesignTokens.purpleNeon, size: 32),
        const SizedBox(width: DesignTokens.space16),
        Text(
          'Configuración',
          style: TextStyle(
            fontSize: DesignTokens.fontSize32,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSize14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: DesignTokens.space8),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Ingresa $label',
            prefixIcon: Icon(icon, color: DesignTokens.purpleNeon),
          ),
        ),
      ],
    );
  }
}
