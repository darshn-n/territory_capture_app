import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/territory_list_controller.dart';

class TerritoryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TerritoryListController(), fenix: true);
  }
}
