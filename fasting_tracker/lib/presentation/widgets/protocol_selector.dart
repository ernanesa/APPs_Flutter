import 'package:flutter/material.dart';
import '../../domain/entities/fasting_protocol.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Protocol selector widget
class ProtocolSelector extends StatelessWidget {
  final FastingProtocol selectedProtocol;
  final ValueChanged<FastingProtocol> onProtocolSelected;
  final bool enabled;

  const ProtocolSelector({
    super.key,
    required this.selectedProtocol,
    required this.onProtocolSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.selectProtocol,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: FastingProtocol.standardProtocols.length,
            itemBuilder: (context, index) {
              final protocol = FastingProtocol.standardProtocols[index];
              final isSelected = protocol.id == selectedProtocol.id;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _ProtocolCard(
                  protocol: protocol,
                  isSelected: isSelected,
                  enabled: enabled,
                  onTap: () => onProtocolSelected(protocol),
                  l10n: l10n,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final FastingProtocol protocol;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _ProtocolCard({
    required this.protocol,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  protocol.icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    protocol.ratioString,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _getProtocolName(protocol.nameKey),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getProtocolName(String nameKey) {
    switch (nameKey) {
      case 'protocol12_12': return l10n.protocol12_12;
      case 'protocol14_10': return l10n.protocol14_10;
      case 'protocol16_8': return l10n.protocol16_8;
      case 'protocol18_6': return l10n.protocol18_6;
      case 'protocol20_4': return l10n.protocol20_4;
      case 'protocol23_1': return l10n.protocol23_1;
      default: return nameKey;
    }
  }
}
