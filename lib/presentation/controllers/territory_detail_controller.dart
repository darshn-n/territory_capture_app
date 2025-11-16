import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/usecases/get_territory.dart';

class TerritoryDetailController extends GetxController {
  final GetTerritoryUseCase getTerritory;

  TerritoryDetailController() : getTerritory = Get.find();

  final Rx<Territory?> territory = Rx(null);
  final RxBool isLoading = false.obs;
  GoogleMapController? mapController;

  Future<void> loadTerritory(String id) async {
    isLoading.value = true;
    final result = await getTerritory(id);
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to load territory'),
      (t) => territory.value = t,
    );
    isLoading.value = false;
  }

  void fitBounds(List<LatLng> points) {
    if (points.isEmpty || mapController == null) return;
    double south = points[0].latitude, north = points[0].latitude;
    double west = points[0].longitude, east = points[0].longitude;

    for (final p in points) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        50,
      ),
    );
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
