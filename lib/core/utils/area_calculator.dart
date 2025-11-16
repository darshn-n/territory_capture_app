import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:territory_capture_app/domain/entities/lat_lng_timestamp.dart';

class AreaCalculator {
  static double calculateArea(List<LatLngTimestamp> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    final radius = 6371000; // Earth radius in meters

    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

      area +=
          p1.longitude *
          pi /
          180 *
          radius *
          radius *
          (sin(p2.latitude * pi / 180) - sin(p1.latitude * pi / 180));
    }

    return area.abs() / 2;
  }

  static double calculateDistance(List<LatLngTimestamp> points) {
    double distance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      distance += Geolocator.distanceBetween(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    return distance;
  }
}
