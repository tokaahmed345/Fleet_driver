import 'dart:math';

class MockDatabase {
  // ---------------- USERS ----------------
  static List<Map<String, dynamic>> users = [
    {
      "id": "1",
      "driverId": "DR-01",
      "email": "driver1@test.com",
      "password": "123456",
      "role": "driver",
      "name": "Ahmed Mostafa",
    },
    {
      "id": "2",
      "email": "admin@test.com",
      "password": "123456",
      "role": "admin",
      "name": "Mona Hassan",
    },
  ];

  static Map<String, dynamic>? findUserByEmail(String email) {
    final result = users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );
    return result.isEmpty ? null : result;
  }

  static int _driverIdCounter = 4;

  static Map<String, dynamic> addDriver({
    required String name,
    required String email,
    required String password,
    required String route,
  }) {
    final newId = (users.length + 1).toString();
    final newDriverId = "DR-0${_driverIdCounter++}";

    final routeIndex = routes.indexWhere((r) => r['id'] == route);
    if (routeIndex != -1) {
      routes[routeIndex]['driverId'] = newDriverId;
    }

    final driver = {
      "id": newId,
      "driverId": newDriverId,
      "email": email,
      "password": password,
      "role": "driver",
      "name": name,
    };
    users.add(driver);
    return driver;
  }

  // ---------------- ROUTES (Cairo stations) ----------------
  static final List<Map<String, dynamic>> routes = [
    {
      "id": "RT-RN",
      "driverId": "DR-01",
      "name": "Ramses - Nasr City ",
      "stations": [
        {"id": "ST-TR", "name": "Tahrir Square", "lat": 30.0444, "lng": 31.2357},
        {"id": "ST-RM", "name": "Ramses Station", "lat": 30.0626, "lng": 31.2497},
        {"id": "ST-AB", "name": "Abbassia", "lat": 30.0667, "lng": 31.2833},
        {"id": "ST-CS", "name": "City Stars", "lat": 30.0731, "lng": 31.3460},
      ]
    },
    {
      "id": "RT-MH",
      "driverId": "DR-01",
      "name": "Maadi - Heliopolis ",
      "stations": [
        {"id": "ST-MA", "name": "Maadi", "lat": 29.9602, "lng": 31.2569},
        {"id": "ST-NC", "name": "Nile Corniche", "lat": 30.0131, "lng": 31.2289},
        {"id": "ST-KO", "name": "Korba", "lat": 30.0875, "lng": 31.3247},
      ]
    },
    {
      "id": "RT-DZ",
      "driverId": "DR-02",
      "name": "Dokki - Zamalek ",
      "stations": [
        {"id": "ST-DK", "name": "Dokki", "lat": 30.0384, "lng": 31.2101},
        {"id": "ST-OP", "name": "Opera", "lat": 30.0419, "lng": 31.2243},
        {"id": "ST-ZM", "name": "Zamalek", "lat": 30.0624, "lng": 31.2197},
      ]
    },
    {
      "id": "RT-GH",
      "driverId": "DR-03",
      "name": "Giza - Haram ",
      "stations": [
        {"id": "ST-GZ", "name": "Giza Square", "lat": 30.0131, "lng": 31.2089},
        {"id": "ST-FS", "name": "Faisal", "lat": 30.0170, "lng": 31.2050},
        {"id": "ST-PY", "name": "Pyramids", "lat": 29.9792, "lng": 31.1342},
      ]
    },
  ];

  // ---------------- GET ALL ROUTES (for admin dropdown) ----------------
  static List<Map<String, dynamic>> getAllRoutes() {
    return routes.map((r) => {"id": r['id'], "name": r['name']}).toList();
  }

  // ---------------- LOGS (updated at runtime) ----------------
  static final List<Map<String, dynamic>> logs = [];

  static int _logIdCounter = 1;

  static Map<String, dynamic> addLog({
    required String stationId,
    required String routeId,
    required int freeSeats,
    required bool synced,
  }) {
    final log = {
      "id": "log${_logIdCounter++}",
      "stationId": stationId,
      "routeId": routeId,
      "freeSeats": freeSeats,
      "timestamp": DateTime.now().toIso8601String(),
      "synced": synced,
    };
    logs.add(log);
    return log;
  }

  // ---------------- LIVE UPDATES (WebSocket simulation) ----------------
  static final List<Map<String, dynamic>> liveUpdates = [];

  static void pushLiveUpdate(String message, String type, {String? routeId}) {
    liveUpdates.add({
      "message": message,
      "type": type,
      "routeId": routeId,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic>? generateRandomLiveUpdate(String routeId) {
    final route = routes.firstWhere(
      (r) => r['id'] == routeId,
      orElse: () => {},
    );
    if (route.isEmpty) return null;

    final stations = route['stations'] as List;
    if (stations.isEmpty) return null;

    final randomStation = stations[Random().nextInt(stations.length)];
final possibleEvents = [
  {
    "type": "congestion",
    "message": "Expected congestion near ${randomStation['name']}",
  },
  {
    "type": "station_closed",
    "message": "${randomStation['name']} station is temporarily closed, take a detour",
  },
  {
    "type": "info",
    "message": "Trip started on ${route['name']} route",
  },
  {
    "type": "delay",
    "message": "Expected 5-minute delay at ${randomStation['name']}",
  },
];
    final event = possibleEvents[Random().nextInt(possibleEvents.length)];

    final update = {
      "message": event['type'] == null ? "" : event['message'],
      "type": event['type'],
      "routeId": routeId,
      "stationId": randomStation['id'],
      "timestamp": DateTime.now().toIso8601String(),
    };

    liveUpdates.add(update);
    return update;
  }
}