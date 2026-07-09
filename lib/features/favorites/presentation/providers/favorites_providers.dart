import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rutas_amb/core/di/injection_container.dart';
import 'package:rutas_amb/features/routes/domain/entities/route_entity.dart';

final favoritesProvider = FutureProvider<List<RouteEntity>>((ref) {
  return ref.read(favoritesRepositoryProvider).getFavorites();
});

final isFavoriteProvider = FutureProvider.family<bool, String>((ref, routeId) {
  return ref.read(favoritesRepositoryProvider).isFavorite(routeId);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<RouteEntity>>> {
  final Ref _ref;
  FavoritesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final favs = await _ref.read(favoritesRepositoryProvider).getFavorites();
      state = AsyncValue.data(favs);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> toggle(RouteEntity route) async {
    final repo = _ref.read(favoritesRepositoryProvider);
    final isFav = await repo.isFavorite(route.id);
    if (isFav) {
      await repo.removeFavorite(route.id);
    } else {
      await repo.addFavorite(route);
    }
    await _load();
  }

  Future<void> remove(String routeId) async {
    await _ref.read(favoritesRepositoryProvider).removeFavorite(routeId);
    await _load();
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<RouteEntity>>>(
      (ref) => FavoritesNotifier(ref),
    );
