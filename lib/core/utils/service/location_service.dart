import 'package:geolocator/geolocator.dart';

class LocationService {

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print('🛰️ serviceEnabled: $serviceEnabled');
  if (!serviceEnabled) return null;

  LocationPermission permission = await Geolocator.checkPermission();
  print('🔑 permission: $permission');
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }

  if (permission == LocationPermission.deniedForever) return null;

  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium, 
      timeLimit: const Duration(seconds: 20),   
    );
    print('📍 Position: ${position.latitude}, ${position.longitude} | mocked: ${position.isMocked}');
    return position;
  } catch (e) {
    print('❌ getCurrentLocation error: $e');
    try {
      final last = await Geolocator.getLastKnownPosition();
      print('↩️ fallback lastKnownPosition: ${last?.latitude}, ${last?.longitude}');
      return last;
    } catch (_) {
      return null;
    }
  }
}

  double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}