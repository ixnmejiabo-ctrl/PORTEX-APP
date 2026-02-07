import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/design_tokens.dart';

/// Widget de gráfico de ganancias mensuales
class EarningsChart extends StatelessWidget {
  final Map<int, double> earningsData; // día del mes -> ganancia
  final bool isDark;

  const EarningsChart({
    super.key,
    required this.earningsData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (earningsData.isEmpty) {
      return _buildEmptyState();
    }

    final spots =
        earningsData.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList()
          ..sort((a, b) => a.x.compareTo(b.x));

    final maxY = earningsData.values.isEmpty
        ? 1000.0
        : earningsData.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.1,
              ),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 5,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: isDark
                          ? DesignTokens.meteorGray
                          : Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return SizedBox.shrink();
                }
                return Text(
                  '\$${(value / 1000).toStringAsFixed(0)}k',
                  style: TextStyle(
                    color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: 31,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                DesignTokens.safeGreen,
                DesignTokens.safeGreen.withValues(alpha: 0.5),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: DesignTokens.safeGreen,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  DesignTokens.safeGreen.withValues(alpha: 0.3),
                  DesignTokens.safeGreen.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Día ${spot.x.toInt()}\n\$${spot.y.toStringAsFixed(2)}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 48,
            color: DesignTokens.meteorGray.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No hay datos de ganancias',
            style: TextStyle(fontSize: 14, color: DesignTokens.meteorGray),
          ),
        ],
      ),
    );
  }
}
