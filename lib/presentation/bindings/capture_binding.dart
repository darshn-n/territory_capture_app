import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/capture_controller.dart';

class CaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CaptureController());
  }
}
