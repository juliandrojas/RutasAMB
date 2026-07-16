// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS – Provider de Filtro por Empresa de Transporte
//
// Responsabilidades:
//   • Carga el estado guardado de SharedPreferences al inicializar.
//   • Expone un Map<String, bool> donde la clave es el nombre de la empresa
//     y el valor indica si está activa (true) o desactivada (false).
//   • Persiste cualquier cambio de forma asíncrona y reactiva.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Clave de SharedPreferences ────────────────────────────────────────────────
const _kCompanyFilterKey = 'company_filter_map';

/// Lista canónica de empresas conocidas en el AMB.
/// Se usa para pre-poblar el filtro cuando el usuario no tiene preferencias
/// guardadas aún, garantizando que todas estén activas por defecto.
const List<String> kKnownCompanies = [
  'Unitransa',
  'Cotrander',
  'Lusitania',
  'San Juan',
  'Flota Cacique',
];

// ─────────────────────────────────────────────────────────────────────────────
// STATE NOTIFIER
// ─────────────────────────────────────────────────────────────────────────────

/// Estado del filtro: un mapa inmutable empresa→activa.
///
/// Ejemplo de estado:
/// ```dart
/// {
///   'Unitransa':     true,
///   'Cotrander':     false,
///   'Lusitania':     true,
///   'San Juan':      true,
///   'Flota Cacique': true,
/// }
/// ```
class CompanyFilterNotifier extends StateNotifier<Map<String, bool>> {
  CompanyFilterNotifier() : super(const {}) {
    _load();
  }

  // ── Carga desde SharedPreferences ────────────────────────────────────────
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCompanyFilterKey);

    if (raw == null) {
      // Primera vez: todas las empresas activas por defecto.
      state = {for (final c in kKnownCompanies) c: true};
      return;
    }

    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final saved = decoded.map((k, v) => MapEntry(k, v as bool));

      // Combina con la lista canónica para que las empresas nuevas
      // que se añadan en el futuro aparezcan activas automáticamente.
      final merged = {for (final c in kKnownCompanies) c: true};
      merged.addAll(saved);
      state = Map.unmodifiable(merged);
    } catch (_) {
      // JSON corrupto → reinicia con todo activo.
      state = {for (final c in kKnownCompanies) c: true};
    }
  }

  // ── Persistencia ──────────────────────────────────────────────────────────
  Future<void> _save(Map<String, bool> newState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCompanyFilterKey, json.encode(newState));
  }

  // ── API pública ───────────────────────────────────────────────────────────

  /// Invierte el estado de activación de [company].
  Future<void> toggle(String company) async {
    final current = state[company] ?? true;
    final next = Map<String, bool>.from(state)..[company] = !current;
    state = Map.unmodifiable(next);
    await _save(state);
  }

  /// Establece el valor de [company] directamente.
  Future<void> setValue(String company, {required bool enabled}) async {
    if (state[company] == enabled) return;
    final next = Map<String, bool>.from(state)..[company] = enabled;
    state = Map.unmodifiable(next);
    await _save(state);
  }

  /// Activa todas las empresas.
  Future<void> enableAll() async {
    final next = state.map((k, _) => MapEntry(k, true));
    state = Map.unmodifiable(next);
    await _save(state);
  }

  /// Desactiva todas las empresas.
  Future<void> disableAll() async {
    final next = state.map((k, _) => MapEntry(k, false));
    state = Map.unmodifiable(next);
    await _save(state);
  }

  // ── Getters de conveniencia ───────────────────────────────────────────────

  /// `true` cuando al menos una empresa está activa.
  bool get hasActiveCompanies => state.values.any((v) => v);

  /// `true` cuando todas las empresas están activas.
  bool get allEnabled => state.values.every((v) => v);
}

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDER GLOBAL
// ─────────────────────────────────────────────────────────────────────────────

/// Provider global del filtro de empresas de transporte.
///
/// Uso desde cualquier widget Riverpod:
/// ```dart
/// // Leer el estado
/// final filterMap = ref.watch(companyFilterProvider);
///
/// // Disparar acciones
/// ref.read(companyFilterProvider.notifier).toggle('Cotrander');
/// ref.read(companyFilterProvider.notifier).enableAll();
/// ```
final companyFilterProvider =
    StateNotifierProvider<CompanyFilterNotifier, Map<String, bool>>(
  (ref) => CompanyFilterNotifier(),
);
