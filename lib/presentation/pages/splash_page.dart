import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/auth_controller.dart';
import 'package:territory_capture_app/presentation/pages/capture_page.dart';
import 'package:territory_capture_app/presentation/pages/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.to.currentUser;
      final loading = AuthController.to.isLoading.value;

      if (loading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return user == null ? const LoginPage() : const CapturePage();
    });
  }
}
