import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseLocale {
  static final DatabaseLocale instance = DatabaseLocale._init();

  static Database? _database;

  DatabaseLocale._init();


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pendu.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> dropDatabase() async {
    final db = await instance.database;
    await db.execute('DROP DATABASE pendu.db');
  }

  // Méthode qui drop les tables pendu et histoire
  Future<void> dropTable() async {
    final db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS pendu');
    await db.execute('DROP TABLE IF EXISTS histoire');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pendu(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo TEXT,
        level INTEGER,
        essai INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS histoire(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo TEXT,
        level INTEGER
      )
    ''');
  }


  // Méthode qui supprime un utilisateur du mode histoire et le remplace par un autre
  Future<void> insertScoreHistoire(String pseudo, int level) async {
    final db = await instance.database;
    await db.delete('histoire', where: 'pseudo = ?', whereArgs: [pseudo]);
    await db.insert(
      'histoire',
      {'pseudo': pseudo, 'level': level},
    );
  }

  // Méthode qui regarde si déjà un utilisateur existe dans le mode histoire
  Future<bool> checkUser(String pseudo) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('histoire', where: 'pseudo = ?', whereArgs: [pseudo]);

    return maps.isNotEmpty;
  }

  // Méthode qui récupère le niveau de l'utilisateur dans le mode histoire
  Future<int?> getLevel(String pseudo) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('histoire', where: 'pseudo = ?', whereArgs: [pseudo]);

    if (maps.isNotEmpty) {
      return maps[0]['level'] as int;
    } else {
      return null;
    }
  }

  Future<int> insertScore(String pseudo, int level, int essai) async {
    final db = await instance.database;
    return await db.insert(
      'pendu',
      {'pseudo': pseudo, 'level': level, 'essai': essai},
    );
  }

  Future<List<Score>> getScore() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('pendu');

    return List.generate(maps.length, (i) {
      return Score(
        id: maps[i]['id'],
        pseudo: maps[i]['pseudo'],
        numLevel: maps[i]['level'],
        score: maps[i]['essai'],
      );
    });
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('pendu');
  }
}