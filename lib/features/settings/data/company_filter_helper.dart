// ─────────────────────────────────────────────────────────────────────────────
// HELPER – Filtrado de rutas por empresa activa
//
// Función pura y testeable que recibe la lista completa de rutas y el mapa
// de preferencias de empresas, y devuelve sólo las rutas cuya empresa esté
// marcada como activa.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:rutas_amb/features/routes/domain/entities/route_entity.dart';

/// Filtra [routes] según el mapa [companyFilter].
///
/// Reglas:
/// 1. Si [companyFilter] está vacío, se devuelven **todas** las rutas
///    (safe default: no ocultar nada si las preferencias aún no cargaron).
/// 2. Si la empresa de una ruta no está en [companyFilter], la ruta se
///    considera **activa** (forward-compatible con empresas nuevas).
/// 3. Si la empresa está en el mapa con valor `false`, la ruta se excluye.
///
/// Ejemplo:
/// ```dart
/// final visible = filterRoutesByCompany(
///   routes: allRoutes,
///   companyFilter: {'Unitransa': true, 'Cotrander': false},
/// );
/// // visible contiene todas las rutas excepto las de Cotrander.
/// ```
List<RouteEntity> filterRoutesByCompany({
  required List<RouteEntity> routes,
  required Map<String, bool> companyFilter,
}) {
  // Safe-default: sin preferencias cargadas, muestra todo.
  if (companyFilter.isEmpty) return routes;

  return routes.where((route) {
    // Si la empresa no está en el mapa, se asume activa (nueva empresa).
    return companyFilter[route.company] ?? true;
  }).toList();
}
