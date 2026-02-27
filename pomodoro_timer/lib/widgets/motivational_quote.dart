import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/quote.dart';

/// Widget displaying a random motivational quote.
class MotivationalQuote extends StatefulWidget {
  final bool showRefreshButton;

  const MotivationalQuote({
    super.key,
    this.showRefreshButton = false,
  });

  @override
  State<MotivationalQuote> createState() => _MotivationalQuoteState();
}

class _MotivationalQuoteState extends State<MotivationalQuote> {
  late Quote _currentQuote;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _pickRandomQuote();
  }

  void _pickRandomQuote() {
    setState(() {
      _currentQuote = Quotes.all[_random.nextInt(Quotes.all.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const Spacer(),
              if (widget.showRefreshButton)
                IconButton(
                  onPressed: _pickRandomQuote,
                  icon: Icon(
                    Icons.refresh,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: l10n.newQuote,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getLocalizedText(l10n, _currentQuote.textKey),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— ${_getLocalizedAuthor(l10n, _currentQuote.authorKey)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(AppLocalizations l10n, String key) {
    final Map<String, String> texts = {
      'quote1Text': l10n.quote1Text,
      'quote2Text': l10n.quote2Text,
      'quote3Text': l10n.quote3Text,
      'quote4Text': l10n.quote4Text,
      'quote5Text': l10n.quote5Text,
      'quote6Text': l10n.quote6Text,
      'quote7Text': l10n.quote7Text,
      'quote8Text': l10n.quote8Text,
      'quote9Text': l10n.quote9Text,
      'quote10Text': l10n.quote10Text,
      'quote11Text': l10n.quote11Text,
      'quote12Text': l10n.quote12Text,
      'quote13Text': l10n.quote13Text,
      'quote14Text': l10n.quote14Text,
      'quote15Text': l10n.quote15Text,
    };
    return texts[key] ?? key;
  }

  String _getLocalizedAuthor(AppLocalizations l10n, String key) {
    final Map<String, String> authors = {
      'quote1Author': l10n.quote1Author,
      'quote2Author': l10n.quote2Author,
      'quote3Author': l10n.quote3Author,
      'quote4Author': l10n.quote4Author,
      'quote5Author': l10n.quote5Author,
      'quote6Author': l10n.quote6Author,
      'quote7Author': l10n.quote7Author,
      'quote8Author': l10n.quote8Author,
      'quote9Author': l10n.quote9Author,
      'quote10Author': l10n.quote10Author,
      'quote11Author': l10n.quote11Author,
      'quote12Author': l10n.quote12Author,
      'quote13Author': l10n.quote13Author,
      'quote14Author': l10n.quote14Author,
      'quote15Author': l10n.quote15Author,
    };
    return authors[key] ?? key;
  }
}

/// Compact quote card for session completion.
class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final random = Random();
    final quote = Quotes.all[random.nextInt(Quotes.all.length)];

    return Card(
      elevation: 0,
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              color: theme.colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              _getQuoteText(l10n, quote.textKey),
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '— ${_getQuoteAuthor(l10n, quote.authorKey)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getQuoteText(AppLocalizations l10n, String key) {
    final Map<String, String> texts = {
      'quote1Text': l10n.quote1Text,
      'quote2Text': l10n.quote2Text,
      'quote3Text': l10n.quote3Text,
      'quote4Text': l10n.quote4Text,
      'quote5Text': l10n.quote5Text,
      'quote6Text': l10n.quote6Text,
      'quote7Text': l10n.quote7Text,
      'quote8Text': l10n.quote8Text,
      'quote9Text': l10n.quote9Text,
      'quote10Text': l10n.quote10Text,
      'quote11Text': l10n.quote11Text,
      'quote12Text': l10n.quote12Text,
      'quote13Text': l10n.quote13Text,
      'quote14Text': l10n.quote14Text,
      'quote15Text': l10n.quote15Text,
    };
    return texts[key] ?? key;
  }

  String _getQuoteAuthor(AppLocalizations l10n, String key) {
    final Map<String, String> authors = {
      'quote1Author': l10n.quote1Author,
      'quote2Author': l10n.quote2Author,
      'quote3Author': l10n.quote3Author,
      'quote4Author': l10n.quote4Author,
      'quote5Author': l10n.quote5Author,
      'quote6Author': l10n.quote6Author,
      'quote7Author': l10n.quote7Author,
      'quote8Author': l10n.quote8Author,
      'quote9Author': l10n.quote9Author,
      'quote10Author': l10n.quote10Author,
      'quote11Author': l10n.quote11Author,
      'quote12Author': l10n.quote12Author,
      'quote13Author': l10n.quote13Author,
      'quote14Author': l10n.quote14Author,
      'quote15Author': l10n.quote15Author,
    };
    return authors[key] ?? key;
  }
}
