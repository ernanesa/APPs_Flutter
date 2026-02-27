import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/pomodoro_session.dart';

/// Widget showing the current session type label.
class SessionTypeLabel extends StatelessWidget {
  final SessionType sessionType;
  final Color? color;

  const SessionTypeLabel({
    super.key,
    required this.sessionType,
    this.color,
  });

  String _getLabel(AppLocalizations l10n) {
    switch (sessionType) {
      case SessionType.focus:
        return l10n.focusSession;
      case SessionType.shortBreak:
        return l10n.shortBreak;
      case SessionType.longBreak:
        return l10n.longBreak;
    }
  }

  IconData _getIcon() {
    switch (sessionType) {
      case SessionType.focus:
        return Icons.psychology_outlined;
      case SessionType.shortBreak:
        return Icons.coffee_outlined;
      case SessionType.longBreak:
        return Icons.self_improvement_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final labelColor = color ?? 
        (sessionType == SessionType.focus
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: labelColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 20,
            color: labelColor,
          ),
          const SizedBox(width: 8),
          Text(
            _getLabel(l10n),
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
