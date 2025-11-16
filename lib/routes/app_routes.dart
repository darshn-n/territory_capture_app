import 'package:get/get.dart';
import 'package:territory_capture_app/presentation/bindings/auth_binding.dart';
import 'package:territory_capture_app/presentation/bindings/capture_binding.dart';
import 'package:territory_capture_app/presentation/bindings/detail_binding.dart';
import 'package:territory_capture_app/presentation/bindings/list_binding.dart';
import 'package:territory_capture_app/presentation/pages/capture_page.dart';
import 'package:territory_capture_app/presentation/pages/login_page.dart';
import 'package:territory_capture_app/presentation/pages/permission_denied_page.dart';
import 'package:territory_capture_app/presentation/pages/splash_page.dart';
import 'package:territory_capture_app/presentation/pages/territory_detail_page.dart';
import 'package:territory_capture_app/presentation/pages/territory_list_page.dart';

class AppRoutes {
  // Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String capture = '/capture';
  static const String list = '/list'; // ← ADDED
  static const String detail = '/detail'; // ← ADDED
  static const String permissionDenied = '/permission-denied';

  // Full route with param
  static String detailWithId(String id) => '$detail/$id';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: login, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(
      name: capture,
      page: () => const CapturePage(),
      binding: CaptureBinding(),
    ),
    GetPage(
      name: list,
      page: () => const TerritoryListPage(),
      binding: TerritoryListBinding(),
    ),
    GetPage(
      name: '$detail/:id',
      page: () => const TerritoryDetailPage(),
      binding: TerritoryDetailBinding(),
    ),
    GetPage(name: permissionDenied, page: () => const PermissionDeniedPage()),
  ];
}
