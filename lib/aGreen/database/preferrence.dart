import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_green/aGreen/models/plant_model.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String isId = "isId";
  static const String plantList = "plantList";
 
  //Save data login pada saat login

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  //Hapus data login pada saat logout
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  static saveId(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(isId, value);
  }

  //Ambil data Id pada saat mau Id / ke dashboard
  static getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(isId);
  }

  //Hapus data Id pada saat logout
  static removeId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isId);
  }

  //tanaman

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
}
