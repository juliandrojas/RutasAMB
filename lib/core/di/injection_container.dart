import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/routes/data/datasources/mock_routes_datasource.dart';
import '../../features/routes/data/repositories/mock_routes_repository_impl.dart';
import '../../features/routes/domain/repositories/routes_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// INYECCIÓN DE DEPENDENCIAS CON RIVERPOD
//
// Para cambiar al backend real, modifica SOLO routesRepositoryProvider:
//   final routesRepositoryProvider = Provider<RoutesRepository>(
//     (ref) => RemoteRoutesRepositoryImpl(ref.read(dioClientProvider)),
//   );
// ─────────────────────────────────────────────────────────────────────────────

// ── Datasource ────────────────────────────────────────────────────────────────
final routesDatasourceProvider = Provider<RoutesDatasource>(
  (ref) => MockRoutesDatasource(),
);

// ── Repositorios ──────────────────────────────────────────────────────────────
final routesRepositoryProvider = Provider<RoutesRepository>(
  (ref) => MockRoutesRepositoryImpl(ref.read(routesDatasourceProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => HiveFavoritesRepositoryImpl(),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepositoryImpl(),
);
