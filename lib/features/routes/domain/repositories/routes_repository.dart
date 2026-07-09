import '../entities/route_entity.dart';
import '../entities/route_result_entity.dart';

/// Contrato del repositorio de rutas.
///
/// La capa de presentación y los casos de uso solo dependen de esta interfaz.
/// Hay dos implementaciones:
///   - [MockRoutesRepositoryImpl] → usa datos JSON locales (activo ahora)
///   - [RemoteRoutesRepositoryImpl] → usa la API REST (Node.js + Express)
///
/// Para cambiar al backend real, solo cambia qué implementación se inyecta
/// en [routesRepositoryProvider] en injection_container.dart.
abstract class RoutesRepository {
  /// Devuelve todas las rutas disponibles.
  Future<List<RouteEntity>> getAllRoutes();

  /// Devuelve el detalle de una ruta por su [id].
  Future<RouteEntity> getRouteById(String id);

  /// Devuelve rutas con paradas cerca de (lat, lng) dentro de [radiusMeters].
  Future<List<RouteEntity>> getNearbyRoutes({
    required double lat,
    required double lng,
    required int radiusMeters,
  });

  /// Ejecuta el algoritmo de búsqueda y retorna los resultados ordenados.
  Future<List<RouteResultEntity>> searchRoutes({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    int radiusMeters = 500,
  });
}
