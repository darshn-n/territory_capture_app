import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

class LocationHelper {
  static Future<bool> checkAndRequestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      Get.toNamed(AppRoutes.permissionDenied);
      return false;
    }

    return status.isGranted;
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }
}
