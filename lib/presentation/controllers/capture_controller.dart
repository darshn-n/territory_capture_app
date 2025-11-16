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
import 'package:territory_capture_app/presentation/controllers/territory_list_controller.dart';
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
      Get.snackbar(
        'Oops',
        'Walk at least 3 points to create a territory',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(strokeWidth: 5, color: Colors.indigo),
      ),
      barrierDismissible: false,
    );

    try {
      final userId = AuthController.to.currentUser!.uid;

      // Ensure polygon is closed
      if (points.isNotEmpty && points.first != points.last) {
        points.add(points.first);
      }

      final territory = Territory(
        id: '',
        userId: userId,
        createdAt: DateTime.now(),
        distanceMeters: distance.value,
        areaSqMeters: area.value,
        points: points.toList(),
      );

      final result = await saveTerritoryUseCase(territory);

      await result.fold(
        (failure) async {
          Get.back();
          Get.snackbar(
            'Failed',
            'Could not save territory. Check internet.',
            backgroundColor: Colors.red.withOpacity(0.9),
            colorText: Colors.white,
          );
        },
        (_) async {
          Get.back();
          Get.snackbar(
            'Success!',
            'Territory captured and saved',
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          await Future.delayed(const Duration(milliseconds: 300));
          Get.offAllNamed(AppRoutes.list);

          if (Get.isRegistered<TerritoryListController>()) {
            Get.find<TerritoryListController>().refresh();
          }
        },
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
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
