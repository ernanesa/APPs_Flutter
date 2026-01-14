import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.infoTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.infoDescription),
            const SizedBox(height: 16),
            _buildCategoryRow(context, "< 18.5", l10n.underweight, Colors.blue),
            _buildCategoryRow(
                context, "18.5 - 24.9", l10n.normal, Colors.green),
            _buildCategoryRow(
                context, "25.0 - 29.9", l10n.overweight, Colors.orange),
            _buildCategoryRow(
                context, "30.0 - 34.9", l10n.obesity1, Colors.deepOrange),
            _buildCategoryRow(context, "35.0 - 39.9", l10n.obesity2, Colors.red),
            _buildCategoryRow(
                context, "> 40.0", l10n.obesity3, Colors.red.shade900),
            const SizedBox(height: 16),
            Text(
              l10n.source,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
      BuildContext context, String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$range: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
