// ─────────────────────────────────────────────────────────────────────────────
// DOMINIO – Entidad principal de ruta de transporte
// ─────────────────────────────────────────────────────────────────────────────

import 'stop_entity.dart';
import 'lat_lng_entity.dart';

class RouteEntity {
  final String id;
  final String code;
  final String name;
  final String company;
  final String textualRoute;
  final List<LatLngEntity> coordinates;
  final String frequency;
  final String schedule;
  final double lengthKm;
  final List<String> neighborhoods;
  final List<StopEntity> stops;
  final String? color; // Color hex para distinguir la ruta en el mapa

  const RouteEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.company,
    required this.textualRoute,
    required this.coordinates,
    required this.frequency,
    required this.schedule,
    required this.lengthKm,
    required this.neighborhoods,
    required this.stops,
    this.color,
  });

  RouteEntity copyWith({
    String? id,
    String? code,
    String? name,
    String? company,
    String? textualRoute,
    List<LatLngEntity>? coordinates,
    String? frequency,
    String? schedule,
    double? lengthKm,
    List<String>? neighborhoods,
    List<StopEntity>? stops,
    String? color,
  }) {
    return RouteEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      company: company ?? this.company,
      textualRoute: textualRoute ?? this.textualRoute,
      coordinates: coordinates ?? this.coordinates,
      frequency: frequency ?? this.frequency,
      schedule: schedule ?? this.schedule,
      lengthKm: lengthKm ?? this.lengthKm,
      neighborhoods: neighborhoods ?? this.neighborhoods,
      stops: stops ?? this.stops,
      color: color ?? this.color,
    );
  }
}
