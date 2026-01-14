import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';
import '../logic/pomodoro_logic.dart';
import '../providers/timer_provider.dart';

/// Statistics screen showing Pomodoro history.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final weeklyStatsAsync = ref.watch(weeklyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(sessionsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Today's stats card
            _buildTodayCard(context, todayStatsAsync, l10n, theme),
            const SizedBox(height: 16),
            // Weekly chart card
            _buildWeeklyCard(context, weeklyStatsAsync, l10n, theme),
            const SizedBox(height: 16),
            // Weekly summary card
            _buildWeeklySummaryCard(context, weeklyStatsAsync, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayCard(
    BuildContext context,
    AsyncValue<DailyStats> statsAsync,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.todayStats,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            statsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Text(l10n.noSessionsYet),
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.check_circle_outline,
                      value: stats.completedPomodoros.toString(),
                      label: l10n.sessions,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.timer_outlined,
                      value: PomodoroLogic.formatMinutesAsHoursAndMinutes(
                        stats.totalFocusMinutes,
                      ),
                      label: l10n.totalFocusTime,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyCard(
    BuildContext context,
    AsyncValue<WeeklyStats> statsAsync,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.weeklyStats,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            statsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => SizedBox(
                height: 200,
                child: Center(child: Text(l10n.noSessionsYet)),
              ),
              data: (stats) => SizedBox(
                height: 200,
                child: _buildBarChart(context, stats, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard(
    BuildContext context,
    AsyncValue<WeeklyStats> statsAsync,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (stats) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.emoji_events_outlined,
                  value: stats.totalPomodoros.toString(),
                  label: l10n.sessionsCompleted,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: theme.colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.access_time_outlined,
                  value: PomodoroLogic.formatMinutesAsHoursAndMinutes(
                    stats.totalFocusMinutes,
                  ),
                  label: l10n.totalFocusTime,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    WeeklyStats stats,
    ThemeData theme,
  ) {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxY = stats.dailyStats
        .map((d) => d.completedPomodoros.toDouble())
        .reduce((a, b) => a > b ? a : b)
        .clamp(4, 20)
        .toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY + 1,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => theme.colorScheme.inverseSurface,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} sessions',
                TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
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
                final index = value.toInt();
                if (index >= 0 && index < weekDays.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      weekDays[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 2 == 0) {
                  return Text(
                    value.toInt().toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: stats.dailyStats.asMap().entries.map((entry) {
          final index = entry.key;
          final daily = entry.value;
          final isToday = index == DateTime.now().weekday - 1;
          
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: daily.completedPomodoros.toDouble(),
                color: isToday
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.5),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
