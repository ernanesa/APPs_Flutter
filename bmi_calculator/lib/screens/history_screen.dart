import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/bmi_provider.dart';
import '../logic/bmi_logic.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(bmiHistoryProvider);
    final l10n = AppLocalizations.of(context)!;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noHistory, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        final dateStr = DateFormat.yMMMd().add_Hm().format(entry.date);
        final category = BmiLogic.getCategoryKey(entry.bmi);

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(context, category),
              child: Text(
                entry.bmi.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            title: Text('${entry.weight} kg | ${entry.height} cm'),
            subtitle: Text(dateStr),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                ref.read(bmiHistoryProvider.notifier).deleteEntry(entry.id);
              },
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(BuildContext context, String key) {
    switch (key) {
      case 'underweight':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'overweight':
        return Colors.orange;
      case 'obesity1':
        return Colors.deepOrange;
      case 'obesity2':
        return Colors.red;
      case 'obesity3':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }
}
