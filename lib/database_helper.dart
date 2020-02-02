import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Models/worker.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database
  String workerTable = 'WorkerTable';
  String colId = 'id';
  String colName = 'name';
  String colPhone = 'phone';
  //double colAmount = 0;
  String path;

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    path = directory.path + '/Workers.db';

    // Open/create the database at a given path
    var workersDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return workersDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $workerTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colPhone TEXT)');
  }

  // Fetch Operation: Get all workers  from database
  Future<List<Map<String, dynamic>>> getWorkerMapList() async {
    Database db = await this.database;
    var result = await db.query(workerTable, orderBy: '$colName ASC');
    return result;
  }

  // Insert Operation: Insert a worker  to database
  Future<int> insertWorker(Worker worker) async {
    Database db = await this.database;
    var result = await db.insert(workerTable, worker.toMap());
    return result;
  }

  // Update Operation: Update a Worker data and save it to database
  Future<int> updateWorker(Worker worker) async {
    var db = await this.database;
    var result = await db.update(workerTable, worker.toMap(),
        where: '$colId = ?', whereArgs: [worker.id]);
    return result;
  }

  // Delete Operation: Delete a Worker from database
  Future<int> deleteWorker(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $workerTable WHERE $colId = $id');
    return result;
  }

  // Get number of Worker  in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $workerTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Worker List' [ List<Worker> ]
  Future<List<Worker>> getWorkerList() async {
    var workerMapList = await getWorkerMapList(); // Get 'Map List' from database
    int count =
        workerMapList.length; // Count the number of map entries in db table

    List<Worker> workerList = List<Worker>();
    // For loop to create a 'Workers List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      workerList.add(Worker.fromMapObject(workerMapList[i]));
    }

    return workerList;
  }
}
