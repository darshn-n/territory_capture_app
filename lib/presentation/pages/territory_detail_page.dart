import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:territory_capture_app/presentation/controllers/territory_detail_controller.dart';

class TerritoryDetailPage extends StatelessWidget {
  const TerritoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TerritoryDetailController>();
    final id = Get.parameters['id']!;

    controller.loadTerritory(id);

    return Scaffold(
      appBar: AppBar(title: const Text('Territory Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.territory.value == null) {
          return const Center(child: Text('Territory not found'));
        }

        final t = controller.territory.value!;
        final points = t.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: points.first,
                  zoom: 15,
                ),
                polygons: {
                  Polygon(
                    polygonId: const PolygonId('territory'),
                    fillColor: Colors.indigo.withOpacity(0.3),
                    strokeColor: Colors.indigo,
                    strokeWidth: 3,
                    points: points,
                  ),
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('path'),
                    color: Colors.red,
                    width: 3,
                    points: points,
                  ),
                },
                onMapCreated: (map) {
                  controller.fitBounds(points);
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance: ${t.distanceMeters.toStringAsFixed(1)} m',
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                    ),
                    Text('Area: ${t.areaSqMeters.toStringAsFixed(1)} m²'),
                    Text(
                      'Captured: ${DateFormat('MMM dd, yyyy HH:mm').format(t.createdAt)}',
                    ),
                    Text('Points: ${t.points.length}'),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
