import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Inicializar o abrir la base de datos
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('diario_emocional.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Crear la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crear tablas
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        moodLevel REAL,
        dailyFeeling TEXT,
        date TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // REGISTRAR USUARIO
  Future<void> registerUser(String username, String password) async {
    final db = await database;

    final existingUser = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUser.isNotEmpty) {
      throw Exception('El usuario ya existe');
    }

    await db.insert('users', {'username': username, 'password': password});
  }

  // INICIAR SESIÓN
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;

    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  // INSERTAR ENTRADA DEL DIARIO
  Future<void> insertDiary(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('diary_entries', data);
  }

  // OBTENER TODAS LAS ENTRADAS DE UN USUARIO
  Future<List<Map<String, dynamic>>> getUserDiaries(int userId) async {
    final db = await database;
    return await db.query(
      'diary_entries',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }
}
