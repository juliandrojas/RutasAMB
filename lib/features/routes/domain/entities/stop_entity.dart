class StopEntity {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String? address;

  const StopEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.address,
  });
}
