import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        price REAL,
        rate REAL,
        available INTEGER,
        description TEXT,
        images TEXT,
        tv INTEGER,
        shower INTEGER,
        wifi INTEGER,
        breakfast INTEGER,
        status TEXT DEFAULT 'available'
      )
    ''');
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await instance.database;
    await db.insert('meals', meal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Meal>> fetchMeals() async {
    final db = await instance.database;
    final result = await db.query('meals');
    return result.map((map) => Meal.fromMap(map)).toList();
  }

  static Future<void> deleteDatabaseFile() async {
    final path = join(await getDatabasesPath(), 'meals.db');
    await databaseFactory.deleteDatabase(path);
  }

  static Future<void> deleteMealsTable() async {
    await _database!.execute('DROP TABLE IF EXISTS meals');
  }

  static Future getMealsByStatus() async {
    return await _database!.rawQuery('SELECT * FROM meals');
  }

  static Future<void> deleteMeals() async {
    await _database!.rawDelete('DELETE FROM meals');
  }

  static Future<void> createMealsTable() async {
    await _database!.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        price REAL,
        rate REAL,
        available INTEGER,
        description TEXT,
        images TEXT,
        tv INTEGER,
        shower INTEGER,
        wifi INTEGER,
        breakfast INTEGER,
        status TEXT
      )
    ''');
  }

  static Future<void> updateMealStatus({required int id, required String status}) async {
    await _database!.update('meals', {
      'status': status,
    }, where: 'id = ?', whereArgs: [id]);
  }
}
