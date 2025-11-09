import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_green/aGreen/models/plant_model.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String isId = "isId";
  static const String plantList = "plantList";
  static const String notifStatus = "notificationStatus"; // 🆕 key untuk notifikasi

  // ======== LOGIN HANDLER ========

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  // ======== ID HANDLER ========

  static saveId(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(isId, value);
  }

  static getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(isId);
  }

  static removeId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isId);
  }

  // ======== TANAMAN HANDLER ========

  static savePlants(List<PlantModel> plants) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> plantJsonList = plants.map((plant) => plant.toJson()).toList();
    prefs.setStringList(plantList, plantJsonList);
  }

  static Future<List<PlantModel>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? plantJsonList = prefs.getStringList(plantList);

    if (plantJsonList != null) {
      return plantJsonList
          .map((plantJson) => PlantModel.fromJson(plantJson))
          .toList();
    } else {
      return [];
    }
  }

  static removePlants() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(plantList);
  }

  // ======== NOTIFICATION HANDLER 🆕 ========

  static Future<void> setNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notifStatus, value);
  }

  static Future<bool> getNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notifStatus) ?? true; // default: ON
  }

  static Future<void> removeNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(notifStatus);
  }
}
