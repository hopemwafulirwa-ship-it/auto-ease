import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive theme configuration for AutoEase app
/// Implements Material 3 design with automotive-inspired color palette
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== Color Scheme ====================

  // Primary Colors - Deep Blue (Automotive Professional)
  static const Color _primaryLight = Color(0xFF1565C0); // Deep Blue
  static const Color _primaryDark =
      Color(0xFF42A5F5); // Lighter Blue for dark mode

  // Accent Colors - Amber (Energy & Action)
  static const Color _accentLight = Color(0xFFFFA726); // Warm Orange/Amber
  static const Color _accentDark = Color(0xFFFFB74D);

  // Semantic Colors
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFFA726); // Amber
  static const Color errorColor = Color(0xFFEF5350); // Red
  static const Color infoColor = Color(0xFF42A5F5); // Blue

  // Surface Colors
  static const Color _surfaceLight = Color(0xFFFAFAFA);
  static const Color _surfaceDark = Color(0xFF121212);

  // ==================== Light Theme ====================

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryLight,
      brightness: Brightness.light,
      primary: _primaryLight,
      secondary: _accentLight,
      error: errorColor,
      surface: _surfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      // Typography
      textTheme: _buildTextTheme(colorScheme),

      // Component Themes
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),

      // Visual Properties
      scaffoldBackgroundColor: _surfaceLight,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ==================== Dark Theme ====================

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryDark,
      brightness: Brightness.dark,
      primary: _primaryDark,
      secondary: _accentDark,
      error: errorColor,
      surface: _surfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      // Typography
      textTheme: _buildTextTheme(colorScheme),

      // Component Themes
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),

      // Visual Properties
      scaffoldBackgroundColor: _surfaceDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ==================== Text Theme ====================

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final headingFont = GoogleFonts.outfit();

    return baseTextTheme.copyWith(
      // Display styles (large headers)
      displayLarge: headingFont.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        letterSpacing: -0.25,
      ),
      displayMedium: headingFont.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displaySmall: headingFont.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),

      // Headline styles
      headlineLarge: headingFont.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineMedium: headingFont.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: headingFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      // Title styles
      titleLarge: headingFont.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        letterSpacing: 0.1,
      ),

      // Body styles
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.4,
      ),

      // Label styles
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }

  // ==================== Component Themes ====================

  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(
      ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
      ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(88, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
      ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // Border styles
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),

      // Label and hint styles
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        color: colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),

      // Error style
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        color: colorScheme.error,
      ),

      // Icon theme
      iconColor: colorScheme.onSurfaceVariant,
      prefixIconColor: colorScheme.onSurfaceVariant,
      suffixIconColor: colorScheme.onSurfaceVariant,
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      modalBackgroundColor: colorScheme.surface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static ChipThemeData _buildChipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      disabledColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
    );
  }

  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 16,
    );
  }
}

// ==================== Theme Extensions ====================

/// Extension to access semantic colors from BuildContext
extension ThemeColors on BuildContext {
  Color get successColor => AppTheme.successColor;
  Color get warningColor => AppTheme.warningColor;
  Color get errorColor => AppTheme.errorColor;
  Color get infoColor => AppTheme.infoColor;
}
