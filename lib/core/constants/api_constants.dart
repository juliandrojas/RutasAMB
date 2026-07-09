/// Constantes de la API REST
/// ─────────────────────────────────────────────────────────────────
/// Actualmente la app usa MockDatasource (datos locales).
/// Para conectar el backend real (Node.js + Express + PostgreSQL),
/// simplemente actualiza [baseUrl] con la URL del servidor desplegado.
/// No es necesario modificar ninguna otra parte de la aplicación.
/// ─────────────────────────────────────────────────────────────────
class ApiConstants {
  ApiConstants._();

  // ──────────────────────────────────────────
  // CONFIGURACIÓN DEL BACKEND
  // Reemplaza esta URL cuando el backend esté desplegado.
  // Ejemplos:
  //   'http://192.168.1.100:3000'   → desarrollo local en red
  //   'https://api.rutasamb.com'    → producción
  // ──────────────────────────────────────────
  static const String baseUrl = 'http://localhost:3000';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Endpoints REST
  static const String routes = '/routes';
  static const String routesNear = '/routes/near';
  static const String routeSearch = '/route/search';

  /// Construye la URL del detalle de una ruta: GET /routes/{id}
  static String routeDetail(String id) => '/routes/$id';

  // Headers
  static const String contentType = 'application/json';
  static const String acceptHeader = 'application/json';
}
