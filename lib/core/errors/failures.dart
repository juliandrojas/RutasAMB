/// Tipos de fallo desacoplados de la implementación concreta.
/// Las capas de presentación solo conocen [Failure], nunca DioException o errores de Hive.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet. Verifica tu conexión.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor. Intenta más tarde.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso no encontrado.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al leer datos locales.']);
}

class LocationFailure extends Failure {
  const LocationFailure([super.message = 'No se pudo obtener tu ubicación.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permiso de ubicación denegado.']);
}

class NoRoutesFoundFailure extends Failure {
  const NoRoutesFoundFailure(
      [super.message = 'No se encontraron rutas para este trayecto.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocurrió un error inesperado.']);
}
