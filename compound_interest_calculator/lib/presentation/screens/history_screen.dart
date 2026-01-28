import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';
import '../../utils/formatters.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calculationHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearAllDialog(context, ref, l10n),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (calculations) {
          if (calculations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noCalculationsYet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.calculateNow),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: calculations.length,
            itemBuilder: (context, index) {
              final calc = calculations[index];
              final date = DateFormat.yMd().format(calc.timestamp);
              final percentageGain = ((calc.totalAmount - calc.totalContributed) / 
                  calc.totalContributed * 100);

              return Dismissible(
                key: Key(calc.timestamp.toIso8601String()),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDelete(context, l10n),
                onDismissed: (_) {
                  ref.read(historyProvider.notifier).deleteCalculation(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.calculationDeleted)),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    title: Text(
                      calc.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '$date • ${calc.annualRate}% • ${calc.months} ${l10n.months}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(calc.totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '+${percentageGain.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: percentageGain > 10 ? Colors.green : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _showCalculationDetails(context, l10n, calc),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('${l10n.error}: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.calculate),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteCalculationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllHistory),
        content: Text(l10n.clearAllHistoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.historyCleared)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }

  void _showCalculationDetails(
    BuildContext context,
    AppLocalizations l10n,
    dynamic calc,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(calc.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(l10n.initialCapital, formatCurrency(calc.principal)),
            _buildDetailRow(l10n.interestRate, '${calc.annualRate}%'),
            _buildDetailRow(l10n.months, '${calc.months}'),
            _buildDetailRow(l10n.monthlyContribution, formatCurrency(calc.monthlyContribution)),
            const Divider(),
            _buildDetailRow(l10n.totalAmount, formatCurrency(calc.totalAmount)),
            _buildDetailRow(l10n.totalInterest, formatCurrency(calc.totalInterest)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
