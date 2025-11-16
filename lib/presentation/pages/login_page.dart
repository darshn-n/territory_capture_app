import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Territory Capture',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              Obx(
                () => auth.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: auth.signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text('Sign in with Google'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
