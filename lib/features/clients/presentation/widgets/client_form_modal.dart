import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/database/database.dart';
import 'package:provider/provider.dart';

/// Modal para crear o editar un cliente
class ClientFormModal extends StatefulWidget {
  final Cliente? cliente; // null = nuevo, con valor = editar

  const ClientFormModal({super.key, this.cliente});

  @override
  State<ClientFormModal> createState() => _ClientFormModalState();
}

class _ClientFormModalState extends State<ClientFormModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _empresaController;
  late TextEditingController _gerenteController;
  late TextEditingController _contactoController;
  late TextEditingController _servicioController;
  final FocusNode _servicioFocusNode = FocusNode();

  List<String> _opcionesServicios = [];

  DateTime _fechaRegistro = DateTime.now();
  DateTime _fechaEntrega = DateTime.now().add(Duration(days: 30));

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _empresaController = TextEditingController(
      text: widget.cliente?.empresa ?? '',
    );
    _gerenteController = TextEditingController(
      text: widget.cliente?.nombreGerente ?? '',
    );
    _contactoController = TextEditingController(
      text: widget.cliente?.numeroContacto ?? '',
    );
    _servicioController = TextEditingController(
      text: widget.cliente?.servicio ?? '',
    );

    if (widget.cliente != null) {
      _fechaRegistro = widget.cliente!.fechaRegistro;
      _fechaEntrega = widget.cliente!.fechaEntrega;
    }

    _loadServicios();
  }

  Future<void> _loadServicios() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final servicios = await db.obtenerTodosLosServicios();
    if (mounted) {
      setState(() {
        _opcionesServicios = servicios.map((s) => s.nombre).toList();
      });
    }
  }

  @override
  void dispose() {
    _empresaController.dispose();
    _gerenteController.dispose();
    _contactoController.dispose();
    _servicioController.dispose();
    _servicioFocusNode.dispose();
    super.dispose();
  }

  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);

      if (widget.cliente == null) {
        // Nuevo cliente
        await db.insertarCliente(
          ClientesCompanion.insert(
            empresa: _empresaController.text,
            nombreGerente: _gerenteController.text,
            numeroContacto: _contactoController.text,
            servicio: _servicioController.text,
            fechaRegistro: _fechaRegistro,
            fechaEntrega: _fechaEntrega,
          ),
        );
      } else {
        // Editar cliente
        await db.actualizarCliente(
          widget.cliente!.copyWith(
            empresa: _empresaController.text,
            nombreGerente: _gerenteController.text,
            numeroContacto: _contactoController.text,
            servicio: _servicioController.text,
            fechaRegistro: _fechaRegistro,
            fechaEntrega: _fechaEntrega,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true); // true = guardado exitoso
      }
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: DesignTokens.urgentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 650),
        child: GlassCard(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        color: DesignTokens.purpleNeon,
                        size: 28,
                      ),
                      const SizedBox(width: DesignTokens.space12),
                      Expanded(
                        child: Text(
                          widget.cliente == null
                              ? 'Nuevo Cliente'
                              : 'Editar Cliente',
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
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignTokens.space24),

                  // Empresa
                  TextFormField(
                    controller: _empresaController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Empresa *',
                      hintText: 'Ej: Acme Corp',
                      prefixIcon: Icon(
                        Icons.business_rounded,
                        color: DesignTokens.purpleNeon,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el nombre de la empresa';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Gerente
                  TextFormField(
                    controller: _gerenteController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Gerente *',
                      hintText: 'Ej: Juan Pérez',
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: DesignTokens.purpleNeon,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el nombre del gerente';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Contacto
                  TextFormField(
                    controller: _contactoController,
                    decoration: InputDecoration(
                      labelText: 'Número de Contacto *',
                      hintText: 'Ej: +1234567890',
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: DesignTokens.blueNeon,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un número de contacto';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Servicio (Autocomplete)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return RawAutocomplete<String>(
                        textEditingController: _servicioController,
                        focusNode: _servicioFocusNode,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _opcionesServicios.where((String option) {
                            return option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusMedium,
                                  ),
                                  child: Container(
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? DesignTokens.darkNebula
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusMedium,
                                      ),
                                      border: Border.all(
                                        color: DesignTokens.purpleNeon
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    constraints: BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final String option = options
                                                .elementAt(index);
                                            return ListTile(
                                              onTap: () => onSelected(option),
                                              leading: Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                                size: 16,
                                                color: DesignTokens.purpleNeon,
                                              ),
                                              title: Text(
                                                option,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                              hoverColor: DesignTokens
                                                  .purpleNeon
                                                  .withValues(alpha: 0.1),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Servicio Contratado *',
                                  hintText:
                                      'Ej: Paquete Premium Redes Sociales',
                                  prefixIcon: Icon(
                                    Icons.work_rounded,
                                    color: DesignTokens.cyanNeon,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa el servicio contratado';
                                  }
                                  return null;
                                },
                              );
                            },
                      );
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Fechas
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          'Fecha Registro',
                          _fechaRegistro,
                          (date) {
                            setState(() => _fechaRegistro = date);
                          },
                          isDark,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space16),
                      Expanded(
                        child: _buildDateField(
                          'Fecha de Finalización',
                          _fechaEntrega,
                          (date) {
                            setState(() => _fechaEntrega = date);
                          },
                          isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DesignTokens.space24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _guardando
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _guardando ? null : _guardarCliente,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.purpleNeon,
                            foregroundColor: Colors.white,
                          ),
                          child: _guardando
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
    bool isDark,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.calendar_today_rounded,
            color: DesignTokens.purpleNeon,
          ),
        ),
        child: Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
          style: TextStyle(
            fontSize: DesignTokens.fontSize14,
            color: isDark ? Colors.white : Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
