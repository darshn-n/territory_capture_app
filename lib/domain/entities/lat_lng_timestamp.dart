class LatLngTimestamp {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LatLngTimestamp({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
  };

  factory LatLngTimestamp.fromJson(Map<String, dynamic> json) =>
      LatLngTimestamp(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
