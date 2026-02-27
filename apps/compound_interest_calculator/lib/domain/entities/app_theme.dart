import 'package:flutter/material.dart';

enum AppThemeType {
  green(Color(0xFF4CAF50), Color(0xFF2E7D32)),
  blue(Color(0xFF2196F3), Color(0xFF1565C0)),
  purple(Color(0xFF9C27B0), Color(0xFF6A1B9A)),
  orange(Color(0xFFFF9800), Color(0xFFF57C00)),
  teal(Color(0xFF009688), Color(0xFF00796B)),
  indigo(Color(0xFF3F51B5), Color(0xFF283593)),
  red(Color(0xFFF44336), Color(0xFFC62828)),
  amber(Color(0xFFFFC107), Color(0xFFFFA000));

  final Color primaryColor;
  final Color secondaryColor;
  const AppThemeType(this.primaryColor, this.secondaryColor);
}
