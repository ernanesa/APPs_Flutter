import 'package:flutter/material.dart';

/// App theme configuration for BMI
enum AppThemeType {
  forest(Color(0xFF27AE60), Color(0xFF1E8449)),
  ocean(Color(0xFF3498DB), Color(0xFF2980B9)),
  sunset(Color(0xFFE67E22), Color(0xFFD35400)),
  lavender(Color(0xFF9B59B6), Color(0xFF8E44AD)),
  midnight(Color(0xFF2C3E50), Color(0xFF1A252F)),
  rose(Color(0xFFE91E63), Color(0xFFC2185B)),
  mint(Color(0xFF1ABC9C), Color(0xFF16A085)),
  amber(Color(0xFFF39C12), Color(0xFFD68910));

  final Color primaryColor;
  final Color secondaryColor;

  const AppThemeType(this.primaryColor, this.secondaryColor);
}
