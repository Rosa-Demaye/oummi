import 'package:flutter/material.dart';

class AppColors {
  // Primary - OUMI Identity
  static const Color primary = Color(0xFFE986A7); // Soft Rose
  
  // Secondary - Medical Trust
  static const Color secondary = Color(0xFF4A90E2); // Medical Blue
  static const Color secondaryLight = Color(0xFF6AA8FF); // Dashboard Gradient End
  
  // Accent - Wellness & Community
  static const Color accent = Color(0xFFC7B6FF); // Soft Lavender
  static const Color accentLight = Color(0xFFFFC3D6); // Pregnancy Gradient End
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Healthy Green
  static const Color warning = Color(0xFFFFB547); // Warm Orange
  static const Color error = Color(0xFFF25F5C); // Soft Coral Red
  
  // Neutral Colors
  static const Color background = Color(0xFFFFF9FB); // Warm White
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF24324B); // Dark Navy
  static const Color textSecondary = Color(0xFF6B7280);
  
  // Gradients
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, accent],
  );

  static const LinearGradient dashboardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient pregnancyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accentLight],
  );
}
