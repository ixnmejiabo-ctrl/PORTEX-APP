import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/utils/date_helpers.dart';

/// Modal para visualizar tareas completadas agrupadas por fechas
class CompletedTasksModal extends StatefulWidget {
  const CompletedTasksModal({super.key});

  @override
  State<CompletedTasksModal> createState() => _CompletedTasksModalState();
}

class _CompletedTasksModalState extends State<CompletedTasksModal> {
  List<Actividade> _tareasCompletadas = [];
  List<Cliente> _clientes = [];
  List<Servicio> _servicios = [];
  Map<int, String> _nombresClientes = {};

  String _searchQuery = '';
  bool _isLoading = true;

  // Filtros
  String? _selectedPlataforma;
  String? _selectedTipo;
  int? _selectedClienteId;

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  Future<void> _loadCompletedTasks() async {
    setState(() => _isLoading = true);
    final db = Provider.of<AppDatabase>(context, listen: false);

    // Cargar datos en paralelo
    final tasksFuture = db.obtenerActividadesCompletadas();
    final clientesFuture = db.obtenerTodosLosClientes();
    final serviciosFuture = db.select(db.servicios).get();

    final results = await Future.wait([
      tasksFuture,
      clientesFuture,
      serviciosFuture,
    ]);

    final tasks = results[0] as List<Actividade>;
    final clientes = results[1] as List<Cliente>;
    final servicios = results[2] as List<Servicio>;

    // Ordenar por fecha de inicio descendente
    tasks.sort((a, b) => b.fechaInicio.compareTo(a.fechaInicio));

    setState(() {
      _tareasCompletadas = tasks;
      _clientes = clientes;
      _servicios = servicios;
      _nombresClientes = {for (var c in clientes) c.id: c.empresa};
      _isLoading = false;
    });
  }

