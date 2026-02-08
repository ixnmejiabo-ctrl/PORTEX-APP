import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/date_helpers.dart';
import 'package:intl/intl.dart';

/// Pantalla de Calendario con vista del mes y tareas
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Actividade> _actividadesDelMes = [];

  @override
  void initState() {
    super.initState();
    _loadActividades();
  }

  Future<void> _loadActividades() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final todas = await db.obtenerTodasLasActividades();

    setState(() {
      _actividadesDelMes = todas.where((act) {
        final fechaRef = act.fechaPublicado ?? act.fechaInicio;
        return fechaRef.month == _selectedDate.month &&
            fechaRef.year == _selectedDate.year;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isMobile ? DesignTokens.space12 : DesignTokens.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(isDark).animate().fadeIn(duration: 200.ms),

            const SizedBox(height: DesignTokens.space32),

            // Selector de mes
            _buildMonthSelector(isDark).animate().fadeIn(delay: 50.ms),

            const SizedBox(height: DesignTokens.space24),

            // Layout Texto: Calendario (Izq) - Lista (Der)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendario (Flex 2)
                Expanded(
                  flex: 2,
                  child: _buildCalendarGrid(
                    isDark,
                  ).animate().fadeIn(delay: 100.ms),
                ),

                const SizedBox(width: DesignTokens.space24),

                // Lista de actividades (Flex 1)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.space16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMedium,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actividades del mes',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSize18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space16),
                        if (_actividadesDelMes.isEmpty)
                          Text(
                            'No hay actividades para este mes',
                            style: TextStyle(
                              color: isDark
                                  ? DesignTokens.meteorGray
                                  : Color(0xFF6B7280),
                            ),
                          )
                        else
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _actividadesDelMes
                                .map((act) => _buildActivityCard(act, isDark))
                                .toList(),
                          ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          color: DesignTokens.cyanNeon,
          size: 32,
        ),
        const SizedBox(width: DesignTokens.space16),
        Text(
          'Calendario de Actividades',
          style: TextStyle(
            fontSize: DesignTokens.fontSize32,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector(bool isDark) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: DesignTokens.cyanNeon,
            ),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month - 1,
                );
              });
              _loadActividades();
            },
          ),
          Text(
            '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}'
                .toUpperCase(),
            style: TextStyle(
              fontSize: DesignTokens.fontSize20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right_rounded,
              color: DesignTokens.cyanNeon,
            ),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + 1,
                );
              });
              _loadActividades();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Actividade actividad, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: DesignTokens.cyanNeon,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: DesignTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actividad.nombreActividad,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(actividad.fechaPublicado ?? actividad.fechaInicio),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize14,
                      color: isDark
                          ? DesignTokens.meteorGray
                          : Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildCalendarGrid(bool isDark) {
    // Calcular días del mes
    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    // Contar actividades por día
    final Map<int, int> actividadesPorDia = {};
    final Map<int, Color> coloresPorDia = {};

    for (final act in _actividadesDelMes) {
      final fechaRef = act.fechaPublicado ?? act.fechaInicio;
      final day = fechaRef.day;
      actividadesPorDia[day] = (actividadesPorDia[day] ?? 0) + 1;

      // Color más urgente del día
      final color = DateHelpers.getUrgencyColor(fechaRef);
      if (!coloresPorDia.containsKey(day)) {
        coloresPorDia[day] = color;
      } else {
        // Priorizar rojo > amarillo > verde
        if (color == DesignTokens.urgentRed) {
          coloresPorDia[day] = color;
        } else if (color == DesignTokens.warningYellow &&
            coloresPorDia[day] != DesignTokens.urgentRed) {
          coloresPorDia[day] = color;
        }
      }
    }

    return GlassCard(
      child: Column(
        children: [
          // Header con total de actividades
          Padding(
            padding: const EdgeInsets.all(DesignTokens.space16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendario del Mes',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF111827),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.cyanNeon.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSmall,
                    ),
                    border: Border.all(color: DesignTokens.cyanNeon, width: 1),
                  ),
                  child: Text(
                    '${_actividadesDelMes.length} actividades',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize14,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.cyanNeon,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Headers de días de semana
          Padding(
            padding: const EdgeInsets.all(DesignTokens.space16),
            child: Row(
              children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSize12,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.cyanNeon,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Grid de días
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space16,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 42, // 6 semanas máximo
              itemBuilder: (context, index) {
                // Calcular día
                final dayOffset =
                    index - (firstWeekday == 7 ? 6 : firstWeekday - 1);
                final day = dayOffset + 1;

                // Validar si el día está en el mes
                if (day < 1 || day > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final tasksCount = actividadesPorDia[day] ?? 0;
                final urgencyColor = coloresPorDia[day];
                final today = DateTime.now();
                final isToday =
                    today.year == _selectedDate.year &&
                    today.month == _selectedDate.month &&
                    today.day == day;

                return _buildCalendarDay(
                  day,
                  tasksCount,
                  urgencyColor,
                  isToday,
                  isDark,
                );
              },
            ),
          ),

          const SizedBox(height: DesignTokens.space16),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(
    int day,
    int tasksCount,
    Color? urgencyColor,
    bool isToday,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: tasksCount > 0 ? () => _showDayActivities(day) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? DesignTokens.cyanNeon.withValues(alpha: 0.2)
              : (tasksCount > 0
                    ? urgencyColor!.withValues(alpha: 0.1)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday
                ? DesignTokens.cyanNeon
                : (tasksCount > 0
                      ? urgencyColor!
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1))),
            width: isToday ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontSize: DesignTokens.fontSize14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: tasksCount > 0
                    ? urgencyColor
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.black.withValues(alpha: 0.7)),
              ),
            ),
            if (tasksCount > 0) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: urgencyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tasksCount.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDayActivities(int day) {
    final dayActivities = _actividadesDelMes.where((act) {
      final fechaRef = act.fechaPublicado ?? act.fechaInicio;
      return fechaRef.day == day;
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Actividades del $day de ${_getMonthName(_selectedDate.month)}',
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: dayActivities.map((act) {
              final typeColor = ActivityTypeHelper.getTypeColor(act.tipo);

              return ListTile(
                leading: Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                title: Text(act.nombreActividad),
                subtitle: Text('${act.tipo} • ${act.estado}'),
                trailing: Checkbox(
                  value: act.completada,
                  onChanged: (value) async {
                    if (value != null) {
                      final db = Provider.of<AppDatabase>(
                        context,
                        listen: false,
                      );
                      final updated = Actividade(
                        id: act.id,
                        nombreActividad: act.nombreActividad,
                        descripcion: act.descripcion,
                        tipo: act.tipo,
                        estado: act.estado,
                        plataforma: act.plataforma,
                        fechaInicio: act.fechaInicio,
                        fechaPublicado: act.fechaPublicado,
                        clienteId: act.clienteId,
                        nombreClienteManual: act.nombreClienteManual,
                        notas: act.notas,
                        completada: value,
                        synced: false,
                        updatedAt: DateTime.now(),
                        version: act.version + 1,
                      );
                      await db.actualizarActividad(updated);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        _loadActividades();
                      }
                    }
                  },
                  activeColor: DesignTokens.safeGreen,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }
}
