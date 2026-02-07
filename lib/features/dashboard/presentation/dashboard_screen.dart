import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/quick_access_buttons.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/date_helpers.dart';

/// Pantalla principal - Dashboard con KPIs, gráficos y widgets interactivos
class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Stats calculadas
  int totalActividades = 0;
  int actividadesPendientes = 0;
  int actividadesCompletadas = 0;
  int totalClientes = 0;
  List<Actividade> tareasUrgentes = []; // Tareas de los próximos 7 días
  Map<String, int> actividadesPorDia = {}; // "dd-MM-yyyy": count
  Map<int, int> actividadesPorDiaSemana = {}; // 0 (Mon) -> 6 (Sun): count
  Map<int, double> earningsData = {}; // día del mes -> ganancia acumulada
  String _nombreEmpresa = 'MeLA Node';

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = Provider.of<AppDatabase>(context, listen: false);

    final todasActividades = await db.obtenerTodasLasActividades();
    final pending = await db.obtenerActividadesNoCompletadas();
    final completed = await db.obtenerActividadesCompletadas();
    final clientes = await db.obtenerTodosLosClientes();
    final config = await db.obtenerConfiguracionEmpresa();

    setState(() {
      totalActividades = todasActividades.length;
      actividadesPendientes = pending.length;
      actividadesCompletadas = completed.length;
      totalClientes = clientes.length;
      if (config != null && config.nombreEmpresa.isNotEmpty) {
        _nombreEmpresa = config.nombreEmpresa;
      }

      // Filtrar tareas de los próximos 7 días (no completadas)
      final hoy = DateTime.now();
      final proximosDias = hoy.add(Duration(days: 7));
      tareasUrgentes = todasActividades
          .where((tarea) {
            final fechaReferencia = tarea.fechaPublicado ?? tarea.fechaInicio;
            return !tarea.completada &&
                fechaReferencia.isAfter(hoy.subtract(Duration(days: 1))) &&
                fechaReferencia.isBefore(proximosDias);
          })
          .take(3)
          .toList();

      // Agrupar actividades por día para el mini calendario
      final Map<String, int> tempMap = {};
      for (var act in pending) {
        final fechaReferencia = act.fechaPublicado ?? act.fechaInicio;
        final key =
            '${fechaReferencia.day}-${fechaReferencia.month}-${fechaReferencia.year}';
        tempMap[key] = (tempMap[key] ?? 0) + 1;
      }
      actividadesPorDia = tempMap;

      // Agrupar por día de la semana para el gráfico
      final Map<int, int> tempWeekMap = {
        0: 0,
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
      };

      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);
      final endOfWeek = startOfWeek.add(Duration(days: 7));

      for (var act in todasActividades) {
        if (act.fechaInicio.isAfter(
              startOfWeek.subtract(Duration(seconds: 1)),
            ) &&
            act.fechaInicio.isBefore(endOfWeek)) {
          final dayIndex = act.fechaInicio.weekday - 1;
          tempWeekMap[dayIndex] = (tempWeekMap[dayIndex] ?? 0) + 1;
        }
      }
      actividadesPorDiaSemana = tempWeekMap;

      _calculateEarnings(todasActividades);
    });
  }

  void _calculateEarnings(List<Actividade> actividades) {
    final now = DateTime.now();
    final primerDiaMes = DateTime(now.year, now.month, 1);
    final ultimoDiaMes = DateTime(now.year, now.month + 1, 0);

    final actividadesDelMes = actividades.where((a) {
      return a.completada && // Solo contar completadas para ganancias reales
          a.fechaInicio.isAfter(
            primerDiaMes.subtract(const Duration(days: 1)),
          ) &&
          a.fechaInicio.isBefore(ultimoDiaMes.add(const Duration(days: 1)));
    }).toList();

    // Agrupar ganancias por día (diario)
    final Map<int, double> dailyEarnings = {};

    // Inicializar todos los días del mes hasta hoy
    for (int i = 1; i <= now.day; i++) {
      dailyEarnings[i] = 0.0;
    }

    for (final actividad in actividadesDelMes) {
      final fechaReferencia = actividad.fechaPublicado ?? actividad.fechaInicio;
      // Solo contar si es del mes actual
      if (fechaReferencia.month == now.month &&
          fechaReferencia.year == now.year) {
        final dia = fechaReferencia.day;
        // Usar precio real de la actividad, default a 0 si es nulo
        dailyEarnings[dia] =
            (dailyEarnings[dia] ?? 0) + (actividad.precio ?? 0.0);
      }
    }

    // Calcular ganancia acumulada
    final Map<int, double> cumulativeEarnings = {};
    double runningTotal = 0.0;

    // Ordenar los días para asegurar la suma correcta
    final sortedDays = dailyEarnings.keys.toList()..sort();

    for (final day in sortedDays) {
      runningTotal += dailyEarnings[day]!;
      cumulativeEarnings[day] = runningTotal;
    }

    earningsData = cumulativeEarnings;
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
            _buildHeader(
              context,
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

            const SizedBox(height: DesignTokens.space32),

            _buildKPIsRow(isDark)
                .animate()
                .fadeIn(delay: 50.ms, duration: 300.ms)
                .slideX(begin: -0.1),

            const SizedBox(height: DesignTokens.space32),

            QuickAccessButtons(
                  isDark: isDark,
                  onTaskCreated: _loadStats,
                  onClientCreated: _loadStats,
                )
                .animate()
                .fadeIn(delay: 75.ms, duration: 300.ms)
                .scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: DesignTokens.space32),

            // Gráficos y Widgets
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildTasksChart(isDark)
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 300.ms)
                          .scale(begin: const Offset(0.9, 0.9)),
                      const SizedBox(height: DesignTokens.space24),
                      _buildEarningsChart(isDark)
                          .animate()
                          .fadeIn(delay: 125.ms, duration: 300.ms)
                          .scale(begin: const Offset(0.9, 0.9)),
                    ],
                  ),
                ),

                const SizedBox(width: DesignTokens.space24),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildMiniCalendar(isDark)
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 300.ms)
                          .slideX(begin: 0.1),
                      const SizedBox(height: DesignTokens.space24),
                      _buildPendingTasks(isDark)
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 300.ms)
                          .slideX(begin: 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... (Header se mantiene igual) - Restaurando implementación original
  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientContainer(
      height: 200,
      borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¡Bienvenido a PORTEX!',
            style: TextStyle(
              fontSize: DesignTokens.fontSize32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            'Sistema de Gestión de Tareas y Reportes',
            style: TextStyle(
              fontSize: DesignTokens.fontSize16,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : Color(0xFF1F2937).withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: DesignTokens.space12),
          Text(
            '$_nombreEmpresa - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : Color(0xFF374151),
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
            icon: Icons.task_alt_rounded,
            title: 'Total Tareas',
            value: totalActividades.toString(),
            color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            icon: Icons.pending_actions_rounded,
            title: 'Pendientes',
            value: actividadesPendientes.toString(),
            color: DesignTokens.warningYellow,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            icon: Icons.check_circle_rounded,
            title: 'Completadas',
            value: actividadesCompletadas.toString(),
            color: DesignTokens.safeGreen,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            icon: Icons.bar_chart_rounded, // Icono de Reportes
            title: 'Ver Reportes',
            value: 'Reportes',
            color: DesignTokens.purpleNeon,
            isDark: isDark,
            onTap: () {
              // Navegar a la pestaña de reportes (index 5)
              if (widget.onNavigate != null) {
                widget.onNavigate!(5);
              }
            },
            isAction: true,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
    VoidCallback? onTap,
    bool isAction = false,
  }) {
    return GlassCard(
      showGlow: true,
      accentColor: color,
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: DesignTokens.space12),
          isAction
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF111827),
                  ),
                ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart(bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ganancias del Mes',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              Icon(
                Icons.attach_money_rounded,
                color: DesignTokens.safeGreen,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space24),
          SizedBox(
            height: 200,
            child: earningsData.isEmpty
                ? Center(
                    child: Text(
                      "Sin datos de ganancias",
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots:
                              earningsData.entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList()
                                ..sort((a, b) => a.x.compareTo(b.x)),
                          isCurved: true,
                          color: DesignTokens.safeGreen,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: DesignTokens.safeGreen.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) =>
                              isDark ? Colors.grey[800]! : Colors.white,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '\$${spot.y.toStringAsFixed(2)}',
                                TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksChart(bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actividades del Mes',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              Icon(
                Icons.bar_chart_rounded,
                color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        isDark ? const Color(0xFF1E293B) : Colors.white,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY
                            .toInt()
                            .toString(), // Mostrar solo el número entero
                        TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        return Text(
                          days[value.toInt() % 7],
                          style: TextStyle(
                            color: isDark
                                ? DesignTokens.meteorGray
                                : Color(0xFF6B7280),
                            fontSize: DesignTokens.fontSize12,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: isDark
                                ? DesignTokens.meteorGray
                                : Color(0xFF6B7280),
                            fontSize: DesignTokens.fontSize12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _generateBarData(isDark),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.1,
                      ),
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarData(bool isDark) {
    // Usar los datos reales calculados en _loadStats
    // Si el mapa está vacío (inicialización), se mostrarán ceros.

    return List.generate(7, (index) {
      final value = actividadesPorDiaSemana[index]?.toDouble() ?? 0.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            gradient: LinearGradient(
              colors: [
                isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
                DesignTokens.purpleNeon,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 24,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
          ),
        ],
      );
    });
  }

  Widget _buildMiniCalendar(bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximos 7 Días',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              Icon(
                Icons.calendar_today_rounded,
                color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space16),
          ...List.generate(7, (index) {
            final date = DateTime.now().add(Duration(days: index));
            final dateStr = '${date.day}-${date.month}-${date.year}';
            final count = actividadesPorDia[dateStr] ?? 0;

            // Si no hay tareas, color gris tenue
            final urgencyColor = count > 0
                ? DateHelpers.getUrgencyColor(date)
                : (isDark ? DesignTokens.meteorGray : Color(0xFF9CA3AF));

            return _buildCalendarDayItem(date, urgencyColor, count, isDark);
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarDayItem(
    DateTime date,
    Color color,
    int count,
    bool isDark,
  ) {
    final isToday = DateHelpers.daysUntil(date) == 0;
    final hasTasks = count > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space8),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.space12),
        decoration: BoxDecoration(
          color: isToday
              ? color.withValues(alpha: 0.2)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
          border: Border.all(
            color: hasTasks ? color : color.withValues(alpha: 0.3),
            width: isToday ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color.withValues(alpha: hasTasks ? 1.0 : 0.5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: DesignTokens.space12),
            Expanded(
              child: Text(
                DateHelpers.formatDate(date),
                style: TextStyle(
                  fontSize: DesignTokens.fontSize14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isDark ? Colors.white : Color(0xFF1F2937),
                ),
              ),
            ),
            if (count > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.space8,
                  vertical: DesignTokens.space4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                ),
                child: Text(
                  'HOY',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTasks(bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tareas Urgentes',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.space8,
                  vertical: DesignTokens.space4,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.urgentRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                  border: Border.all(color: DesignTokens.urgentRed, width: 1),
                ),
                child: Text(
                  tareasUrgentes.length.toString(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.urgentRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space16),
          // Tareas urgentes desde la BD
          if (tareasUrgentes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DesignTokens.space24,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 48,
                      color: DesignTokens.safeGreen.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: DesignTokens.space12),
                    Text(
                      'Sin tareas urgentes',
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
            )
          else
            ...tareasUrgentes.map((tarea) {
              // Determinar color según tipo
              Color tipoColor = isDark
                  ? DesignTokens.cyanNeon
                  : Color(0xFF0077C2);
              if (tarea.tipo.toLowerCase().contains('video')) {
                tipoColor = DesignTokens.typeVideo;
              } else if (tarea.tipo.toLowerCase().contains('imagen')) {
                tipoColor = DesignTokens.typeImage;
              } else if (tarea.tipo.toLowerCase().contains('campaña')) {
                tipoColor = DesignTokens.typeCampaign;
              } else if (tarea.tipo.toLowerCase().contains('post')) {
                tipoColor = DesignTokens.typePost;
              }

              return _buildTaskItem(
                tarea.nombreActividad,
                tarea.estado,
                tipoColor,
                isDark,
              );
            }),
          const SizedBox(height: DesignTokens.space12),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
              ),
              label: Text(
                'Ver todas',
                style: TextStyle(
                  color: isDark ? DesignTokens.cyanNeon : Color(0xFF0077C2),
                  fontSize: DesignTokens.fontSize14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String status,
    Color typeColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.space4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? DesignTokens.meteorGray : Color(0xFF9CA3AF),
            size: 20,
          ),
        ],
      ),
    );
  }
}
