import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/calculation.dart';
import '../../utils/formatters.dart';
import 'calculation_chart.dart';

class ResultCard extends StatelessWidget {
  final Calculation calculation;
  final VoidCallback? onSave;

  const ResultCard({
    super.key,
    required this.calculation,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    final percentageGain = ((calculation.totalAmount - calculation.totalContributed) / 
        calculation.totalContributed * 100);
    final gainColor = percentageGain > 10 ? Colors.green : Colors.orange;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.totalAmount,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency(calculation.totalAmount),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              l10n.totalContributed,
              formatCurrency(calculation.totalContributed),
              theme,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              l10n.totalInterest,
              formatCurrency(calculation.totalInterest),
              theme,
              valueColor: Colors.green[700],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              l10n.percentageGain,
              '${percentageGain.toStringAsFixed(1)}%',
              theme,
              valueColor: gainColor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: CalculationChart(
                              monthlyData: calculation.monthlyBreakdown,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.show_chart),
                    label: Text(l10n.viewChart),
                  ),
                ),
                if (onSave != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSave,
                      icon: const Icon(Icons.save),
                      label: Text(l10n.save),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeData theme, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
