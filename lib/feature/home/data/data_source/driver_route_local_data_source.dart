import 'package:hive/hive.dart';
import 'package:fleet_driver/feature/home/data/models/driver_route_model.dart';

class DriverRouteLocalDataSource {
  static const String boxName = 'driver_routes_box';

  Future<Box<DriverRouteModel>> _openBox() async {
    return await Hive.openBox<DriverRouteModel>(boxName);
  }

  Future<void> cacheRoutes(List<DriverRouteModel> routes) async {
    final box = await _openBox();
    await box.clear(); 
    for (final route in routes) {
      await box.put(route.hiveId, route);
    }
  }

  Future<List<DriverRouteModel>> getCachedRoutes(String driverId) async {
    final box = await _openBox();
    return box.values.where((r) => r.hiveDriverId == driverId).toList();
  }

  Future<bool> hasCachedData() async {
    final box = await _openBox();
    return box.isNotEmpty;
  }
}