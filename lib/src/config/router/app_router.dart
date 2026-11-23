import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/features/home/presentation/screens/screen_home.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ScreenHome(),
      ),
    ],
  );
}
