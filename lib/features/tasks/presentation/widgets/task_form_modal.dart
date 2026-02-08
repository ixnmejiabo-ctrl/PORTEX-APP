import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/database/database.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

/// Modal para crear o editar una tarea
class TaskFormModal extends StatefulWidget {
  final Actividade? actividad; // null = nueva, con valor = editar

  const TaskFormModal({super.key, this.actividad});

  @override
  State<TaskFormModal> createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _clienteController;
  final FocusNode _clienteFocusNode = FocusNode();

  Cliente? _clienteSeleccionado;
  String _tipoSeleccionado = 'Video';
  String _estadoSeleccionado = 'Pendiente';
  String _plataformaSeleccionada = 'TikTok';
  late DateTime _fechaInicio;
  DateTime? _fechaPublicado; // Usada como fecha de entrega en el formulario

  List<Cliente> _clientes = [];
  List<Servicio> _servicios = [];
  bool _guardando = false;

  // Tipos dinámicos cargados de Servicios
  List<String> _tipos = [];
  final List<String> _estados = [
    'Pendiente',
    'En Proceso',
    'Listo',
    'Entregado',
    'Publicado',
    'Retrasado',
  ];
  final List<String> _plataformas = [
    'TikTok',
    'Instagram',
    'Facebook',
    'YouTube',
  ];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.actividad?.nombreActividad ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.actividad?.descripcion ?? '',
    );
    _precioController = TextEditingController(
      text: widget.actividad?.precio?.toString() ?? '',
    );

    if (widget.actividad != null) {
      _tipoSeleccionado = widget.actividad!.tipo;
      _estadoSeleccionado = widget.actividad!.estado;
      _plataformaSeleccionada = widget.actividad!.plataforma;
      _fechaInicio = widget.actividad?.fechaInicio ?? DateTime.now();
      _fechaPublicado =
          widget.actividad?.fechaPublicado ??
          DateTime.now().add(Duration(days: 7));
    } else {
      _fechaInicio = DateTime.now();
      _fechaPublicado = DateTime.now().add(Duration(days: 7));
    }

    _clienteController = TextEditingController(
      text: widget.actividad?.nombreClienteManual ?? '',
    );

    _loadData();
  }

  Future<void> _loadData() async {
    final db = Provider.of<AppDatabase>(context, listen: false);

    // Cargar Clientes
    final clientes = await db.obtenerTodosLosClientes();

    // Cargar Servicios
    var servicios = await db.select(db.servicios).get();

    // Si no hay servicios, inicializar con defaults
    if (servicios.isEmpty) {
      await db.batch((batch) {
        batch.insertAll(db.servicios, [
          ServiciosCompanion.insert(
            nombre: 'Video',
            descripcion: 'Video promocional',
            precio: 500.00,
            esServicio: true,
          ),
          ServiciosCompanion.insert(
            nombre: 'Imagen',
            descripcion: 'Diseño gráfico',
            precio: 200.00,
            esServicio: true,
          ),
          ServiciosCompanion.insert(
            nombre: 'Campaña',
            descripcion: 'Campaña publicitaria',
            precio: 1500.00,
            esServicio: true,
          ),
          ServiciosCompanion.insert(
            nombre: 'Post',
            descripcion: 'Post para redes',
            precio: 150.00,
            esServicio: true,
          ),
          ServiciosCompanion.insert(
            nombre: 'Historia',
            descripcion: 'Story para redes',
            precio: 100.00,
            esServicio: true,
          ),
        ]);
      });
      servicios = await db.select(db.servicios).get();
    }

    setState(() {
      _clientes = clientes;
      _servicios = servicios;
      _tipos = servicios.map((s) => s.nombre).toList();

      // Cliente seleccionado logic
      if (widget.actividad != null && widget.actividad!.clienteId != null) {
        try {
          _clienteSeleccionado = clientes.firstWhere(
            (c) => c.id == widget.actividad!.clienteId,
          );
          _clienteController.text = _clienteSeleccionado!.empresa;
        } catch (_) {}
      }

      // Asegurar que _tipoSeleccionado sea válido
      if (!_tipos.contains(_tipoSeleccionado) && _tipos.isNotEmpty) {
        _tipoSeleccionado = _tipos.first;
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _clienteController.dispose();
    _clienteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _guardarTarea() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar que haya texto en el cliente
    if (_clienteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresa o selecciona un cliente'),
          backgroundColor: DesignTokens.urgentRed,
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);

      // Determinar si es cliente registrado o manual
      final int? clienteId = _clienteSeleccionado?.id;
      final String? nombreManual = _clienteSeleccionado == null
          ? _clienteController.text
          : null;

      if (widget.actividad == null) {
        // Nueva tarea
        await db.insertarActividad(
          ActividadesCompanion.insert(
            clienteId: drift.Value(clienteId),
            nombreClienteManual: drift.Value(nombreManual),
            nombreActividad: _nombreController.text,
            descripcion: _descripcionController.text,
            fechaInicio: _fechaInicio,
            fechaPublicado: drift.Value(_fechaPublicado),
            tipo: _tipoSeleccionado,
            precio: drift.Value(double.tryParse(_precioController.text)),
            estado: _estadoSeleccionado,
            plataforma: _plataformaSeleccionada,
          ),
        );
      } else {
        // Editar tarea
        await db.actualizarActividad(
          widget.actividad!.copyWith(
            nombreActividad: _nombreController.text,
            descripcion: _descripcionController.text,
            clienteId: drift.Value(clienteId),
            nombreClienteManual: drift.Value(nombreManual),
            fechaInicio: _fechaInicio,
            fechaPublicado: drift.Value(_fechaPublicado),
            tipo: _tipoSeleccionado,
            precio: drift.Value(double.tryParse(_precioController.text)),
            estado: _estadoSeleccionado,
            plataforma: _plataformaSeleccionada,
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
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 700),
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
                        Icons.task_alt_rounded,
                        color: DesignTokens.cyanNeon,
                        size: 28,
                      ),
                      const SizedBox(width: DesignTokens.space12),
                      Expanded(
                        child: Text(
                          widget.actividad == null
                              ? 'Nueva Tarea'
                              : 'Editar Tarea',
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

                  // Nombre de la actividad
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Actividad *',
                      hintText: 'Ej: Video promocional producto X',
                      prefixIcon: Icon(
                        Icons.edit_rounded,
                        color: DesignTokens.cyanNeon,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un nombre';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Descripción
                  TextFormField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Detalles de la actividad',
                      prefixIcon: Icon(
                        Icons.description_rounded,
                        color: DesignTokens.cyanNeon,
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Cliente Autocomplete
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return RawAutocomplete<Cliente>(
                        textEditingController: _clienteController,
                        focusNode: _clienteFocusNode,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Cliente>.empty();
                          }
                          return _clientes.where((Cliente option) {
                            return option.empresa.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        displayStringForOption: (Cliente option) =>
                            option.empresa,
                        onSelected: (Cliente selection) {
                          setState(() {
                            _clienteSeleccionado = selection;
                          });
                        },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<Cliente> onSelected,
                              Iterable<Cliente> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: Colors.transparent,
                                  child: Container(
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1F2937)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        DesignTokens.radiusMedium,
                                      ),
                                      border: Border.all(
                                        color: DesignTokens.purpleNeon
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final Cliente option = options
                                                .elementAt(index);
                                            return ListTile(
                                              leading: Icon(
                                                Icons.business_rounded,
                                                color: DesignTokens.purpleNeon,
                                                size: 20,
                                              ),
                                              title: Text(
                                                option.empresa,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                              subtitle: Text(
                                                option.nombreGerente,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.black54,
                                                ),
                                              ),
                                              onTap: () {
                                                onSelected(option);
                                              },
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
                                onChanged: (value) {
                                  // Si el usuario edita el texto y ya no coincide con el seleccionado
                                  if (_clienteSeleccionado != null &&
                                      value != _clienteSeleccionado!.empresa) {
                                    setState(() {
                                      _clienteSeleccionado = null;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Cliente *',
                                  hintText:
                                      'Selecciona o escribe un nombre visual',
                                  prefixIcon: Icon(
                                    Icons.business_rounded,
                                    color: DesignTokens.purpleNeon,
                                  ),
                                  suffixIcon: _clienteSeleccionado != null
                                      ? Icon(
                                          Icons.check_circle_rounded,
                                          color: DesignTokens.safeGreen,
                                        )
                                      : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa o selecciona un cliente';
                                  }
                                  return null;
                                },
                              );
                            },
                      );
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  // Tipo y Precio (Responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 600;
                      if (isMobile) {
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: _tipos.contains(_tipoSeleccionado)
                                  ? _tipoSeleccionado
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Tipo',
                                prefixIcon: Icon(
                                  Icons.category_rounded,
                                  color: DesignTokens.blueNeon,
                                ),
                              ),
                              items: _tipos
                                  .map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _tipoSeleccionado = value;
                                    try {
                                      final servicio = _servicios.firstWhere(
                                        (s) => s.nombre == value,
                                      );
                                      _precioController.text = servicio.precio
                                          .toStringAsFixed(0);
                                    } catch (_) {}
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            TextFormField(
                              controller: _precioController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Precio',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Bs',
                                    style: TextStyle(
                                      color: DesignTokens.safeGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: _tipos.contains(_tipoSeleccionado)
                                    ? _tipoSeleccionado
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Tipo',
                                  prefixIcon: Icon(
                                    Icons.category_rounded,
                                    color: DesignTokens.blueNeon,
                                  ),
                                ),
                                items: _tipos
                                    .map(
                                      (tipo) => DropdownMenuItem(
                                        value: tipo,
                                        child: Text(tipo),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _tipoSeleccionado = value;
                                      try {
                                        final servicio = _servicios.firstWhere(
                                          (s) => s.nombre == value,
                                        );
                                        _precioController.text = servicio.precio
                                            .toStringAsFixed(0);
                                      } catch (_) {}
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space16),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _precioController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Precio',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Bs',
                                      style: TextStyle(
                                        color: DesignTokens.safeGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: DesignTokens.space16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 600;
                      if (isMobile) {
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: _estadoSeleccionado,
                              decoration: InputDecoration(
                                labelText: 'Estado',
                                prefixIcon: Icon(
                                  Icons.info_rounded,
                                  color: DesignTokens.warningYellow,
                                ),
                              ),
                              items: _estados
                                  .map(
                                    (estado) => DropdownMenuItem(
                                      value: estado,
                                      child: Text(estado),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _estadoSeleccionado = value!),
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            DropdownButtonFormField<String>(
                              initialValue: _plataformaSeleccionada,
                              decoration: InputDecoration(
                                labelText: 'Plataforma',
                                prefixIcon: Icon(
                                  Icons.public_rounded,
                                  color: DesignTokens.cyanNeon,
                                ),
                              ),
                              items: _plataformas
                                  .map(
                                    (plat) => DropdownMenuItem(
                                      value: plat,
                                      child: Text(plat),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(
                                () => _plataformaSeleccionada = value!,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            _buildDateField('Fecha Inicio', _fechaInicio, (
                              date,
                            ) {
                              setState(() => _fechaInicio = date);
                            }, isDark),
                            const SizedBox(height: DesignTokens.space16),
                            _buildDateField(
                              'Fecha Entrega',
                              _fechaPublicado ??
                                  DateTime.now().add(Duration(days: 7)),
                              (date) {
                                setState(() => _fechaPublicado = date);
                              },
                              isDark,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _estadoSeleccionado,
                                    decoration: InputDecoration(
                                      labelText: 'Estado',
                                      prefixIcon: Icon(
                                        Icons.info_rounded,
                                        color: DesignTokens.warningYellow,
                                      ),
                                    ),
                                    items: _estados
                                        .map(
                                          (estado) => DropdownMenuItem(
                                            value: estado,
                                            child: Text(estado),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(
                                      () => _estadoSeleccionado = value!,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.space16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _plataformaSeleccionada,
                                    decoration: InputDecoration(
                                      labelText: 'Plataforma',
                                      prefixIcon: Icon(
                                        Icons.public_rounded,
                                        color: DesignTokens.cyanNeon,
                                      ),
                                    ),
                                    items: _plataformas
                                        .map(
                                          (plat) => DropdownMenuItem(
                                            value: plat,
                                            child: Text(plat),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(
                                      () => _plataformaSeleccionada = value!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    'Fecha Inicio',
                                    _fechaInicio,
                                    (date) {
                                      setState(() => _fechaInicio = date);
                                    },
                                    isDark,
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.space16),
                                Expanded(
                                  child: _buildDateField(
                                    'Fecha Entrega',
                                    _fechaPublicado ??
                                        DateTime.now().add(Duration(days: 7)),
                                    (date) {
                                      setState(() => _fechaPublicado = date);
                                    },
                                    isDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
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
                          onPressed: _guardando ? null : _guardarTarea,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignTokens.cyanNeon,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
            color: DesignTokens.cyanNeon,
            size: isMobile ? 18 : 24,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12,
            vertical: isMobile ? 12 : 16,
          ),
        ),
        child: Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
          style: TextStyle(
            fontSize: isMobile
                ? DesignTokens.fontSize12
                : DesignTokens.fontSize14,
            color: isDark ? Colors.white : Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
