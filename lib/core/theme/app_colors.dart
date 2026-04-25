import 'package:flutter/material.dart';

class AppColors {
  // Government-style colors inspired by Indian flag and official portals
  static const primary = Color(0xFF0B3D91); // Navy Blue - Trust, Authority
  static const secondary = Color(0xFFFF9933); // Saffron Accent
  static const accentGreen = Color(0xFF138808); // Success Green
  static const accentWhite = Color(0xFFFFFFFF); // White

  // Background colors
  static const background = Color(0xFFF5F7FA); // Light government background
  static const card = Colors.white;
  static const surface = Color(0xFFE8EEF5);

  // Text colors
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textOnPrimary = Colors.white;

  // Border colors
  static const border = Color(0xFFE5E7EB);
  static const borderLight = Color(0xFFF3F4F6);

  // Status colors
  static const success = Color(0xFF138808);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF0B3D91);

  // Category colors
  static const agriculture = Color(0xFF22C55E);
  static const health = Color(0xFFEF4444);
  static const education = Color(0xFF3B82F6);
  static const housing = Color(0xFFF59E0B);
  static const women = Color(0xFFEC4899);
  static const employment = Color(0xFF8B5CF6);
  static const disability = Color(0xFF6B7280);
  static const senior = Color(0xFF64748B);

  // Helper: get category color by key
  static Color forCategory(String category) {
    switch (category) {
      case 'agriculture': return agriculture;
      case 'health': return health;
      case 'education': return education;
      case 'housing': return housing;
      case 'women': return women;
      case 'employment': return employment;
      case 'disability': return disability;
      case 'senior': return senior;
      default: return primary;
    }
  }
}
