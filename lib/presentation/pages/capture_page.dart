import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture_app/core/utils/location_helper.dart';
import 'package:territory_capture_app/presentation/controllers/capture_controller.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

class CapturePage extends StatelessWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaptureController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Territory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Get.toNamed(AppRoutes.list),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            final initialPos = controller.points.isEmpty
                ? const CameraPosition(target: LatLng(20.0, 78.0), zoom: 15)
                : CameraPosition(
                    target: LatLng(
                      controller.points.last.latitude,
                      controller.points.last.longitude,
                    ),
                    zoom: 18,
                  );

            return GoogleMap(
              initialCameraPosition: initialPos,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: controller.getPolylines(),
              polygons: controller.getPolygon(),
              onMapCreated: (map) {
                controller.mapController = map;
                _centerOnUser(map, controller);
              },
            );
          }),
          // ... stats card ...
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.deepPurple[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => Text(
                        'Distance: ${controller.distance.value.toStringAsFixed(1)} m',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        'Area: ${controller.area.value.toStringAsFixed(1)} m²',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildControls(controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnUser(GoogleMapController map, CaptureController c) async {
    final permission = await LocationHelper.checkAndRequestPermission();
    if (!permission) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      map.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          18,
        ),
      );
    } catch (_) {}
  }

  Widget _buildControls(CaptureController c) {
    return Obx(() {
      switch (c.state.value) {
        case CaptureState.idle:
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: c.startCapture,
              icon: const Icon(Icons.play_arrow, size: 28),
              label: Text(
                'START CAPTURE',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          );

        case CaptureState.capturing:
        case CaptureState.paused:
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: c.state.value == CaptureState.capturing
                    ? c.pauseCapture
                    : c.resumeCapture,
                icon: Icon(
                  c.state.value == CaptureState.capturing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                label: Text(
                  c.state.value == CaptureState.capturing ? 'PAUSE' : 'RESUME',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.state.value == CaptureState.capturing
                      ? Colors.orange
                      : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: c.finishCapture,
                icon: const Icon(Icons.flag),
                label: const Text('FINISH'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: c.discard,
                icon: const Icon(Icons.delete),
                label: const Text(
                  'DISCARD',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          );
      }
    });
  }
}
