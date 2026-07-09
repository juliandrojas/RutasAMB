import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../../routes/domain/entities/route_entity.dart';
import '../../../routes/domain/entities/stop_entity.dart';
import '../../../routes/domain/entities/lat_lng_entity.dart';

class HiveFavoritesRepositoryImpl implements FavoritesRepository {
  static const _key = 'favorites_routes';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<List<RouteEntity>> getFavorites() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => _routeFromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavorite(RouteEntity route) async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    if (raw.any((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m['id'] == route.id;
    })) {
      return;
    }
    raw.add(jsonEncode(_routeToJson(route)));
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<void> removeFavorite(String routeId) async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    raw.removeWhere((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m['id'] == routeId;
    });
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<bool> isFavorite(String routeId) async {
    final favs = await getFavorites();
    return favs.any((r) => r.id == routeId);
  }

  Map<String, dynamic> _routeToJson(RouteEntity r) => {
    'id': r.id,
    'code': r.code,
    'name': r.name,
    'company': r.company,
    'textualRoute': r.textualRoute,
    'frequency': r.frequency,
    'schedule': r.schedule,
    'lengthKm': r.lengthKm,
    'neighborhoods': r.neighborhoods,
    'color': r.color,
    'coordinates': r.coordinates
        .map((c) => {'lat': c.lat, 'lng': c.lng})
        .toList(),
    'stops': r.stops
        .map(
          (s) => {
            'id': s.id,
            'name': s.name,
            'lat': s.lat,
            'lng': s.lng,
            'address': s.address,
          },
        )
        .toList(),
  };

  RouteEntity _routeFromJson(Map<String, dynamic> m) => RouteEntity(
    id: m['id'] as String,
    code: m['code'] as String,
    name: m['name'] as String,
    company: m['company'] as String,
    textualRoute: m['textualRoute'] as String,
    frequency: m['frequency'] as String,
    schedule: m['schedule'] as String,
    lengthKm: (m['lengthKm'] as num).toDouble(),
    neighborhoods: (m['neighborhoods'] as List).cast<String>(),
    color: m['color'] as String?,
    coordinates: (m['coordinates'] as List)
        .map(
          (c) => LatLngEntity(
            lat: (c['lat'] as num).toDouble(),
            lng: (c['lng'] as num).toDouble(),
          ),
        )
        .toList(),
    stops: (m['stops'] as List)
        .map(
          (s) => StopEntity(
            id: s['id'] as String,
            name: s['name'] as String,
            lat: (s['lat'] as num).toDouble(),
            lng: (s['lng'] as num).toDouble(),
            address: s['address'] as String?,
          ),
        )
        .toList(),
  );
}
