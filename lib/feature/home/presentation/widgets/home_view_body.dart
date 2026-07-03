import 'dart:async';
import 'package:fleet_driver/core/utils/function/helpers.dart';
import 'package:fleet_driver/core/utils/widgets/snackbar.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/route_loading_shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/service/web_socket_simulator_service.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/sharedprefrence.dart';
import 'package:fleet_driver/core/utils/widgets/primary_button.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/driver_header.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/sync_pending_logs_use_case.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/pending_logas_cubit.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/seats_cubit/seats_cubit.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/log_free_seats_modal.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/pending_log_banner.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/route_card.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/route_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:fleet_driver/feature/home/presentation/cubits/driver_route_cubit/driver_route_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeViewBody extends StatefulWidget {
  const DriverHomeViewBody({super.key});

  @override
  State<DriverHomeViewBody> createState() => _DriverHomeViewBodyState();
}

class _DriverHomeViewBodyState extends State<DriverHomeViewBody> {
  Timer? _locationTimer;
  late DriverRouteCubit _cubit;
  StreamSubscription? _connSub;
  StreamSubscription? _liveUpdatesSub;
  late LiveUpdatesSimulatorService _wsService;

  bool _wsConnectedForCurrentRoute = false;
  String? _connectedRouteId;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<DriverRouteCubit>();
    _cubit.fetchDriverRoutes(getIt.get<SharedPrefs>().driverId ?? "");
    getIt<PendingLogsCubit>().refresh();

    Future<void> syncAndRefresh() async {
      await getIt<SyncPendingLogsUseCase>().call();
      await getIt<PendingLogsCubit>().refresh();
    }

    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _cubit.checkDriverLocation();
    });

    _connSub = getIt.get<Connectivity>().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncAndRefresh();
      }
    });

    _wsService = getIt<LiveUpdatesSimulatorService>();

    _liveUpdatesSub = _wsService.liveUpdates.listen(_onLiveUpdateReceived);
  }

  void _connectSocketIfNeeded(String routeId) {
    if (_wsConnectedForCurrentRoute && _connectedRouteId == routeId) return;

    _wsConnectedForCurrentRoute = true;
    _connectedRouteId = routeId;
    _wsService.connect(routeId: routeId);
  }

  void _onLiveUpdateReceived(Map<String, dynamic> update) {
    if (!mounted) return;

    final message = update['message'] as String? ?? '';
    final type = update['type'] as String? ?? 'info';

    showSnackBarFuction(
      context,
      message,
      isError: type == 'station_closed',
      color: Helpers.colorForUpdateType(type),
      icon: Helpers.iconForUpdateType(type),
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _connSub?.cancel();
    _liveUpdatesSub?.cancel();
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DriverHeader(userName: getIt.get<SharedPrefs>().userName ?? ""),
            const SizedBox(height: 40),
            const PendingLogsBanner(),
            const SizedBox(height: 16),

            BlocBuilder<DriverRouteCubit, DriverRouteState>(
              builder: (context, state) {
                if (state is DriverRouteLoading ||
                    state is DriverRouteInitial) {
                  return const RouteLoadingShimmer();
                }

                if (state is DriverRouteFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        state.errMessage,
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  );
                }

                if (state is DriverRouteSuccess) {
                  if (state.routes.isEmpty) {
                    return const Center(child: Text('No routes assigned'));
                  }

                  final route = state.routes.first;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _connectSocketIfNeeded(route.id);
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RouteCard(
                        route: route,
                        currentStationIndex: state.currentStationIndex,
                      ),
                      const SizedBox(height: 16),
                      RouteProgressCard(
                        route: route,
                        currentStationIndex: state.currentStationIndex,
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 250),

            PrimaryButton(
              label: "👥 Log free seats",
              onTap: () {
                final state = _cubit.state;
                if (state is! DriverRouteSuccess || state.routes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No route assigned currently '),
                    ),
                  );
                  return;
                }

                final route = state.routes.first;
                final currentStation =
                    route.stations[state.currentStationIndex];

                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppColors.transparent,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider(
                    create: (_) => getIt<SeatsCubit>(),
                    child: LogFreeSeatsModal(
                      stationId: currentStation.id,
                      stationName: currentStation.name,
                      routeId: route.id,
                      stationLat: currentStation.lat,
                      stationLng: currentStation.lng,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
