import 'package:get/get.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/usecases/get_user_territories.dart';
import 'package:territory_capture_app/presentation/controllers/auth_controller.dart';

class TerritoryListController extends GetxController {
  final GetUserTerritoriesUseCase getUserTerritories =
      Get.find(); // ← OK now with fenix

  final RxList<Territory> territories = <Territory>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTerritories();
  }

  void _loadTerritories() {
    final userId = AuthController.to.currentUser?.uid;
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    getUserTerritories(userId).listen(
      (data) {
        territories.assignAll(data);
        isLoading.value = false;
      },
      onError: (e) {
        Get.snackbar('Error', 'Failed to load territories');
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    territories.clear();
    super.onClose();
  }
}
