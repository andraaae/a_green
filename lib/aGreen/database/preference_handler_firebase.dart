import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_green/aGreen/models/plant_model.dart';

class PreferenceHandlerFirebase {
  static const String isLogin = "isLogin";
  static const String firebaseUid = "firebaseUid";  // <-- UID STRING
  static const String plantList = "plantList";
  static const String notifStatus = "notificationStatus";
  static const String tokenKey = "authToken";

  // ============================
  // LOGIN HANDLER
  // ============================
  static Future<void> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLogin, value);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLogin);
  }

  // ============================
  // FIREBASE UID (STRING)
  // ============================
  static Future<void> saveUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(firebaseUid, uid);
  }

  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseUid);
  }

  static Future<void> removeUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(firebaseUid);
  }

  // ============================
  // TOKEN HANDLER
  // ============================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // ============================
  // PLANT LOCAL STORAGE
  // ============================
  static Future<void> savePlants(List<PlantModel> plants) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plantsJson = plants.map((p) => p.toJson()).toList();
    await prefs.setStringList(plantList, plantsJson);
  }

  static Future<List<PlantModel>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(plantList);

    if (list == null) return [];
    return list.map((json) => PlantModel.fromJson(json)).toList();
  }

  static Future<void> removePlants() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(plantList);
  }

  // ============================
  // NOTIFICATION HANDLER
  // ============================
  static Future<void> setNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notifStatus, value);
  }

  static Future<bool> getNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notifStatus) ?? true;
  }

  static Future<void> removeNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(notifStatus);
  }
}
