import 'package:intl/intl.dart';

/// Format currency (Brazilian Real)
String formatCurrency(double value) {
  final formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );
  return formatter.format(value);
}

/// Format percentage
String formatPercentage(double value) {
  return '${value.toStringAsFixed(2)}%';
}

/// Format large numbers with abbreviations
String formatLargeNumber(double value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)}B';
  } else if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(2)}K';
  }
  return value.toStringAsFixed(2);
}
