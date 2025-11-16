import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

class TerritoryListTile extends StatelessWidget {
  final Territory territory;
  const TerritoryListTile({super.key, required this.territory});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text('Territory #${territory.id.substring(0, 6)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${territory.distanceMeters.toStringAsFixed(1)} m'),
            Text(
              DateFormat('MMM dd, yyyy – HH:mm').format(territory.createdAt),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Get.toNamed(AppRoutes.detailWithId(territory.id));
        },
      ),
    );
  }
}
