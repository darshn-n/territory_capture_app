import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture_app/core/utils/location_helper.dart';
import 'package:territory_capture_app/presentation/controllers/capture_controller.dart';
import 'package:territory_capture_app/presentation/widgets/control_button.dart';
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
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Distance & Area
                    Obx(
                      () => Text(
                        'Distance: ${controller.distance.value.toStringAsFixed(1)} m',
                      ),
                    ),
                    Obx(
                      () => Text(
                        'Area: ${controller.area.value.toStringAsFixed(1)} m²',
                      ),
                    ),
                    const SizedBox(height: 12),
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlButton(
                label: 'Start',
                color: Colors.green,
                onPressed: c.startCapture,
              ),
            ],
          );

        case CaptureState.capturing:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ControlButton(
                label: 'Pause',
                color: Colors.orange,
                onPressed: c.pauseCapture,
              ),
              ControlButton(
                label: 'Finish',
                color: Colors.blue,
                onPressed: c.finishCapture,
              ),
              ControlButton(
                label: 'Discard',
                color: Colors.red,
                onPressed: c.discard,
              ),
            ],
          );

        case CaptureState.paused:
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ControlButton(
                label: 'Resume',
                color: Colors.green,
                onPressed: c.resumeCapture,
              ),
              ControlButton(
                label: 'Finish',
                color: Colors.blue,
                onPressed: c.finishCapture,
              ),
              ControlButton(
                label: 'Discard',
                color: Colors.red,
                onPressed: c.discard,
              ),
            ],
          );
      }
    });
  }
}
