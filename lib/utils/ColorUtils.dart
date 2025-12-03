import 'package:flutter/material.dart';

class ColorUtils {
  static const Color primaryColor = Color(0xFF0F9CF3);
  static const Color accentColor = Color(0xffFF4E00);
  static const Color orangeGradientEnd = Color(0xfffc4a1a);
  static const Color orangeGradientStart = Color(0xfff7b733);
  static const Color themeGradientStart = Color(0xFF8E24AA);
  static const Color themeGradientEnd = Color(0xFFFB8C00);
  /*static const LinearGradient appBarGradient =
  LinearGradient(colors: [themeGradientStart, themeGradientEnd]);*/
  static const Color appBarBackgroundForSignUp = Color(0xFF0F9CF3);
  static const Color button_color = Color(0xFF0F9CF3);
  
  // Volunteer Theme Colors - Modern, Warm & Professional
  static const Color volunteerPrimary = Color(0xFF00897B);  // Teal - caring, fresh
  static const Color volunteerPrimaryLight = Color(0xFF4DB6AC);  // Light Teal
  static const Color volunteerPrimaryDark = Color(0xFF00695C);  // Dark Teal
  static const Color volunteerSecondary = Color(0xFFFF6F00);  // Deep Orange - warm, energy
  static const Color volunteerAccent = Color(0xFF5E35B1);  // Deep Purple - quality
  static const Color volunteerSuccess = Color(0xFF43A047);  // Green
  static const Color volunteerWarning = Color(0xFFFB8C00);  // Amber
  static const Color volunteerError = Color(0xFFE53935);  // Red
  static const Color volunteerInfo = Color(0xFF1976D2);  // Blue
  static const Color volunteerSurface = Color(0xFFF5F7FA);  // Light Gray-Blue
  static const Color volunteerBackground = Color(0xFFFFFFFF);  // White
  static const Color volunteerCardBg = Color(0xFFFFFFFF);  // White
  static const Color volunteerTextPrimary = Color(0xFF2C3E50);  // Dark Gray
  static const Color volunteerTextSecondary = Color(0xFF607D8B);  // Gray
  static const Color volunteerDivider = Color(0xFFE0E0E0);  // Light Gray
  
  // Gradient for volunteer screens
  static const LinearGradient volunteerGradient = LinearGradient(
    colors: [volunteerPrimary, volunteerPrimaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient volunteerAccentGradient = LinearGradient(
    colors: [volunteerSecondary, Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}