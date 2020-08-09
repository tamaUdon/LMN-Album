import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'content.dart';

class DAO {

  static DAO singletonInstance;
  static Future<Database> database;

  // プライベートコンストラクタ
  DAO._internal();

  // このクラスのシングルトンインスタンス
  factory DAO(){
    if (singletonInstance == null){
      return new DAO._internal();
    }else{
      return singletonInstance;
    }
  }

  // DB初期化
  static Future<void> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), 'my_diaries.db'), // DB名: my_diaries
      // When the database is first created, create a table to store diaries.
      onCreate: (db, version) {
        return db.execute( // TABLE名: diaries
          "CREATE TABLE diaries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, memo TEXT, date TEXT)",
        );
      },
      version: 3,
    );
  }

  // INSERT
  static Future<void> insertDiary(Diary diary) async {
    final Database db = await database;
    await db.insert(
      'diaries',
      diary.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // GET
  static Future<List<Diary>> getDiaries() async {

    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Diaries.
    final List<Map<String, dynamic>> maps = await db.query('diaries');

    // Convert the List<Map<String, dynamic> into a List<Diary>.
    return List.generate(maps.length, (i) {
      return Diary(
        0,
        maps[i]['title'],
        maps[i]['memo'],
      );
    });
  }

  // UPDATE
  static Future<void> updateDiary(Diary diary) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Diary.
    await db.update(
      'diaries',
      diary.toMap(),
      // Ensure that the Diary has a matching id.
      where: "id = ?",
      // Pass the Diary's id as a whereArg to prevent SQL injection.
      whereArgs: [diary.id],
    );
  }

  // DELETE
  static Future<void> deleteDiary(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Diary from the database.
    await db.delete(
      'diaries',
      // Use a `where` clause to delete a specific diary.
      where: "id = ?",
      // Pass the Diary's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}