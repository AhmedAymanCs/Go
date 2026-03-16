import 'dart:ui';

class ColorManager {
  // Primary Colors
  static const Color navyPrimary = Color(0xFF1A1F3C);
  static const Color navyLight = Color(0xFF2A3158);
  static const Color navyDark = Color(0xFF0F1220);
  static const Color greenAccent = Color(0xFF3DD68C);
  static const Color greenLight = Color(0xFF5FE3A1);
  static const Color greenDark = Color(0xFF28B873);
  static const Color greenSoft = Color(0xFFD1F7E7);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1F3C);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0F1220);
  static const Color textAccent = Color(0xFF3DD68C);

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F1220);
  static const Color backgroundNavy = Color(0xFF1A1F3C);
  static const Color backgroundGray = Color(0xFFF1F5F9);
  static const Color backgroundGreen = Color(0xFF28B873);

  // Status Colors
  static const Color success = Color(0xFF3DD68C);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Extra
  static const Color scaffoldBackgroundColor = Color(0xFFF9FAFB);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color slate700 = Color(0xFF374151);
  static const Color divider = Color(0xFFE5E7EB);

  // Aliases
  static const Color primaryColor = ColorManager.navyPrimary;
  static const Color secondaryColor = ColorManager.greenAccent;
  static const Color accentColor = ColorManager.greenLight;
  static const Color darkBackground = ColorManager.backgroundDark;
  static const Color darkSurface = ColorManager.backgroundNavy;
  static const Color darkCard = Color(0xFF232840);
  static const Color lightBackground = ColorManager.backgroundLight;
  static const Color lightSurface = ColorManager.backgroundWhite;
  static const Color lightCard = ColorManager.backgroundWhite;
}
