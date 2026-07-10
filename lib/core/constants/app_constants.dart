/// Constantes generales de la aplicación Rutas AMB
class AppConstants {
  AppConstants._();

  static const String appName = 'Rutas AMB';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Tu guía de transporte en el Área Metropolitana';

  // Área Metropolitana de Bucaramanga – límites geográficos
  static const double ambCenterLat = 7.1198;
  static const double ambCenterLng = -73.1227;
  static const double ambDefaultZoom = 13.0;
  static const double ambDetailZoom = 16.0;

  // Radio de búsqueda de paradas (metros)
  // Nota: los datos mock tienen pocas paradas, se usa 4000m en el provider
  static const int defaultSearchRadiusMeters = 500;
  static const int minSearchRadiusMeters = 200;
  static const int maxSearchRadiusMeters = 5000;

  // Velocidad media del bus (km/h) para estimación de tiempo
  static const double avgBusSpeedKmh = 22.0;

  // Velocidad media caminando (km/h)
  static const double walkingSpeedKmh = 4.5;

  // Tiempo promedio de espera en parada (minutos)
  static const int avgWaitTimeMinutes = 8;

  // Máximo de transbordos permitidos
  static const int maxTransfers = 2;

  // Claves de Hive boxes
  static const String favoritesBoxName = 'favorites_box';
  static const String historyBoxName = 'history_box';
  static const String settingsBoxName = 'settings_box';
  static const String routesCacheBoxName = 'routes_cache_box';

  // Duración del caché de rutas
  static const Duration routesCacheDuration = Duration(hours: 24);

  // Máximo de elementos en historial
  static const int maxHistoryItems = 50;
}
