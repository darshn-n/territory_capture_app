import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture_app/core/utils/area_calculator.dart';
import 'package:territory_capture_app/core/utils/location_helper.dart';
import 'package:territory_capture_app/domain/entities/lat_lng_timestamp.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/usecases/save_territory.dart';
import 'package:territory_capture_app/presentation/controllers/auth_controller.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

enum CaptureState { idle, capturing, paused }

class CaptureController extends GetxController {
  final SaveTerritoryUseCase saveTerritoryUseCase;

  CaptureController() : saveTerritoryUseCase = Get.find();

  final Rx<CaptureState> state = CaptureState.idle.obs;
  final RxList<LatLngTimestamp> points = <LatLngTimestamp>[].obs;
  final RxDouble distance = 0.0.obs;
  final RxDouble area = 0.0.obs;
  final RxBool isLoading = false.obs;

  Stream<Position>? _positionStream;
  GoogleMapController? mapController;

  @override
  void onClose() {
    _positionStream?.drain();
    mapController?.dispose();
    super.onClose();
  }

  Future<void> startCapture() async {
    final hasPermission = await LocationHelper.checkAndRequestPermission();
    if (!hasPermission) return;

    state.value = CaptureState.capturing;
    points.clear();
    distance.value = 0.0;
    area.value = 0.0;

    _positionStream = LocationHelper.getPositionStream();
    _positionStream!.listen((position) {
      final point = LatLngTimestamp(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      points.add(point);
      _updateCalculations();
      _moveCameraTo(point);
    });
  }

  void pauseCapture() {
    if (state.value != CaptureState.capturing) return;
    state.value = CaptureState.paused;
    _positionStream?.drain();
  }

  void resumeCapture() {
    if (state.value != CaptureState.paused) return;
    state.value = CaptureState.capturing;
    _positionStream = LocationHelper.getPositionStream();
    _positionStream!.listen((position) {
      final point = LatLngTimestamp(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      points.add(point);
      _updateCalculations();
      _moveCameraTo(point);
    });
  }

  void discard() {
    state.value = CaptureState.idle;
    points.clear();
    distance.value = 0.0;
    area.value = 0.0;
    _positionStream?.drain();
  }

  Future<void> finishCapture() async {
    if (points.length < 3) {
      Get.snackbar('Error', 'Need at least 3 points to close polygon');
      return;
    }

    isLoading.value = true;
    final userId = AuthController.to.currentUser!.uid;

    // Close polygon
    if (points.isNotEmpty) points.add(points.first);

    final territory = Territory(
      id: '',
      userId: userId,
      createdAt: DateTime.now(),
      distanceMeters: distance.value,
      areaSqMeters: area.value,
      points: points.toList(),
    );

    final result = await saveTerritoryUseCase(territory);
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to save territory'),
      (_) {
        Get.snackbar('Success', 'Territory saved!');
        Get.offAllNamed(AppRoutes.list);
      },
    );
    isLoading.value = false;
  }

  void _updateCalculations() {
    if (points.length < 2) return;
    distance.value = AreaCalculator.calculateDistance(points);
    area.value = AreaCalculator.calculateArea(points);
  }

  void _moveCameraTo(LatLngTimestamp point) {
    mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(point.latitude, point.longitude)),
    );
  }

  Set<Polyline> getPolylines() {
    if (points.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('capture'),
        color: Colors.indigo,
        width: 5,
        points: points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
      ),
    };
  }

  Set<Polygon> getPolygon() {
    if (points.length < 3) return {};
    return {
      Polygon(
        polygonId: const PolygonId('closed'),
        fillColor: Colors.indigo.withOpacity(0.3),
        strokeColor: Colors.indigo,
        strokeWidth: 3,
        points: points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
      ),
    };
  }
}
