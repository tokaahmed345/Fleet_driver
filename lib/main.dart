import 'package:fleet_driver/core/utils/router/app_router.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/feature/home/data/models/driver_route_model.dart';
import 'package:fleet_driver/feature/home/data/models/station_model.dart';
import 'package:fleet_driver/feature/log_free_seats/data/models/free_seats_log_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FreeSeatsLogModelAdapter());
  Hive.registerAdapter(StationModelAdapter());
  Hive.registerAdapter(DriverRouteModelAdapter());
  await setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
