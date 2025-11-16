import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/data/datasources/territory_remote_datasource.dart';
import 'package:territory_capture_app/data/repositories/territory_repository_impl.dart';
import 'package:territory_capture_app/domain/repositories/abstract_territory_repository.dart';
import 'package:territory_capture_app/domain/usecases/get_territory.dart';
import 'package:territory_capture_app/domain/usecases/get_user_territories.dart';
import 'package:territory_capture_app/domain/usecases/save_territory.dart';
import 'package:territory_capture_app/presentation/controllers/auth_controller.dart';
import 'package:territory_capture_app/presentation/controllers/capture_controller.dart';
import 'package:territory_capture_app/presentation/controllers/territory_detail_controller.dart';
import 'package:territory_capture_app/presentation/controllers/territory_list_controller.dart';

class DependencyInjection {
  static void init() {
    // Permanent
    Get.put(AuthController(), permanent: true);

    // Data sources
    Get.lazyPut<TerritoryRemoteDataSource>(
      () => TerritoryRemoteDataSourceImpl(FirebaseFirestore.instance),
      fenix: true, // ← RECREATE ON DEMAND
    );

    // Repositories
    Get.lazyPut<AbstractTerritoryRepository>(
      () => TerritoryRepositoryImpl(Get.find<TerritoryRemoteDataSource>()),
      fenix: true,
    );

    // Use cases — MUST BE fenix: true
    Get.lazyPut(() => SaveTerritoryUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetUserTerritoriesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetTerritoryUseCase(Get.find()), fenix: true);

    // Controllers — lazy + fenix
    Get.lazyPut(() => CaptureController(), fenix: true);
    Get.lazyPut(() => TerritoryListController(), fenix: true);
    Get.lazyPut(() => TerritoryDetailController(), fenix: true);
  }
}
