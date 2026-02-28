import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // l10n removed

    return AlertDialog(
      title: Text("infoTitle"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("infoDescription"),
            const SizedBox(height: 16),
            _buildCategoryRow(context, '< 18.5', "underweight", Colors.blue),
            _buildCategoryRow(
              context,
              '18.5 - 24.9',
              "normal",
              Colors.green,
            ),
            _buildCategoryRow(
              context,
              '25.0 - 29.9',
              "overweight",
              Colors.orange,
            ),
            _buildCategoryRow(
              context,
              '30.0 - 34.9',
              "obesity1",
              Colors.deepOrange,
            ),
            _buildCategoryRow(
              context,
              '35.0 - 39.9',
              "obesity2",
              Colors.red,
            ),
            _buildCategoryRow(
              context,
              '> 40.0',
              "obesity3",
              Colors.red.shade900,
            ),
            const SizedBox(height: 16),
            Text(
              "source",
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        FutureBuilder(
          future: ConsentService.privacyOptionsRequirementStatus(),
          builder: (context, snapshot) {
            final status = snapshot.data;
            if (status != PrivacyOptionsRequirementStatus.required) {
              return const SizedBox.shrink();
            }

            return TextButton(
              onPressed: () async {
                await ConsentService.showPrivacyOptionsForm();
              },
              child: const Text('Privacy options'),
            );
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    String range,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$range: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
