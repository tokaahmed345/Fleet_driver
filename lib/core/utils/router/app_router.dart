
import 'package:fleet_driver/core/utils/router/routes_name.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/sharedprefrence.dart';
import 'package:fleet_driver/feature/auth/presentation/login_view.dart';
import 'package:fleet_driver/feature/home/presentation/driver_home_view.dart';
import 'package:fleet_driver/feature/register_driver/presentation/register_driver_view.dart';
import 'package:fleet_driver/feature/splash/presentation/splash_view.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: _getInitialLocation(),
    redirect: (context, state) {
      final prefs = getIt.get<SharedPrefs>();
      final isLoggedIn = prefs.isLoggedIn;
      final role = prefs.userRole;

      final isGoingToSplash = state.matchedLocation == RoutesName.splash;
      final isGoingToLogin = state.matchedLocation == RoutesName.logIn;

      if (isGoingToSplash) return null;

      if (!isLoggedIn) {
        if (isGoingToLogin) return null;
        return RoutesName.logIn;
      }

      if (isGoingToLogin) {
        return role == 'admin' ? RoutesName.registerDriver : RoutesName.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutesName.splash,
        name: RoutesName.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: RoutesName.logIn,
        name: RoutesName.logIn,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutesName.home,
        name: RoutesName.home,
        builder: (context, state) => const DriverHomeView(),
      ),
      GoRoute(
        path: RoutesName.registerDriver,
        name: RoutesName.registerDriver,
        builder: (context, state) => const RegisterDriverView(),
      ),
    ],
  );

  static String _getInitialLocation() {
    final prefs = getIt.get<SharedPrefs>();
    if (prefs.isLoggedIn) {
      return prefs.userRole == 'admin'
          ? RoutesName.registerDriver
          : RoutesName.home;
    }
    return RoutesName.splash;
  }
}