import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyUserId = 'user_id';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserName = 'user_name';
  static const String _keyDriverId = 'driver_id';

  SharedPreferences get _prefs => getIt.get<SharedPreferences>();

  Future<void> saveUser({
    required String id,
    required String role,
    required String name,
    String? driverId,
  }) async {
    await _prefs.setString(_keyUserId, id);
    await _prefs.setString(_keyUserRole, role);
    await _prefs.setString(_keyUserName, name);

    if (driverId != null && driverId.isNotEmpty) {
      await _prefs.setString(_keyDriverId, driverId);
    } else {
      await _prefs.remove(_keyDriverId);
    }
  }

  String? get userId => _prefs.getString(_keyUserId);
  String? get userRole => _prefs.getString(_keyUserRole);
  String? get userName => _prefs.getString(_keyUserName);
  String? get driverId => _prefs.getString(_keyDriverId);

  bool get isLoggedIn => userId != null && userRole != null;

  Future<void> clearUser() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserRole);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyDriverId);
  }
}