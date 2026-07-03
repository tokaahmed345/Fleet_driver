

import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import 'package:fleet_driver/feature/auth/data/model/login_model.dart';

class LogInRemoteDataSource {
    final ApiService apiService;

  LogInRemoteDataSource({required this.apiService});

    Future<LogInModel> logIn({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      EndPoints.login,
      data: {'email': email, 'password': password},
    );
    return LogInModel.fromJson(response);
  }
}