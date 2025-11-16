import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/territory_list_controller.dart';
import 'package:territory_capture_app/presentation/widgets/territory_list_tile.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

class TerritoryListPage extends StatelessWidget {
  const TerritoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TerritoryListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Territories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Get.toNamed('/capture'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.territories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No territories yet. Start capturing!',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.capture),
                  icon: const Icon(Icons.add),
                  label: const Text('Start Capture'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          // Pull-to-refresh bonus
          onRefresh: () async => controller.loadTerritories(),
          child: ListView.builder(
            itemCount: controller.territories.length,
            itemBuilder: (context, index) {
              final territory = controller.territories[index];
              return TerritoryListTile(territory: territory);
            },
          ),
        );
      }),
    );
  }
}
