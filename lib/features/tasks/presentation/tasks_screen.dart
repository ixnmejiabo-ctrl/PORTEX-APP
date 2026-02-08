import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/date_helpers.dart';
import 'widgets/task_form_modal.dart';
import 'widgets/completed_tasks_modal.dart';

/// Pantalla de Tareas con KPIs, búsqueda, filtros y lista completa
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Cliente> _clientes = [];
  List<Servicio> _servicios = [];
  Map<int, String> _nombresClientes = {};

  final TextEditingController _searchController = TextEditingController();

  // Filtros activos
  String? _selectedPlataforma;
  String? _selectedTipo;
  String? _selectedEstado;
  int? _selectedClienteId; // Filtro de cliente

  // Stats
  int totalTareas = 0;
  int pendientes = 0;
  int completadas = 0;
  int retrasadas = 0;

  List<Actividade> _tareas = [];
  List<Actividade> _tareasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _loadTareas();
    _searchController.addListener(_aplicarFiltros);
  }

  Future<void> _loadTareas() async {
    final db = Provider.of<AppDatabase>(context, listen: false);

    final todasTareas = await db.obtenerTodasLasActividades();
    final pending = await db.obtenerActividadesNoCompletadas();
    final completed = await db.obtenerActividadesCompletadas();
    final clientes = await db.obtenerTodosLosClientes();
    final servicios = await db.select(db.servicios).get(); // Cargar servicios

    setState(() {
      _clientes = clientes;
      _servicios = servicios; // Guardar servicios
      _nombresClientes = {for (var c in clientes) c.id: c.empresa};
      _tareas = todasTareas;
      totalTareas = todasTareas.length;
      pendientes = pending.length;
      completadas = completed.length;
      // Calcular retrasadas (tareas pendientes con fecha pasada, contando el día siguiente a la fecha de entrega)
      retrasadas = pending
          .where(
            (t) =>
                t.fechaPublicado != null &&
                t.fechaPublicado!
                    .add(const Duration(days: 1))
                    .isBefore(DateTime.now()),
          )
          .length;
      _aplicarFiltros(); // Apply filters after loading all data
    });
  }

  void _aplicarFiltros() {
    setState(() {
      _tareasFiltradas = _tareas.where((tarea) {
        // Filtro de búsqueda
        if (_searchController.text.isNotEmpty) {
          final searchTerm = _searchController.text.toLowerCase();
          if (!tarea.nombreActividad.toLowerCase().contains(searchTerm) &&
              !(tarea.descripcion.toLowerCase().contains(searchTerm))) {
            return false;
          }
        }

        // Filtro de plataforma
        if (_selectedPlataforma != null &&
            tarea.plataforma != _selectedPlataforma) {
          return false;
        }

        // Filtro de tipo
        if (_selectedTipo != null && tarea.tipo != _selectedTipo) {
          return false;
        }

        // Filtro de estado
        if (_selectedEstado != null && tarea.estado != _selectedEstado) {
          return false;
        }

        // Filtro de cliente
        if (_selectedClienteId != null &&
            tarea.clienteId != _selectedClienteId) {
          return false;
        }

        // Filtro de tareas completadas (Solo mostrar NO completadas en lista principal)
        if (tarea.completada) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header y KPIs - Fixed
          Container(
            padding: EdgeInsets.all(
              isMobile ? DesignTokens.space12 : DesignTokens.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con título
                _buildHeader(
                  isDark,
                ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),

                const SizedBox(height: DesignTokens.space24),

                // KPIs
                _buildKPIsRow(
                  isDark,
                ).animate().fadeIn(delay: 50.ms, duration: 200.ms),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Buscador y filtros
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? DesignTokens.space12
                  : DesignTokens.space24,
            ),
            child: _buildSearchAndFilters(
              isDark,
            ).animate().fadeIn(delay: 100.ms, duration: 200.ms),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Lista de tareas - Scrollable
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? DesignTokens.space12
                    : DesignTokens.space24,
              ),
              child: _tareasFiltradas.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildTasksList(
                      isDark,
                    ).animate().fadeIn(delay: 150.ms, duration: 200.ms),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isDark),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space32,
        vertical: DesignTokens.space24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [DesignTokens.deepSpace, DesignTokens.darkNebula]
              : [Color(0xFFF0F2F8), Color(0xFFE8ECFC)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tareas',
            style: TextStyle(
              fontSize: DesignTokens.fontSize32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          // Botón para ver completadas
          TextButton.icon(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const CompletedTasksModal(),
              );
              _loadTareas();
            },
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: DesignTokens.safeGreen,
              size: 20,
            ),
            label: Text(
              'Ver Completadas',
              style: TextStyle(
                color: DesignTokens.safeGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: DesignTokens.safeGreen.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space16,
                vertical: DesignTokens.space12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total',
            totalTareas.toString(),
            Icons.list_alt_rounded,
            DesignTokens.cyanNeon,
            isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            'Pendientes',
            pendientes.toString(),
            Icons.pending_actions_rounded,
            DesignTokens.warningYellow,
            isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            'Completadas',
            completadas.toString(),
            Icons.check_circle_rounded,
            DesignTokens.safeGreen,
            isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            'Retrasadas',
            retrasadas.toString(),
            Icons.warning_rounded,
            DesignTokens.urgentRed,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return GlassCard(
      showGlow: true,
      accentColor: color,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: DesignTokens.space8),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSize24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSize12,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isDark) {
    return Column(
      children: [
        // Buscador
        TextField(
          controller: _searchController,
          onChanged: (_) => _aplicarFiltros(),
          style: TextStyle(color: isDark ? Colors.white : Color(0xFF1F2937)),
          decoration: InputDecoration(
            hintText: 'Buscar tareas...',
            hintStyle: TextStyle(
              color: isDark ? DesignTokens.meteorGray : Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: DesignTokens.cyanNeon,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: DesignTokens.meteorGray,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _aplicarFiltros();
                    },
                  )
                : null,
          ),
        ),

        const SizedBox(height: DesignTokens.space16),

        // Chips de filtros
        Wrap(
          spacing: DesignTokens.space8,
          runSpacing: DesignTokens.space8,
          children: [
            _buildFilterChip(
              'Plataforma',
              _selectedPlataforma,
              ['TikTok', 'Instagram', 'Facebook', 'YouTube'],
              (value) {
                setState(() {
                  _selectedPlataforma = value == _selectedPlataforma
                      ? null
                      : value;
                  _aplicarFiltros();
                });
              },
              isDark,
              icon: Icons.public_rounded,
            ),
            _buildFilterChip(
              'Cliente',
              _selectedClienteId != null
                  ? _nombresClientes[_selectedClienteId]
                  : null,
              _clientes.map((c) => c.empresa).toList(),
              (value) {
                final cliente = _clientes.firstWhere((c) => c.empresa == value);
                setState(() {
                  _selectedClienteId = _selectedClienteId == cliente.id
                      ? null
                      : cliente.id;
                  _aplicarFiltros();
                });
              },
              isDark,
              icon: Icons.business_rounded,
            ),
            _buildFilterChip(
              'Tipo',
              _selectedTipo,
              _servicios.map((s) => s.nombre).toList().isNotEmpty
                  ? _servicios.map((s) => s.nombre).toList()
                  : ['Video', 'Imagen', 'Campaña', 'Post', 'Historia'],
              (value) {
                setState(() {
                  _selectedTipo = value == _selectedTipo ? null : value;
                  _aplicarFiltros();
                });
              },
              isDark,
              icon: Icons.category_rounded,
            ),
            _buildFilterChip(
              'Estado',
              _selectedEstado,
              [
                'Pendiente',
                'En Proceso',
                'Listo',
                'Entregado',
                'Publicado',
                'Retrasado',
              ],
              (value) {
                setState(() {
                  _selectedEstado = value == _selectedEstado ? null : value;
                  _aplicarFiltros();
                });
              },
              isDark,
              icon: Icons.check_circle_outline_rounded,
            ),
            // Botón Limpiar filtros
            if (_selectedPlataforma != null ||
                _selectedTipo != null ||
                _selectedEstado != null ||
                _selectedClienteId != null)
              ActionChip(
                avatar: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: DesignTokens.urgentRed,
                ),
                label: Text(
                  'Limpiar',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    color: DesignTokens.urgentRed,
                  ),
                ),
                backgroundColor: DesignTokens.urgentRed.withValues(alpha: 0.1),
                side: BorderSide(
                  color: DesignTokens.urgentRed.withValues(alpha: 0.5),
                ),
                onPressed: () {
                  setState(() {
                    _selectedPlataforma = null;
                    _selectedTipo = null;
                    _selectedEstado = null;
                    _selectedClienteId = null;
                    _searchController.clear();
                    _aplicarFiltros();
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    String? selectedValue,
    List<String> options,
    Function(String) onSelected,
    bool isDark, {
    IconData? icon,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(value: option, child: Text(option));
      }).toList(),
      child: Chip(
        avatar: Icon(
          icon ?? Icons.filter_list_rounded,
          size: 18,
          color: selectedValue != null
              ? DesignTokens.cyanNeon
              : (isDark ? DesignTokens.meteorGray : Color(0xFF6B7280)),
        ),
        label: Text(
          selectedValue ?? label,
          style: TextStyle(
            fontSize: DesignTokens.fontSize12,
            color: selectedValue != null
                ? DesignTokens.cyanNeon
                : (isDark ? Colors.white : Color(0xFF1F2937)),
            fontWeight: selectedValue != null
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
        backgroundColor: selectedValue != null
            ? DesignTokens.cyanNeon.withValues(alpha: 0.2)
            : (isDark ? DesignTokens.darkGray : Color(0xFFE5E7EB)),
        side: BorderSide(
          color: selectedValue != null
              ? DesignTokens.cyanNeon
              : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildTasksList(bool isDark) {
    return ListView.builder(
      itemCount: _tareasFiltradas.length,
      itemBuilder: (context, index) {
        final tarea = _tareasFiltradas[index];
        return _buildTaskCard(tarea, isDark)
            .animate()
            .fadeIn(delay: (index * 30).ms, duration: 200.ms)
            .slideX(begin: 0.1);
      },
    );
  }

  Widget _buildTaskCard(Actividade tarea, bool isDark) {
    final typeColor = ActivityTypeHelper.getTypeColor(tarea.tipo);

    final fechaObjetivo = tarea.fechaPublicado ?? tarea.fechaInicio;
    final urgencyColor = DateHelpers.getUrgencyColor(fechaObjetivo);
    final daysLeft = DateHelpers.daysUntil(fechaObjetivo);

    // Obtener nombre del cliente
    final clientName =
        tarea.nombreClienteManual ??
        (_nombresClientes[tarea.clienteId] ?? 'Sin Cliente');

    // Generar color consistente basado en el ID del cliente
    final clientColor =
        Colors.primaries[(tarea.clienteId ?? 0) % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space16),
      child: GlassCard(
        // Se elimina el onTap global para evitar abrir editor accidentalmente
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de color de tipo (Ahora color de cliente)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: clientColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: DesignTokens.space16),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            // Formato: CLIENTE | TAREA (Sin corchetes)
                            '${clientName.toUpperCase()} | ${tarea.nombreActividad.toUpperCase()}',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSize14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Color(0xFF111827),
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: DesignTokens.space4),

                        // Botón Editar (Lápiz) - Pegado al título
                        IconButton(
                          icon: Icon(
                            Icons.edit_rounded,
                            color: DesignTokens.cyanNeon,
                            size: 16,
                          ),
                          tooltip: 'Editar',
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) =>
                                  TaskFormModal(actividad: tarea),
                            );

                            if (result == true) {
                              _loadTareas();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tarea actualizada'),
                                    backgroundColor: DesignTokens.safeGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        ),

                        const SizedBox(width: DesignTokens.space8),

                        // Badge de días restantes
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.space8,
                            vertical: DesignTokens.space4,
                          ),
                          decoration: BoxDecoration(
                            color: urgencyColor.withValues(
                              alpha: 0.2,
                            ), // Fondo semitransparente del color
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusLarge,
                            ),
                            border: Border.all(color: urgencyColor, width: 1),
                          ),
                          child: Text(
                            '$daysLeft días',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSize10,
                              fontWeight: FontWeight.bold,
                              color: urgencyColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DesignTokens.space8),

                    Text(
                      tarea.descripcion,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSize14,
                        color: isDark
                            ? DesignTokens.meteorGray
                            : Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: DesignTokens.space12),

                    // Metadatos
                    Wrap(
                      spacing: DesignTokens.space8,
                      runSpacing: DesignTokens.space8,
                      children: [
                        _buildMetaChip(
                          Icons.category_rounded,
                          tarea.tipo,
                          typeColor,
                          isDark,
                        ),
                        // Chip de estado eliminado de aquí (movido)
                        _buildMetaChip(
                          Icons.public_rounded,
                          tarea.plataforma,
                          DesignTokens.blueNeon,
                          isDark,
                        ),
                        // Fecha Inicio (Violeta)
                        _buildMetaChip(
                          Icons.calendar_today_rounded,
                          DateHelpers.formatDate(tarea.fechaInicio),
                          DesignTokens.purpleNeon,
                          isDark,
                        ),
                        // Fecha Entrega (Rojo)
                        if (tarea.fechaPublicado != null)
                          _buildMetaChip(
                            Icons.event_busy_rounded,
                            DateHelpers.formatDate(tarea.fechaPublicado!),
                            DesignTokens.urgentRed,
                            isDark,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: DesignTokens.space12),

              // Columna de acciones (Derecha)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chip Estado (Movido aquí - Dropdown)
                      _buildInteractiveStatusChip(tarea, isDark),
                      const SizedBox(width: DesignTokens.space8),
                      // Botón Eliminar
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: DesignTokens.urgentRed,
                          size: 20,
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Eliminar Tarea'),
                              content: Text(
                                '¿Estás seguro de que deseas eliminar "${tarea.nombreActividad}"?\n\nEsta acción no se puede deshacer.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: DesignTokens.urgentRed,
                                  ),
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && mounted) {
                            try {
                              final db = Provider.of<AppDatabase>(
                                context,
                                listen: false,
                              );
                              await db.eliminarActividad(tarea.id);
                              _loadTareas();

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Tarea eliminada exitosamente',
                                    ),
                                    backgroundColor: DesignTokens.safeGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Manejo de error silencioso
                            }
                          }
                        },
                        tooltip: 'Eliminar',
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  Spacer(), // Espacio flexible
                  // Fecha completado check visual (Opcional, o mantener solo el estado arriba)
                  // Restauramos el botón de completado
                  _buildCompletionButton(tarea, isDark),
                ],
              ),
            ],
          ),
        ), // Cierre de IntrinsicHeight
      ), // Cierre de GlassCard
    );
  }

  Widget _buildMetaChip(IconData icon, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space8,
        vertical: DesignTokens.space4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSize12,
              color: isDark ? Colors.white : Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionButton(Actividade tarea, bool isDark) {
    // Lógica del botón grande de completado
    final isCompleted = tarea.completada;
    final color = isCompleted
        ? DesignTokens.safeGreen
        : (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final textColor = isCompleted
        ? Colors.white
        : (isDark ? Colors.grey[300] : Colors.grey[800]);
    final label = isCompleted ? 'COMPLETADO' : 'PENDIENTE';

    return InkWell(
      onTap: () {
        _actualizarTarea(
          context,
          tarea.copyWith(completada: !tarea.completada),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isCompleted)
              BoxShadow(
                color: DesignTokens.safeGreen.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted) ...[
              const Icon(Icons.check_rounded, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 80,
            color: DesignTokens.meteorGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DesignTokens.space24),
          Text(
            'No hay tareas',
            style: TextStyle(
              fontSize: DesignTokens.fontSize24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            'Crea tu primera tarea con el botón +',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildFAB(bool isDark) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => TaskFormModal(),
        );

        if (result == true) {
          _loadTareas(); // Recargar tareas tras guardar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tarea creada exitosamente'),
                backgroundColor: DesignTokens.safeGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      backgroundColor: DesignTokens.cyanNeon,
      foregroundColor: Colors.black,
      icon: Icon(Icons.add_rounded),
      label: Text(
        'Nueva Tarea',
        style: TextStyle(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().scale(delay: 200.ms, duration: 200.ms);
  }

  Future<void> _actualizarTarea(
    BuildContext context,
    Actividade tareaUpdated,
  ) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.actualizarActividad(tareaUpdated);
    _loadTareas();
  }

  Widget _buildInteractiveStatusChip(Actividade tarea, bool isDark) {
    final stateColor = ActivityStateHelper.getStateColor(tarea.estado);

    return PopupMenuButton<String>(
      tooltip: 'Cambiar estado',
      onSelected: (newStatus) {
        if (newStatus != tarea.estado) {
          _actualizarTarea(context, tarea.copyWith(estado: newStatus));
        }
      },
      itemBuilder: (context) =>
          [
            'Pendiente',
            'En Proceso',
            'Listo',
            'Entregado',
            'Publicado',
            'Retrasado',
          ].map((status) {
            final color = ActivityStateHelper.getStateColor(status);
            return PopupMenuItem<String>(
              value: status,
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: color),
                  const SizedBox(width: 8),
                  Text(status),
                ],
              ),
            );
          }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space8,
          vertical: DesignTokens.space4,
        ),
        decoration: BoxDecoration(
          color: stateColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
          border: Border.all(
            color: stateColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_rounded, size: 14, color: stateColor),
            const SizedBox(width: 4),
            Text(
              tarea.estado,
              style: TextStyle(
                fontSize: DesignTokens.fontSize12,
                color: isDark ? Colors.white : Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
