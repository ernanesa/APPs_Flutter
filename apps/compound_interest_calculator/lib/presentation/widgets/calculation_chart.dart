import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/calculation.dart';
import '../../utils/formatters.dart';

class CalculationChart extends StatelessWidget {
  final List<MonthlyData> monthlyData;

  const CalculationChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppBar(
          title: Text(l10n.growthChart),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      context,
                      Colors.grey,
                      l10n.totalContributed,
                    ),
                    const SizedBox(width: 24),
                    _buildLegendItem(context, Colors.green, l10n.totalAmount),
                  ],
                ),
                const SizedBox(height: 24),

                // Chart
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _calculateInterval(),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                formatLargeNumber(value),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: _calculateMonthInterval(),
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() %
                                      _calculateMonthInterval().toInt() ==
                                  0) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        // Contributions line (grey)
                        LineChartBarData(
                          spots: monthlyData
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                  e.key.toDouble(),
                                  e.value.totalInvested,
                                ),
                              )
                              .toList(),
                          isCurved: true,
                          color: Colors.grey,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        // Total amount line (green)
                        LineChartBarData(
                          spots: monthlyData
                              .asMap()
                              .entries
                              .map(
                                (e) =>
                                    FlSpot(e.key.toDouble(), e.value.balance),
                              )
                              .toList(),
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (spots) {
                            return spots.map((spot) {
                              final month = spot.x.toInt();
                              final value = spot.y;
                              return LineTooltipItem(
                                '${l10n.month} $month\n${formatCurrency(value)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  double _calculateInterval() {
    if (monthlyData.isEmpty) return 1000;
    final maxValue = monthlyData.last.balance;
    if (maxValue > 100000) return 50000;
    if (maxValue > 10000) return 5000;
    return 1000;
  }

  double _calculateMonthInterval() {
    final totalMonths = monthlyData.length;
    if (totalMonths > 120) return 24;
    if (totalMonths > 60) return 12;
    return 6;
  }
}
