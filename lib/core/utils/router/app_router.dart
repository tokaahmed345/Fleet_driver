
// // import 'package:fleet_driver/core/utils/router/routes_name.dart';
// // import 'package:fleet_driver/core/utils/sharedprefrence.dart';
// // import 'package:fleet_driver/feature/auth/presentation/login_view.dart';
// // import 'package:fleet_driver/feature/home/presentation/driver_home_view.dart';
// // import 'package:fleet_driver/feature/register_driver/presentation/register_driver_view.dart';
// // import 'package:fleet_driver/feature/splash/presentation/splash_view.dart';

// // import 'package:go_router/go_router.dart';

// // class AppRouter {
// //   static final router = GoRouter(
// //     initialLocation: _getInitialLocation(),
// //     redirect: (context, state) {
// //       final isLoggedIn = SharedPrefs.isLoggedIn;
// //       final role = SharedPrefs.userRole;
// //       final isGoingToLogin = state.matchedLocation == RoutesName.logIn;
// //       final isGoingToRegister =
// //           state.matchedLocation == RoutesName.registerDriver;

// //       if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
// //         return RoutesName.logIn;
// //       }

// //       // if (isLoggedIn && isGoingToLogin) {
// //       //   return role == 'admin' ? RoutesName.registerDriver : RoutesName.home;
// //       // }
// //       if (isLoggedIn && isGoingToLogin) {
// //   return null;
// // }

// //       return null;
// //     },
// //     routes: [
// //       GoRoute(
// //         path: RoutesName.splash,
// //         name: RoutesName.splash,
// //         builder: (context, state) => const SplashView(),
// //       ),
// //       GoRoute(
// //         path: RoutesName.logIn,
// //         name: RoutesName.logIn,
// //         builder: (context, state) => const LoginView(),
// //       ),
    
// //       GoRoute(
// //         path: RoutesName.home,
// //         name: RoutesName.home,
// //         builder: (context, state) => const DriverHomeView(),
// //       ),
// //       GoRoute(
// //         path: RoutesName.registerDriver,
// //         name: RoutesName.registerDriver,
// //         builder: (context, state) => const RegisterDriverView(),
// //       ),
// //     ],
// //   );

// //   static String _getInitialLocation() {
// //     if (SharedPrefs.isLoggedIn) {
// //       return SharedPrefs.userRole == 'admin'
// //           ? RoutesName.registerDriver
// //           : RoutesName.home;
// //     }
// //     return RoutesName.logIn;
// //   }
// // }
// import 'package:fleet_driver/core/utils/router/routes_name.dart';
// import 'package:fleet_driver/core/utils/sharedprefrence.dart';
// import 'package:fleet_driver/feature/auth/presentation/login_view.dart';
// import 'package:fleet_driver/feature/home/presentation/driver_home_view.dart';
// import 'package:fleet_driver/feature/register_driver/presentation/register_driver_view.dart';
// import 'package:fleet_driver/feature/splash/presentation/splash_view.dart';

// import 'package:go_router/go_router.dart';

// class AppRouter {
//   static final router = GoRouter(
//     initialLocation: RoutesName.splash, // ← دايمًا تبدأ بالـ splash
//     redirect: (context, state) {
//       final isLoggedIn = SharedPrefs.isLoggedIn;
//       final isGoingToSplash = state.matchedLocation == RoutesName.splash;
//       final isGoingToLogin = state.matchedLocation == RoutesName.logIn;
//       final isGoingToRegister =
//           state.matchedLocation == RoutesName.registerDriver;

//       // متحطيش أي redirect وهي لسه في الـ splash، سيبيها تكمل animation
//       if (isGoingToSplash) return null;

//       if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
//         return RoutesName.logIn;
//       }

//       if (isLoggedIn && isGoingToLogin) {
//         return null;
//       }

//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: RoutesName.splash,
//         name: RoutesName.splash,
//         builder: (context, state) => const SplashView(),
//       ),
//       GoRoute(
//         path: RoutesName.logIn,
//         name: RoutesName.logIn,
//         builder: (context, state) => const LoginView(),
//       ),
//       GoRoute(
//         path: RoutesName.home,
//         name: RoutesName.home,
//         builder: (context, state) => const DriverHomeView(),
//       ),
//       GoRoute(
//         path: RoutesName.registerDriver,
//         name: RoutesName.registerDriver,
//         builder: (context, state) => const RegisterDriverView(),
//       ),
//     ],
//   );
// }import 'package:fleet_driver/core/utils/router/routes_name.dart';


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

      // ⭐ ده اللي كان ناقص - سيبي الـ splash تتعرض عادي من غير redirect
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