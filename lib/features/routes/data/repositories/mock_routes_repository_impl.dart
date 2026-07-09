import 'dart:math';
import '../../domain/entities/route_entity.dart';
import '../../domain/entities/route_result_entity.dart';
import '../../domain/entities/stop_entity.dart';
import '../../domain/repositories/routes_repository.dart';
import '../datasources/mock_routes_datasource.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/constants/app_constants.dart';

/// Implementación concreta del repositorio usando el MockDatasource.
///
/// PARA MIGRAR AL BACKEND REAL (Node.js + Express + PostgreSQL):
/// 1. Crea RemoteRoutesRepositoryImpl que inyecta RemoteRoutesDatasource (Dio)
/// 2. En injection_container.dart, cambia routesRepositoryProvider:
///    final routesRepositoryProvider = Provider<RoutesRepository>(
///      (ref) => RemoteRoutesRepositoryImpl(ref.read(dioProvider)),
///    );
/// 3. Este archivo no necesita modificarse.
class MockRoutesRepositoryImpl implements RoutesRepository {
  final RoutesDatasource _datasource;

  MockRoutesRepositoryImpl(this._datasource);

  @override
  Future<List<RouteEntity>> getAllRoutes() => _datasource.getAllRoutes();

  @override
  Future<RouteEntity> getRouteById(String id) => _datasource.getRouteById(id);

  @override
  Future<List<RouteEntity>> getNearbyRoutes({
    required double lat,
    required double lng,
    required int radiusMeters,
  }) async {
    final all = await _datasource.getAllRoutes();
    return all.where((route) {
      return route.stops.any((stop) {
        final d = GeoUtils.distanceMeters(lat, lng, stop.lat, stop.lng);
        return d <= radiusMeters;
      });
    }).toList();
  }

