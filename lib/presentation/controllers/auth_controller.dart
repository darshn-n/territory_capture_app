import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:territory_capture_app/routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get currentUser => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.capture); // ← FIXED: was .main
    } catch (e) {
      Get.snackbar('Error', 'Google sign-in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
