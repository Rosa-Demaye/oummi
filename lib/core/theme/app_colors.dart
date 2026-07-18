import 'package:flutter/material.dart';

class AppColors {
  // === OUMI BRAND IDENTITY ===
  // Primary - Soft Rose (Feminine screens: Women, Girls)
  static const Color primary = Color(0xFFE986A7);
  static const Color primaryDark = Color(0xFFD4708F);

  // Secondary - Navy Blue (Doctor, Hospital, Father screens)
  static const Color secondary = Color(0xFF0B2B5B);
  static const Color secondaryLight = Color(0xFF1A4A8A);

  // Accent - Gold/Red from Chadian logo
  static const Color accent = Color(0xFFFDBB11);
  static const Color accentRed = Color(0xFFCC232A);

  // Medical Trust
  static const Color medicalBlue = Color(0xFF4A90E2);
  static const Color lavender = Color(0xFFC7B6FF);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFF25F5C);
  static const Color info = Color(0xFF2196F3);

  // Neutral
  static const Color background = Color(0xFFFFF9FB);
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF24324B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Emergency
  static const Color emergency = Color(0xFFDC2626);
  static const Color emergencyBg = Color(0xFFFFF2F2);

  // Role-specific gradients
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, Color(0xFFF5A3B8)],
  );

  static const LinearGradient feminineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, lavender],
  );

  static const LinearGradient medicalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, medicalBlue],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emergency, Color(0xFFFF6B6B)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  // Backward-compatible gradients
  static const LinearGradient dashboardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, medicalBlue],
  );

  static const LinearGradient pregnancyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFFFC3D6)],
  );
}
