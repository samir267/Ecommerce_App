import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static Database? _database;

  // Créer ou obtenir une base de données SQLite
  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialiser la base de données
  _initDB() async {
    String path = join(await getDatabasesPath(), 'user_db.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        accessToken TEXT
      )
      ''');
    });
  }

  // Insérer les données de l'utilisateur
  Future<void> insertUser(int userId, String accessToken) async {
    final db = await _db;
    await db.insert(
      'user',
      {'userId': userId, 'accessToken': accessToken},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer les informations de l'utilisateur
  Future<Map<String, dynamic>?> getUser() async {
    final db = await _db;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Supprimer les informations de l'utilisateur
  Future<void> deleteUser() async {
    final db = await _db;
    await db.delete('user');
  }
}