  @override
  Future<List<RouteResultEntity>> searchRoutes({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    int radiusMeters = 500,
  }) async {
    final all = await _datasource.getAllRoutes();
    final results = <RouteResultEntity>[];

    // ── Paso 1: Rutas con paradas cerca del origen ────────────────────
    final routesNearOrigin = <RouteEntity, StopEntity>{};
    for (final route in all) {
      final nearestStop = GeoUtils.nearestStop<StopEntity>(
        originLat,
        originLng,
        route.stops,
        (s) => s.lat,
        (s) => s.lng,
        radiusMeters: radiusMeters.toDouble(),
      );
      if (nearestStop != null) routesNearOrigin[route] = nearestStop;
    }

    // ── Paso 2: Rutas con paradas cerca del destino ───────────────────
    final routesNearDest = <RouteEntity, StopEntity>{};
    for (final route in all) {
      final nearestStop = GeoUtils.nearestStop<StopEntity>(
        destinationLat,
        destinationLng,
        route.stops,
        (s) => s.lat,
        (s) => s.lng,
        radiusMeters: radiusMeters.toDouble(),
      );
      if (nearestStop != null) routesNearDest[route] = nearestStop;
    }

    // ── Paso 3: Rutas DIRECTAS ────────────────────────────────────────
    for (final entry in routesNearOrigin.entries) {
      final route = entry.key;
      final boardStop = entry.value;

      if (routesNearDest.containsKey(route)) {
        final alightStop = routesNearDest[route]!;

        // Validar orden lógico: la parada de abordaje debe venir antes del descenso
        final boardIdx = route.stops.indexWhere((s) => s.id == boardStop.id);
        final alightIdx = route.stops.indexWhere((s) => s.id == alightStop.id);
        if (boardIdx >= alightIdx) continue;

        final walkToBoard = GeoUtils.distanceMeters(
          originLat,
          originLng,
          boardStop.lat,
          boardStop.lng,
        );
        final walkFromAlight = GeoUtils.distanceMeters(
          destinationLat,
          destinationLng,
          alightStop.lat,
          alightStop.lng,
        );
        final busDistKm = _routeSegmentLength(route, boardIdx, alightIdx);
        final busMin = GeoUtils.busMinutes(busDistKm);
        final walkMin =
            GeoUtils.walkingMinutes(walkToBoard) +
            GeoUtils.walkingMinutes(walkFromAlight);
        final totalMin = walkMin + AppConstants.avgWaitTimeMinutes + busMin;

        results.add(
          RouteResultEntity(
            type: RouteResultType.direct,
            primaryRoute: route,
            boardingStop: boardStop,
            finalAlightingStop: alightStop,
            walkToBoarding: walkToBoard,
            walkFromAlighting: walkFromAlight,
            estimatedMinutes: totalMin,
          ),
        );
      }
    }

    // ── Paso 4: UN TRANSBORDO si no hay directas suficientes ──────────
    if (results.length < 3) {
      for (final originEntry in routesNearOrigin.entries) {
        final routeA = originEntry.key;
        final boardStopA = originEntry.value;

        for (final destEntry in routesNearDest.entries) {
          final routeB = destEntry.key;
          final alightStopB = destEntry.value;
          if (routeA.id == routeB.id) continue;

          // Buscar parada de transbordo: parada de B cercana a alguna parada de A
          StopEntity? transferStop;
          StopEntity? transferBoardStop;
          double minTransferDist = double.infinity;

          for (final stopA in routeA.stops) {
            for (final stopB in routeB.stops) {
              final d = GeoUtils.distanceMeters(
                stopA.lat,
                stopA.lng,
                stopB.lat,
                stopB.lng,
              );
              if (d < minTransferDist && d <= 1200) {
                minTransferDist = d;
                transferStop = stopA;
                transferBoardStop = stopB;
              }
            }
          }

          if (transferStop == null || transferBoardStop == null) continue;

          final tStop = transferStop;
          final tBoardStop = transferBoardStop;

          final boardIdxA = routeA.stops.indexWhere(
            (s) => s.id == boardStopA.id,
          );
          final alightIdxA = routeA.stops.indexWhere((s) => s.id == tStop.id);
          final boardIdxB = routeB.stops.indexWhere(
            (s) => s.id == tBoardStop.id,
          );
          final alightIdxB = routeB.stops.indexWhere(
            (s) => s.id == alightStopB.id,
          );

          if (boardIdxA >= alightIdxA || boardIdxB >= alightIdxB) continue;

          final walkToBoard = GeoUtils.distanceMeters(
            originLat,
            originLng,
            boardStopA.lat,
            boardStopA.lng,
          );
          final walkFromAlight = GeoUtils.distanceMeters(
            destinationLat,
            destinationLng,
            alightStopB.lat,
            alightStopB.lng,
          );
          final busDistA = _routeSegmentLength(routeA, boardIdxA, alightIdxA);
          final busDistB = _routeSegmentLength(routeB, boardIdxB, alightIdxB);
          final totalMin =
              GeoUtils.walkingMinutes(walkToBoard) +
              AppConstants.avgWaitTimeMinutes +
              GeoUtils.busMinutes(busDistA) +
              AppConstants.avgWaitTimeMinutes +
              GeoUtils.busMinutes(busDistB) +
              GeoUtils.walkingMinutes(walkFromAlight);

          results.add(
            RouteResultEntity(
              type: RouteResultType.oneTransfer,
              primaryRoute: routeA,
              transferRoute: routeB,
              boardingStop: boardStopA,
              alightingStop: transferStop,
              transferBoardingStop: transferBoardStop,
              finalAlightingStop: alightStopB,
              walkToBoarding: walkToBoard,
              walkFromAlighting: walkFromAlight,
              estimatedMinutes: totalMin,
            ),
          );
        }
      }
    }

    // ── Paso 5: Ordenar resultados ────────────────────────────────────
    results.sort((a, b) {
      // Prioridad: tipo (directo < 1 transbordo < 2 transbordos), luego tiempo
      final typeCmp = a.transferCount.compareTo(b.transferCount);
      if (typeCmp != 0) return typeCmp;
      return a.estimatedMinutes.compareTo(b.estimatedMinutes);
    });

    return results.take(10).toList();
  }

  /// Calcula la longitud en km de un segmento de ruta entre dos índices de paradas.
  double _routeSegmentLength(RouteEntity route, int fromIdx, int toIdx) {
    double total = 0;
    final stops = route.stops;
    for (int i = fromIdx; i < toIdx; i++) {
      total += GeoUtils.distanceKm(
        stops[i].lat,
        stops[i].lng,
        stops[i + 1].lat,
        stops[i + 1].lng,
      );
    }
    return max(total, 0.5); // Mínimo 0.5 km
  }
}
