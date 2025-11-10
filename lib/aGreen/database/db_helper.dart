import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _dbName = 'a_Green.db';
  static const tableUser = 'Users';
  static const tablePlants = 'Plants';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT, phone TEXT, address TEXT)",
        );
        await db.execute(
          "CREATE TABLE $tablePlants("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "name TEXT, "
          "plant TEXT, "
          "status TEXT, "
          "frequency TEXT, "
          "lastWateredDate TEXT, "
          "userId INTEGER NOT NULL)",
        );
        print("Tables created successfully");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              "ALTER TABLE $tablePlants ADD COLUMN lastWateredDate TEXT");
          print("Column 'lastWateredDate' added");
        }
      },
    );
  }

  //USER METHODS
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final result = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      final dataUser = UserModel.fromMap(result.first);
      PreferenceHandler.saveId(dataUser.id!);
      return dataUser;
    }
    return null;
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final results = await dbs.query(tableUser);
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<void> updateUser(UserModel user) async {
    final dbs = await db();
    await dbs.update(
      tableUser,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteUser(int id) async {
    final dbs = await db();
    await dbs.delete(tableUser, where: "id = ?", whereArgs: [id]);
  }

  static Future<UserModel?> getUser(int userId) async {
    final dbs = await db();
    final result =
        await dbs.query(tableUser, where: 'id = ?', whereArgs: [userId]);
    if (result.isNotEmpty) return UserModel.fromMap(result.first);
    return null;
  }

  //PLANT METHODS
  static Future<void> addPlant(PlantModel plant) async {
    final dbInstance = await db();
    await dbInstance.insert(
      tablePlants,
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PlantModel>> getPlantsByUser(int userId) async {
    final dbInstance = await db();
    final results = await dbInstance.query(
      tablePlants,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((e) => PlantModel.fromMap(e)).toList();
  }

  static Future<void> updatePlant(PlantModel plant) async {
    final dbInstance = await db();
    await dbInstance.update(
      tablePlants,
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateLastWateredDate(int plantId) async {
    final dbInstance = await db();
    String today = DateTime.now().toIso8601String();
    await dbInstance.update(
      tablePlants,
      {'lastWateredDate': today},
      where: 'id = ?',
      whereArgs: [plantId],
    );
  }

  static Future<void> deletePlant(int id) async {
    final dbInstance = await db();
    await dbInstance.delete(tablePlants, where: 'id = ?', whereArgs: [id]);
  }

 
  //Tambahan logika untuk progress & alert penyiraman
 

  /// Menghitung progress penyiraman tanaman (0.0 - 1.0)
  static double calculateWateringProgress(PlantModel plant) {
    if (plant.lastWateredDate == null || plant.frequency.isEmpty) {
      return 1.0; // default full progress (butuh disiram)
    }

    DateTime lastWatered = DateTime.parse(plant.lastWateredDate!);
    int totalDays = _getFrequencyInDays(plant.frequency);
    int passedDays = DateTime.now().difference(lastWatered).inDays;

    double progress = (passedDays / totalDays).clamp(0.0, 1.0);
    return progress;
  }

  /// Mengecek apakah tanaman sudah waktunya disiram
  static bool isWateringDue(PlantModel plant) {
    double progress = calculateWateringProgress(plant);
    return progress >= 1.0;
  }

  /// Mengubah teks frekuensi jadi jumlah hari
  static int _getFrequencyInDays(String frequency) {
    frequency = frequency.toLowerCase();
    if (frequency.contains("hari")) return 1;
    if (frequency.contains("2-3 hari")) return 3;
    if (frequency.contains("4-6 hari")) return 6;
    if (frequency.contains("1-2 minggu")) return 14;
    if (frequency.contains("3-4 minggu")) return 28;
    return 7; // default seminggu
  }
}
