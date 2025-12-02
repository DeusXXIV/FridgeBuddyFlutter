import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String householdKey = "householdId";

  /// Save household ID
  static Future<void> saveHouseholdId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(householdKey, id);
  }

  /// Load household ID (null if none)
  static Future<String?> loadHouseholdId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(householdKey);
  }

  /// Clear household (for future logout)
  static Future<void> clearHousehold() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(householdKey);
  }
}
