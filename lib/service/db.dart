import 'dart:io';

import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/service/interfaces/idatabase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class Db implements IDatabase {
  static Database _database; //singleton database object
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  final String goalsTable = "goal_table";
  final String colId = "id";
  final String colTitle = "title";
  final String colBody = "body";
  final String colDeadLine = "deadLine";
  final String dbName = "goals.db";

  void createDb(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE $goalsTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colBody TEXT NOT NULL,
        $colDeadLine DATETIME)
        ''');
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: createDb);
  }

  @override
  Future<int> createGoal(Goal goal) async {
    Database db = await this.database;
    return await db.insert(goalsTable, goal.toMap());
  }

  @override
  Future<int> deleteGoal(Goal goal) async {
    Database db = await this.database;
    return await db
        .rawDelete('DELETE FROM $goalsTable WHERE $colId = ${goal.id}');
  }

  @override
  Future<int> getCount(Goal goal) async {
    Database db = await this.database;
    List<Map<String, dynamic>> num = await db.query(goalsTable);
    return Sqflite.firstIntValue(num);
  }

  @override
  Future<List<Goal>> getGoalsList() async {
    var goalsMapList = await getGoalsMapList();
    var goalsList = goalsMapList.map((e) => Goal.fromMap(e)).toList();
    return Future.value(goalsList);
  }

  Future<List<Map<String, dynamic>>> getGoalsMapList() async {
    Database db = await this.database;
    return await db.query(goalsTable, orderBy: colId);
  }

  @override
  Future<int> updateGoal(Goal goal) async {
    Database db = await this.database;
    return await db.update(goalsTable, goal.toMap(),
        where: "$colId=?", whereArgs: [goal.id]);
  }
}
