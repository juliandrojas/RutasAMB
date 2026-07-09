import 'dart:math';

/// Utilidades geoespaciales para el algoritmo de búsqueda de rutas.
class GeoUtils {
  GeoUtils._();

  static const double _earthRadiusKm = 6371.0;

  /// Calcula la distancia en metros entre dos coordenadas geográficas
  /// usando la fórmula de Haversine.
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c * 1000;
  }

  /// Distancia en kilómetros.
  static double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    return distanceMeters(lat1, lng1, lat2, lng2) / 1000;
  }

  static double _toRad(double deg) => deg * pi / 180;

  /// Tiempo en minutos para caminar [distanceMeters] metros a [speedKmh] km/h.
  static double walkingMinutes(double distanceMeters, {double speedKmh = 4.5}) {
    return (distanceMeters / 1000) / speedKmh * 60;
  }

  /// Tiempo en minutos para un trayecto en bus de [distanceKm] km a [speedKmh].
  static double busMinutes(double distanceKm, {double speedKmh = 22.0}) {
    return distanceKm / speedKmh * 60;
  }

  /// Encuentra la parada más cercana a (lat, lng) dentro de [stops].
  /// Retorna null si no hay paradas dentro de [radiusMeters].
  static T? nearestStop<T>(
    double lat,
    double lng,
    List<T> stops,
    double Function(T) stopLat,
    double Function(T) stopLng, {
    double radiusMeters = 600,
  }) {
    T? nearest;
    double minDist = double.infinity;

    for (final stop in stops) {
      final d = distanceMeters(lat, lng, stopLat(stop), stopLng(stop));
      if (d < minDist && d <= radiusMeters) {
        minDist = d;
        nearest = stop;
      }
    }
    return nearest;
  }

  /// Distancia mínima de un punto a cualquier parada de una lista.
  static double minDistanceToStops<T>(
    double lat,
    double lng,
    List<T> stops,
    double Function(T) stopLat,
    double Function(T) stopLng,
  ) {
    if (stops.isEmpty) return double.infinity;
    return stops
        .map((s) => distanceMeters(lat, lng, stopLat(s), stopLng(s)))
        .reduce(min);
  }
}
