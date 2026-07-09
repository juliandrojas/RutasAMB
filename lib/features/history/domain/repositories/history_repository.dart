class SearchHistoryEntry {
  final String originName;
  final double originLat;
  final double originLng;
  final String destinationName;
  final double destinationLat;
  final double destinationLng;
  final DateTime timestamp;

  const SearchHistoryEntry({
    required this.originName,
    required this.originLat,
    required this.originLng,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLng,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'originName': originName,
        'originLat': originLat,
        'originLng': originLng,
        'destinationName': destinationName,
        'destinationLat': destinationLat,
        'destinationLng': destinationLng,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SearchHistoryEntry.fromJson(Map<String, dynamic> json) =>
      SearchHistoryEntry(
        originName: json['originName'] as String,
        originLat: (json['originLat'] as num).toDouble(),
        originLng: (json['originLng'] as num).toDouble(),
        destinationName: json['destinationName'] as String,
        destinationLat: (json['destinationLat'] as num).toDouble(),
        destinationLng: (json['destinationLng'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

abstract class HistoryRepository {
  Future<List<SearchHistoryEntry>> getHistory();
  Future<void> addEntry(SearchHistoryEntry entry);
  Future<void> removeEntry(int index);
  Future<void> clearHistory();
}
