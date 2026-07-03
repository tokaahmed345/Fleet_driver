import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import 'package:fleet_driver/feature/register_driver/data/model/route_model.dart';

class RoutesRemoteDataSource {
  final ApiService apiService;

  RoutesRemoteDataSource(this.apiService);

  @override
  Future<List<RouteModel>> getAllRoutes() async {
    final response = await apiService.get(EndPoints.allRoutes);

    return (response as List)
        .map((e) => RouteModel.fromJson(e))
        .toList();
  }
}