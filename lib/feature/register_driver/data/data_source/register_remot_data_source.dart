import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import 'package:fleet_driver/feature/register_driver/data/model/driver_model.dart';

class RegisterDriverRemoteDataSource {
  final ApiService apiService;

  RegisterDriverRemoteDataSource(this.apiService);

  @override
  Future<DriverModel> registerDriver({
    required String name,
    required String email,
    required String password,
    required String route,
  }) async {
    final response = await apiService.post(
      EndPoints.registerDriver,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "route": route,
      },
    );

    return DriverModel.fromJson(response);
  }
}