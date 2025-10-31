import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _dbName = 'a_Green.db';
  static const tableUser = 'Users';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'aGreen.db'),
    
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT, phone TEXT)",
        );
        print("Table $tableUser created succesfully");
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE $tableUser(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT )",
          );
          print("Column 'address' added to $tableUser");
        }
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE $tableUser ADD COLUMN address TEXT");
          print("Column 'address' added to $tableUser");
        }
      },
      version: 3,
    );
  }

  //register user
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  //login user
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
    print('Login query result: $result');
    //query adalah fungsi untuk menampilkan data (READ)
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    print('Login query result: $results');
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  //add User
  static Future<void> createUser(UserModel User) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.insert(
      tableUser,
      User.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(User.toMap());
  }

  //get User
  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  //update User
  static Future<void> updateUser(UserModel User) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tableUser,
      User.toMap(),
      where: "id = ?",
      whereArgs: [User.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(User.toMap());
  }

  //delete user
  static Future<void> deleteUser(int id) async {
    final dbs = await db();

    await dbs.delete(tableUser, where: "id = ?", whereArgs: [id]);
    print("user $id deleted");
  }
}
