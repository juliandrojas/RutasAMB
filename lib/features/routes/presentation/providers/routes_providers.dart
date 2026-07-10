import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/entities/route_result_entity.dart';
import '../../../../core/di/injection_container.dart';

// ── Provider: búsqueda de rutas ───────────────────────────────────────────────
final searchParamsProvider = StateProvider<SearchParams?>((_) => null);

class SearchParams {
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final String originName;
  final String destinationName;

  const SearchParams({
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.originName,
    required this.destinationName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          runtimeType == other.runtimeType &&
          originLat == other.originLat &&
          originLng == other.originLng &&
          destinationLat == other.destinationLat &&
          destinationLng == other.destinationLng &&
          originName == other.originName &&
          destinationName == other.destinationName;

  @override
  int get hashCode =>
      originLat.hashCode ^
      originLng.hashCode ^
      destinationLat.hashCode ^
      destinationLng.hashCode ^
      originName.hashCode ^
      destinationName.hashCode;
}

final routeResultsProvider =
    FutureProvider.family<List<RouteResultEntity>, SearchParams>((
      ref,
      params,
    ) async {
      final repo = ref.read(routesRepositoryProvider);
      return repo.searchRoutes(
        originLat: params.originLat,
        originLng: params.originLng,
        destinationLat: params.destinationLat,
        destinationLng: params.destinationLng,
        radiusMeters: 4000, // radio amplio para cubrir datos mock
      );
    });

// ── Provider: todas las rutas ─────────────────────────────────────────────────
final allRoutesProvider = FutureProvider<List<RouteEntity>>((ref) {
  return ref.read(routesRepositoryProvider).getAllRoutes();
});

// ── Provider: detalle de una ruta ─────────────────────────────────────────────
final routeDetailProvider = FutureProvider.family<RouteEntity, String>((
  ref,
  id,
) {
  return ref.read(routesRepositoryProvider).getRouteById(id);
});

// ── Provider: filtro de resultados ────────────────────────────────────────────
final resultFilterProvider = StateProvider<RouteResultType?>((_) => null);
