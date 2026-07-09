import '../../../routes/domain/entities/route_entity.dart';

abstract class FavoritesRepository {
  Future<List<RouteEntity>> getFavorites();
  Future<void> addFavorite(RouteEntity route);
  Future<void> removeFavorite(String routeId);
  Future<bool> isFavorite(String routeId);
}
