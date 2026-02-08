import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/database/database.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_container.dart';

/// Modal para crear/editar servicios individuales
class ServiceFormModal extends StatefulWidget {
  final Servicio? servicio; // null = nuevo, !null = editar

  const ServiceFormModal({super.key, this.servicio});

  @override
  State<ServiceFormModal> createState() => _ServiceFormModalState();
}

class _ServiceFormModalState extends State<ServiceFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.servicio?.nombre ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.servicio?.descripcion ?? '',
    );
    _precioController = TextEditingController(
      text: widget.servicio?.precio.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _guardarServicio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);

      if (widget.servicio == null) {
        // Crear nuevo
        await db.insertarServicio(
          ServiciosCompanion.insert(
            nombre: _nombreController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            precio: double.parse(_precioController.text.trim()),
            esServicio: true,
            synced: Value(false),
            version: Value(1),
          ),
        );
      } else {
        // Actualizar existente
        await db.actualizarServicio(
          Servicio(
            id: widget.servicio!.id,
            nombre: _nombreController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            precio: double.parse(_precioController.text.trim()),
            esServicio: true,
            synced: false,
            updatedAt: DateTime.now(),
            version: widget.servicio!.version + 1,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Retornar true = éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar servicio: $e'),
            backgroundColor: DesignTokens.urgentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.servicio != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 550),
        child: GlassContainer(
          borderRadius: DesignTokens.radiusLarge,
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.space32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(DesignTokens.space12),
                        decoration: BoxDecoration(
                          color: DesignTokens.cyanNeon.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.room_service_rounded,
                          color: DesignTokens.cyanNeon,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space16),
                      Expanded(
                        child: Text(
                          isEditing ? 'Editar Servicio' : 'Nuevo Servicio',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSize24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xFF111827),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignTokens.space32),

                  // Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Servicio *',
                      hintText: 'Ej: Video Promocional',
                      prefixIcon: Icon(
                        Icons.label_rounded,
                        size: 22,
                        color: DesignTokens.cyanNeon,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.05),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: DesignTokens.cyanNeon,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: DesignTokens.fontSize16),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space20),

                  // Descripción
                  TextFormField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Describe brevemente',
                      prefixIcon: Icon(
                        Icons.description_rounded,
                        size: 22,
                        color: DesignTokens.cyanNeon,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.05),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: DesignTokens.cyanNeon,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: DesignTokens.fontSize16),
                    maxLines: 3,
                  ),

                  const SizedBox(height: DesignTokens.space20),

                  // Precio
                  TextFormField(
                    controller: _precioController,
                    decoration: InputDecoration(
                      labelText: 'Precio *',
                      hintText: '0.00',
                      prefixIcon: Icon(
                        Icons.attach_money_rounded,
                        size: 22,
                        color: DesignTokens.cyanNeon,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.05),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMedium,
                        ),
                        borderSide: BorderSide(
                          color: DesignTokens.cyanNeon,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: DesignTokens.fontSize16),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Requerido';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space32),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(fontSize: DesignTokens.fontSize16),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space16),
                      FilledButton.icon(
                        onPressed: _isLoading ? null : _guardarServicio,
                        icon: _isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.save_rounded, size: 20),
                        label: Text(
                          isEditing ? 'Actualizar' : 'Guardar',
                          style: TextStyle(fontSize: DesignTokens.fontSize16),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: DesignTokens.cyanNeon,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}
