import 'route_entity.dart';
import 'stop_entity.dart';

/// Resultado del algoritmo de búsqueda de rutas.
class RouteResultEntity {
  /// Tipo de resultado: directa, 1 transbordo, 2 transbordos
  final RouteResultType type;

  /// Ruta principal (del origen al transbordo o al destino)
  final RouteEntity primaryRoute;

  /// Ruta de transbordo (si aplica)
  final RouteEntity? transferRoute;

  /// Segunda ruta de transbordo (si aplica)
  final RouteEntity? transferRoute2;

  /// Parada donde el usuario aborda la primera ruta
  final StopEntity boardingStop;

  /// Parada donde el usuario desciende del bus (en ruta directa) o hace transbordo
  final StopEntity? alightingStop;

  /// Parada donde aborda la segunda ruta (transbordo)
  final StopEntity? transferBoardingStop;

  /// Parada donde desciende definitivamente
  final StopEntity finalAlightingStop;

  /// Distancia caminando al primer abordaje (metros)
  final double walkToBoarding;

  /// Distancia caminando desde el descenso final al destino (metros)
  final double walkFromAlighting;

  /// Tiempo total estimado en minutos
  final double estimatedMinutes;

  const RouteResultEntity({
    required this.type,
    required this.primaryRoute,
    this.transferRoute,
    this.transferRoute2,
    required this.boardingStop,
    this.alightingStop,
    this.transferBoardingStop,
    required this.finalAlightingStop,
    required this.walkToBoarding,
    required this.walkFromAlighting,
    required this.estimatedMinutes,
  });

  int get transferCount => switch (type) {
        RouteResultType.direct => 0,
        RouteResultType.oneTransfer => 1,
        RouteResultType.twoTransfers => 2,
      };
}

enum RouteResultType { direct, oneTransfer, twoTransfers }
