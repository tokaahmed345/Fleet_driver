import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fleet_driver/core/utils/network_info.dart';
import 'package:fleet_driver/core/utils/service/api_service.dart';
import 'package:fleet_driver/core/utils/service/dio_consumer.dart';
import 'package:fleet_driver/core/utils/service/location_service.dart';
import 'package:fleet_driver/core/utils/service/mock_interceptor.dart';
import 'package:fleet_driver/core/utils/service/web_socket_simulator_service.dart';
import 'package:fleet_driver/core/utils/sharedprefrence.dart';
import 'package:fleet_driver/feature/auth/data/data_source/login_remote_data_source.dart';
import 'package:fleet_driver/feature/auth/data/repo_impl/login_repo_impl.dart';
import 'package:fleet_driver/feature/auth/domain/repo/login_repo.dart';
import 'package:fleet_driver/feature/auth/domain/usecase/login_usecase.dart';
import 'package:fleet_driver/feature/auth/presentation/login_cubit/log_in_cubit.dart';
import 'package:fleet_driver/feature/home/data/data_source/driver_route_data_source.dart';
import 'package:fleet_driver/feature/home/data/data_source/driver_route_local_data_source.dart';
import 'package:fleet_driver/feature/home/data/repo_impl/driver_route_repo_impl.dart';
import 'package:fleet_driver/feature/home/domain/repo/driver_route_repo.dart';
import 'package:fleet_driver/feature/home/domain/usecase/driver_route_usecase.dart';
import 'package:fleet_driver/feature/home/presentation/cubits/driver_route_cubit/driver_route_cubit.dart';
import 'package:fleet_driver/feature/log_free_seats/data/data_seource/log_free_seats_local_data_source.dart';
import 'package:fleet_driver/feature/log_free_seats/data/data_seource/log_free_seats_remote_data_source.dart';
import 'package:fleet_driver/feature/log_free_seats/data/repo_impl/log_free_seats_repo_impl.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/repo/log_free_seats_repo.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/get_pending_logs_use_case.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/log_free_seats_use_case.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/sync_pending_logs_use_case.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/pending_logas_cubit.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/seats_cubit/seats_cubit.dart';
import 'package:fleet_driver/feature/register_driver/data/data_source/register_remot_data_source.dart';
import 'package:fleet_driver/feature/register_driver/data/data_source/route_remote_data_source.dart';
import 'package:fleet_driver/feature/register_driver/data/repo_impl/register_driver_repo_impl.dart';
import 'package:fleet_driver/feature/register_driver/data/repo_impl/route_repo_impl.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/register_repo.dart';
import 'package:fleet_driver/feature/register_driver/domain/repo/route_repo.dart';
import 'package:fleet_driver/feature/register_driver/domain/usecase/register_driver_usecase.dart';
import 'package:fleet_driver/feature/register_driver/domain/usecase/route_usecase.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/cubit/routes_cubit.dart';
import 'package:fleet_driver/feature/register_driver/presentation/cubits/register_cubit/register_driver_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> setUp() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<SharedPrefs>(() => SharedPrefs());

  final dio = Dio();
  dio.interceptors.add(MockInterceptor());

  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton<ApiService>(() => DioConsumer(dio: getIt()));
getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<LogInRemoteDataSource>(
    () => LogInRemoteDataSource(apiService: getIt.get<ApiService>()),
  );
  getIt.registerLazySingleton<LogInRepo>(
    () => LogInRepoImpl(remoteDataSource: getIt<LogInRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LogInRepoImpl>(
    () => LogInRepoImpl(remoteDataSource: getIt<LogInRemoteDataSource>()),
  );
    getIt.registerLazySingleton<LogInUseCase>(
    () =>LogInUseCase (repo: getIt<LogInRepo>()),
  );

  getIt.registerFactory<LogInCubit>(() => LogInCubit());


getIt.registerLazySingleton<RegisterDriverRemoteDataSource>(
  () => RegisterDriverRemoteDataSource(getIt.get<ApiService>()),
);

getIt.registerLazySingleton<RegisterDriverRepo>(
  () => RegisterDriverRepoImpl( getIt<RegisterDriverRemoteDataSource>()),
);

getIt.registerLazySingleton<RegisterDriverUseCase>(
  () => RegisterDriverUseCase(getIt.get<RegisterDriverRepo>()),
);

getIt.registerFactory<RegisterDriverCubit>(
  () => RegisterDriverCubit(getIt.get<RegisterDriverUseCase>()),
);







getIt.registerLazySingleton<RoutesRemoteDataSource>(
  () => RoutesRemoteDataSource(getIt.get<ApiService>()),
);

getIt.registerLazySingleton<RoutesRepo>(
  () => RoutesRepoImpl(getIt.get<RoutesRemoteDataSource>()),
);

getIt.registerLazySingleton<GetAllRoutesUseCase>(
  () => GetAllRoutesUseCase(getIt.get<RoutesRepo>()),
);

getIt.registerFactory<RoutesCubit>(
  () => RoutesCubit(getIt.get<GetAllRoutesUseCase>()),
);

getIt.registerLazySingleton<LocationService>(() => LocationService());


getIt.registerLazySingleton<DriverRouteDataSource>(
  () => DriverRouteDataSource(getIt.get<ApiService>()),
);
getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
getIt.registerLazySingleton(() => DriverRouteLocalDataSource());


getIt.registerLazySingleton<DriverRouteRepository>(
  () => DriverRouteRepositoryImpl(getIt.get<DriverRouteDataSource>(),getIt.get<DriverRouteLocalDataSource>(),getIt.get<NetworkInfo>())

);
getIt.registerLazySingleton<GetDriverRoutesUseCase>(
  () => GetDriverRoutesUseCase(getIt.get<DriverRouteRepository>()),
);

getIt.registerFactory<DriverRouteCubit>(
  () => DriverRouteCubit(getIt.get<GetDriverRoutesUseCase>(),getIt.get<LocationService>()),
);

getIt.registerLazySingleton<LogFreeSeatsRemoteDataSource>(() => LogFreeSeatsRemoteDataSource(getIt.get<ApiService>()));
getIt.registerLazySingleton<LogFreeSeatsLocalDataSource>(() => LogFreeSeatsLocalDataSource());
getIt.registerLazySingleton<LogFreeSeatsRepo>(() => SeatsRepositoryImpl(
      remote: getIt.get<LogFreeSeatsRemoteDataSource>(),
      local: getIt.get<LogFreeSeatsLocalDataSource>(),
    ));
getIt.registerLazySingleton(() => LogFreeSeatsUseCase(getIt.get<LogFreeSeatsRepo>()));

getIt.registerLazySingleton(() => SyncPendingLogsUseCase(getIt.get<LogFreeSeatsRepo>()));
getIt.registerLazySingleton(() => GetPendingLogsUseCase(getIt.get<LogFreeSeatsRepo>()));
getIt.registerLazySingleton(() => PendingLogsCubit(getIt.get<GetPendingLogsUseCase>()));
getIt.registerFactory(() => SeatsCubit(
      logFreeSeatsUseCase: getIt(),
      locationService: getIt(),
    ));


getIt.registerLazySingleton(() => LiveUpdatesSimulatorService());

}
