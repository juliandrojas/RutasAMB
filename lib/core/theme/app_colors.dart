import 'package:flutter/material.dart';

/// Paleta de colores de Rutas AMB – Material 3
class AppColors {
  AppColors._();

  // ── Primario: Azul institucional AMB ──────────────────────────────
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryContainer = Color(0xFFD6E4FF);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF001848);

  // ── Secundario: Verde naturaleza ───────────────────────────────────
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryContainer = Color(0xFFB8F0BA);
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF002106);

  // ── Terciario: Ámbar (advertencias / transbordos) ──────────────────
  static const Color tertiary = Color(0xFFE65100);
  static const Color tertiaryContainer = Color(0xFFFFDBC9);
  static const Color onTertiary = Colors.white;

  // ── Error ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFB3261E);
  static const Color errorContainer = Color(0xFFF9DEDC);

  // ── Superficies Modo Claro ─────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF8F9FF);
  static const Color surfaceVariantLight = Color(0xFFE1E5F5);
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color onSurfaceLight = Color(0xFF1A1C22);
  static const Color outlineLight = Color(0xFF74777F);

  // ── Superficies Modo Oscuro ────────────────────────────────────────
  static const Color primaryDark = Color(0xFFADC8FF);
  static const Color primaryContainerDark = Color(0xFF0046A3);
  static const Color secondaryDark = Color(0xFF8EDB93);
  static const Color secondaryContainerDark = Color(0xFF005315);
  static const Color surfaceDark = Color(0xFF111318);
  static const Color surfaceVariantDark = Color(0xFF43474E);
  static const Color backgroundDark = Color(0xFF111318);
  static const Color onSurfaceDark = Color(0xFFE2E2E9);
  static const Color outlineDark = Color(0xFF8D9199);

  // ── Colores semánticos del mapa ────────────────────────────────────
  static const Color mapRouteColor = Color(0xFF1565C0);
  static const Color mapWalkingColor = Color(0xFF757575);
  static const Color mapBoardingColor = Color(0xFF2E7D32);
  static const Color mapAlightingColor = Color(0xFFB71C1C);
  static const Color mapTransferColor = Color(0xFFE65100);

  // ── Gradientes ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF1B5E20)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
