import 'package:territory_capture_app/domain/entities/lat_lng_timestamp.dart';

class Territory {
  final String id;
  final String userId;
  final DateTime createdAt;
  final double distanceMeters;
  final double areaSqMeters;
  final List<LatLngTimestamp> points;

  Territory({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.distanceMeters,
    required this.areaSqMeters,
    required this.points,
  });
}
