import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/territory_list_controller.dart';
import 'package:territory_capture_app/presentation/widgets/territory_list_tile.dart';

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
          return const Center(
            child: Text('No territories yet. Start capturing!'),
          );
        }

        return ListView.builder(
          itemCount: controller.territories.length,
          itemBuilder: (context, index) {
            final territory = controller.territories[index];
            return TerritoryListTile(territory: territory);
          },
        );
      }),
    );
  }
}
