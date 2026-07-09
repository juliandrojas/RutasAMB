import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ── Tipografía base (sobreescrita con Google Fonts en main.dart) ───
  static TextTheme get _textTheme => const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 57),
        displayMedium: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 45),
        displaySmall: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 36),
        headlineLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 32),
        headlineMedium: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 28),
        headlineSmall: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 24),
        titleLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 22),
        titleMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14),
        bodySmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 12),
        labelLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
        labelMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 12),
        labelSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 11),
      );

  // ── Tema Claro ─────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiary,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: const Color(0xFF410E0B),
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      onSurfaceVariant: const Color(0xFF43474E),
      outline: AppColors.outlineLight,
      outlineVariant: const Color(0xFFC3C6CF),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFF303034),
      onInverseSurface: const Color(0xFFF2F0F4),
      inversePrimary: AppColors.primaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.onSurfaceLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: _textTheme.titleLarge?.copyWith(color: AppColors.onSurfaceLight),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F3FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: AppColors.outlineLight, fontFamily: 'Inter'),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 68,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          _textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
      scaffoldBackgroundColor: AppColors.surfaceLight,
    );
  }

  // ── Tema Oscuro ────────────────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF00316B),
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF003910),
      secondaryContainer: AppColors.secondaryContainerDark,
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: const Color(0xFFFFB598),
      onTertiary: const Color(0xFF5C1900),
      tertiaryContainer: const Color(0xFF803A00),
      onTertiaryContainer: const Color(0xFFFFDBC9),
      error: const Color(0xFFF2B8B5),
      onError: const Color(0xFF601410),
      errorContainer: const Color(0xFF8C1D18),
      onErrorContainer: const Color(0xFFF9DEDC),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      onSurfaceVariant: const Color(0xFFC3C7CF),
      outline: AppColors.outlineDark,
      outlineVariant: const Color(0xFF43474E),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFFE2E2E9),
      onInverseSurface: const Color(0xFF303034),
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme.apply(
        bodyColor: AppColors.onSurfaceDark,
        displayColor: AppColors.onSurfaceDark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E2028),
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: _textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E2028),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: AppColors.outlineDark, fontFamily: 'Inter'),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 68,
        backgroundColor: const Color(0xFF1C1D22),
        indicatorColor: AppColors.primaryContainerDark,
        labelTextStyle: WidgetStateProperty.all(
          _textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
      scaffoldBackgroundColor: AppColors.surfaceDark,
    );
  }
}
