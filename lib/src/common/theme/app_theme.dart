import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive theme configuration for AutoEase app
/// Implements Material 3 design with automotive-inspired color palette
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== Color Scheme ====================

  // Primary Colors - Deep Midnight Blue (Premium & Trust)
  static const Color _primaryLight = Color(0xFF0D47A1); // Deep Midnight Blue
  static const Color _primaryDark =
      Color(0xFF64B5F6); // Lighter Blue for dark mode

  // Secondary/Accent Colors - Vibrant Amber (Energy & Automotive)
  static const Color _accentLight = Color(0xFFFF6F00); // Deep Amber/Orange
  static const Color _accentDark = Color(0xFFFFB74D);

  // Tertiary Colors - Cool Grey (Technical/Mechanical)
  static const Color _tertiaryLight = Color(0xFF455A64);
  static const Color _tertiaryDark = Color(0xFF90A4AE);

  // Semantic Colors
  static const Color successColor = Color(0xFF2E7D32); // Darker Green
  static const Color warningColor = Color(0xFFED6C02); // Darker Orange
  static const Color errorColor = Color(0xFFC62828); // Darker Red
  static const Color infoColor = Color(0xFF0288D1); // Darker Info Blue

  // Surface Colors
  static const Color _surfaceLight =
      Color(0xFFF5F7FA); // Very light blue-grey tint
  static const Color _surfaceDark = Color(0xFF101216); // Very dark blue-grey

  // ==================== Light Theme ====================

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryLight,
      brightness: Brightness.light,
      primary: _primaryLight,
      onPrimary: Colors.white,
      secondary: _accentLight,
      onSecondary: Colors.white,
      tertiary: _tertiaryLight,
      error: errorColor,
      surface: _surfaceLight,
      surfaceContainerHighest:
          const Color(0xFFE1E6EB), // Slightly darker surface for cards
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
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),

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
      onPrimary: const Color(0xFF00214B),
      secondary: _accentDark,
      onSecondary: const Color(0xFF4D2C00),
      tertiary: _tertiaryDark,
      error: const Color(0xFFEF9A9A),
      surface: _surfaceDark,
      surfaceContainerHighest: const Color(0xFF1E2228),
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
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),

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
        fontWeight: FontWeight.w700,
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
        fontWeight: FontWeight.w600,
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
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
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
      scrolledUnderElevation: 2,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(
      ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(88, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
      ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
        minimumSize: const Size(88, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(10),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

      // Border styles
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
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
        fontWeight: FontWeight.w600,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),

      // Error style
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        color: colorScheme.error,
        fontWeight: FontWeight.w500,
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
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static ChipThemeData _buildChipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor:
          colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      selectedColor: colorScheme.primaryContainer,
      disabledColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onPrimaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 0,
    );
  }

  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      thickness: 1,
      space: 24,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(
      ColorScheme colorScheme) {
    return NavigationBarThemeData(
      height: 72,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.onSecondaryContainer);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant);
      }),
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
