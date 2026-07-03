import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import '../models/driver_route_model.dart';



class DriverRouteDataSource  {
  final ApiService apiService;

  DriverRouteDataSource(this.apiService);

  @override
  Future<List<DriverRouteModel>> getDriverRoutes(String driverId) async {
    final response = await apiService.get(
      EndPoints.routes,
      queryParameters: {'driverId': driverId},
    );

 return ( response as List).map((e) => DriverRouteModel.fromJson(e))
        .toList();
  }
}