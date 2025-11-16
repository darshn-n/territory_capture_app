import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/territory_detail_controller.dart';

class TerritoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TerritoryDetailController());
  }
}