  List<Actividade> get _filteredTasks {
    return _tareasCompletadas.where((task) {
      // 1. Búsqueda por texto
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch =
            task.nombreActividad.toLowerCase().contains(query) ||
            task.descripcion.toLowerCase().contains(query) ||
            task.tipo.toLowerCase().contains(query);
        if (!matchesSearch) return false;
      }

      // 2. Filtro Plataforma
      if (_selectedPlataforma != null &&
          task.plataforma != _selectedPlataforma) {
        return false;
      }

      // 3. Filtro Tipo
      if (_selectedTipo != null && task.tipo != _selectedTipo) {
        return false;
      }

      // 4. Filtro Cliente
      if (_selectedClienteId != null && task.clienteId != _selectedClienteId) {
        return false;
      }

      return true;
    }).toList();
  }

  Map<String, List<Actividade>> _groupByPeriod() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final thisMonthStart = DateTime(now.year, now.month, 1);

    final Map<String, List<Actividade>> groups = {
      'Hoy': [],
      'Esta Semana': [],
      'Este Mes': [],
      'Más Antiguas': [],
    };

    for (final task in _filteredTasks) {
      final taskDate = DateTime(
        task.fechaInicio.year,
        task.fechaInicio.month,
        task.fechaInicio.day,
      );

      if (taskDate.isAtSameMomentAs(today)) {
        groups['Hoy']!.add(task);
      } else if (taskDate.isAfter(thisWeekStart) ||
          taskDate.isAtSameMomentAs(thisWeekStart)) {
        groups['Esta Semana']!.add(task);
      } else if (taskDate.isAfter(thisMonthStart) ||
          taskDate.isAtSameMomentAs(thisMonthStart)) {
        groups['Este Mes']!.add(task);
      } else {
        groups['Más Antiguas']!.add(task);
      }
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupedTasks = _groupByPeriod();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(
        DesignTokens.space24,
      ), // Más margen externo
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: GlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(
              DesignTokens.space32,
            ), // Más padding interno
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),
                const SizedBox(height: DesignTokens.space24),
                _buildSearchAndFilters(isDark), // Nuevos filtros
                const SizedBox(height: DesignTokens.space24),
                _buildTasksList(groupedTasks, isDark),
              ],
            ),
          ),
        ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: DesignTokens.safeGreen,
          size: 32,
        ),
        const SizedBox(width: DesignTokens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tareas Completadas',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_filteredTasks.length} tareas encontradas',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize14,
                  color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: isDark ? Colors.white : Color(0xFF111827),
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buscador
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Buscar tareas completadas...',
            prefixIcon: Icon(Icons.search_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        const SizedBox(height: DesignTokens.space16),
        // Filters
        Wrap(
          spacing: DesignTokens.space8,
          runSpacing: DesignTokens.space8,
          children: [
            _buildFilterChip(
              'Plataforma',
              _selectedPlataforma,
              ['TikTok', 'Instagram', 'Facebook', 'YouTube'],
              (value) => setState(
                () => _selectedPlataforma = value == _selectedPlataforma
                    ? null
                    : value,
              ),
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
                setState(
                  () => _selectedClienteId = _selectedClienteId == cliente.id
                      ? null
                      : cliente.id,
                );
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
              (value) => setState(
                () => _selectedTipo = value == _selectedTipo ? null : value,
              ),
              isDark,
              icon: Icons.category_rounded,
            ),
            // Botón Limpiar (Rojo)
            if (_selectedPlataforma != null ||
                _selectedTipo != null ||
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
                    _selectedClienteId = null;
                    _searchQuery = '';
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

  Widget _buildTasksList(
    Map<String, List<Actividade>> groupedTasks,
    bool isDark,
  ) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: DesignTokens.cyanNeon),
      );
    }
    if (_filteredTasks.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return Expanded(
      child: ListView.builder(
        itemCount: groupedTasks.length,
        itemBuilder: (context, index) {
          final period = groupedTasks.keys.elementAt(index);
          final tasks = groupedTasks[period]!;
          return _buildGroupSection(period, tasks, isDark);
        },
      ),
    );
  }

  Widget _buildGroupSection(
    String period,
    List<Actividade> tasks,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header del grupo
        Padding(
          padding: const EdgeInsets.only(
            bottom: DesignTokens.space12,
            top: DesignTokens.space8,
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: DesignTokens.cyanNeon,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: DesignTokens.space8),
              Text(
                period,
                style: TextStyle(
                  fontSize: DesignTokens.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              const SizedBox(width: DesignTokens.space8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: DesignTokens.cyanNeon.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tasks.length}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.cyanNeon,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Tareas del grupo
        ...tasks.map((task) => _buildCompletedTaskCard(task, isDark)),
        const SizedBox(height: DesignTokens.space16),
      ],
    );
  }

  Widget _buildCompletedTaskCard(Actividade task, bool isDark) {
    // Generar color consistente basado en el ID del cliente (mismo que en listado principal)
    final clientColor =
        Colors.primaries[(task.clienteId ?? 0) % Colors.primaries.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space12),
      child: GlassCard(
        child: Row(
          children: [
            // Barra de color (Ahora color cliente)
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: clientColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: DesignTokens.space12),
            // Check icon
            Icon(Icons.check_circle, color: DesignTokens.safeGreen, size: 24),
            const SizedBox(width: DesignTokens.space12),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.nombreActividad,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: isDark
                            ? DesignTokens.meteorGray
                            : Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateHelpers.formatDate(task.fechaInicio),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSize12,
                          color: isDark
                              ? DesignTokens.meteorGray
                              : Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ActivityTypeHelper.getTypeColor(
                            task.tipo,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.tipo,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSize10,
                            color: ActivityTypeHelper.getTypeColor(task.tipo),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón para restaurar (volver a pendiente)
            IconButton(
              icon: Icon(Icons.undo_rounded, color: DesignTokens.meteorGray),
              tooltip: 'Marcar como pendiente',
              onPressed: () async {
                final db = Provider.of<AppDatabase>(context, listen: false);
                final updatedTask = task.copyWith(
                  estado: 'Pendiente',
                  completada: false,
                );
                await db.actualizarActividad(updatedTask);
                _loadCompletedTasks();
              },
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
            Icons.task_alt_rounded,
            size: 80,
            color: DesignTokens.meteorGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DesignTokens.space16),
          Text(
            'No hay tareas completadas',
            style: TextStyle(
              fontSize: DesignTokens.fontSize18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            _searchQuery.isNotEmpty
                ? 'No se encontraron resultados'
                : 'Completa tus primeras tareas',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
