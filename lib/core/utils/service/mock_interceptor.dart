import 'package:dio/dio.dart';
import 'package:fleet_driver/core/utils/service/endpoints.dart';
import '../mock/mock_database.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ---------------- LOGIN ----------------
    if (options.path == EndPoints.login && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      final email = data['email'];
      final password = data['password'];

      final user = MockDatabase.users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {"message": "Invalid email or password"},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: user,
        ),
      );
    }

    // ---------------- GET ROUTES (by driverId) ----------------
    if (options.path == EndPoints.routes && options.method == 'GET') {
      final driverId = options.queryParameters['driverId'];

      final driverRoutes = MockDatabase.routes
          .where((r) => r['driverId'] == driverId)
          .toList();

      if (driverRoutes.isEmpty) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 404,
              data: {"message": "No routes found for this driver"},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: driverRoutes,
        ),
      );
    }

    // ---------------- GET ALL ROUTES (for admin dropdown) ----------------
    if (options.path == EndPoints.allRoutes && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: MockDatabase.getAllRoutes(),
        ),
      );
    }

    // ---------------- SUBMIT LOG (free seats) ----------------
    if (options.path == EndPoints.logs && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;

      final stationId = data['stationId'];
      final routeId = data['routeId'];
      final freeSeats = data['freeSeats'];

      if (stationId == null || routeId == null || freeSeats == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {"message": "Missing required fields"},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final newLog = MockDatabase.addLog(
        stationId: stationId,
        routeId: routeId,
        freeSeats: freeSeats,
        synced: true,
      );

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: newLog,
        ),
      );
    }

    // ---------------- REGISTER NEW DRIVER ----------------
    if (options.path == EndPoints.registerDriver && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;

      final name = data['name'];
      final email = data['email'];
      final password = data['password'];
      final route = data['route'];

      if (name == null || email == null || password == null || route == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {"message": "Missing required fields"},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final existingUser = MockDatabase.findUserByEmail(email);
      if (existingUser != null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 409,
              data: {"message": "Email already exists"},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final newDriver = MockDatabase.addDriver(
        name: name,
        email: email,
        password: password,
        route: route,
      );

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: newDriver,
        ),
      );
    }

    // ---------------- GET LOGS (optional - عشان تتأكدي من الداتا وقت التست) ----------------
    if (options.path == EndPoints.logs && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: MockDatabase.logs,
        ),
      );
    }

    return handler.next(options);
  }
}