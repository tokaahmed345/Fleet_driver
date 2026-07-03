import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import '../mock/mock_database.dart';

enum SocketConnectionState { connecting, connected, disconnected }

class LiveUpdatesSimulatorService {
  final _stateController = StreamController<SocketConnectionState>.broadcast();
  final _updateController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<SocketConnectionState> get connectionState => _stateController.stream;
  Stream<Map<String, dynamic>> get liveUpdates => _updateController.stream;

  Timer? _heartbeatTimer;
  Timer? _eventGeneratorTimer;
  Timer? _dropSimTimer;
  StreamSubscription? _connectivitySub;

  int _retryCount = 0;
  bool _manuallyDisconnected = false;
  bool _hasRealInternet = true;
  String? _currentRouteId;

  void connect({required String routeId}) {
    _currentRouteId = routeId;
    _manuallyDisconnected = false;

    _connectivitySub ??= getIt.get<Connectivity>().onConnectivityChanged.listen(
      (_) async {
        final online = await _checkRealInternet();
        _hasRealInternet = online;
        if (!online) {
          _handleDrop();
        } else if (!_manuallyDisconnected) {
          connect(routeId: _currentRouteId!);
        }
      },
    );

    _stateController.add(SocketConnectionState.connecting);

    Timer(const Duration(milliseconds: 600), () async {
      if (_manuallyDisconnected) return;

      final online = await _checkRealInternet();
      _hasRealInternet = online;

      if (!online) {
        _stateController.add(SocketConnectionState.disconnected);
        _reconnectWithBackoff();
        return;
      }

      _retryCount = 0;
      _stateController.add(SocketConnectionState.connected);
      _startHeartbeat();
      _startEventGenerator();
      _scheduleRandomDrop();
    });
  }

  Future<bool> _checkRealInternet() async {
    final result = await getIt.get<Connectivity>().checkConnectivity();
    if (result == ConnectivityResult.none) return false;
    try {
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {});
  }

  void _startEventGenerator() {
    _eventGeneratorTimer?.cancel();
    _eventGeneratorTimer = Timer.periodic(
      Duration(seconds: 10 + Random().nextInt(10)),
      (_) {
        if (_currentRouteId == null) return;
        final update = MockDatabase.generateRandomLiveUpdate(_currentRouteId!);
        if (update != null) {
          _updateController.add(update);
        }
      },
    );
  }

  void _scheduleRandomDrop() {
    _dropSimTimer?.cancel();
    final seconds = 20 + Random().nextInt(20);
    _dropSimTimer = Timer(Duration(seconds: seconds), () {
      if (_manuallyDisconnected || !_hasRealInternet) return;
      _handleDrop();
    });
  }

  void _handleDrop() {
    _heartbeatTimer?.cancel();
    _eventGeneratorTimer?.cancel();
    _dropSimTimer?.cancel();
    _stateController.add(SocketConnectionState.disconnected);
    if (!_manuallyDisconnected) _reconnectWithBackoff();
  }

  void _reconnectWithBackoff() {
    final delay = Duration(seconds: min(30, pow(2, _retryCount).toInt()));
    _retryCount++;
    Timer(delay, () async {
      if (_manuallyDisconnected) return;
      final online = await _checkRealInternet();
      if (online && _currentRouteId != null) {
        connect(routeId: _currentRouteId!);
      } else {
        _reconnectWithBackoff();
      }
    });
  }

  void disconnect() {
    _manuallyDisconnected = true;
    _heartbeatTimer?.cancel();
    _eventGeneratorTimer?.cancel();
    _dropSimTimer?.cancel();
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _stateController.add(SocketConnectionState.disconnected);
  }

  void dispose() {
    disconnect();
    _stateController.close();
    _updateController.close();
  }
}
