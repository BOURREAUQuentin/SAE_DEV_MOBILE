import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseLocale {
  static final DatabaseLocale instance = DatabaseLocale._init();

  static Database? _database;

  DatabaseLocale._init();


  Future<Database> get database async {
    if (_database != null) return _database!;
    print("get");
    _database = await _initDB('sae.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print("initDB");
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
    await db.execute('DROP DATABASE sae.db');
  }

  // Méthode qui drop les tables CATEGORIE, DEMANDE, INDISPONIBILITE, PRET, PRODUIT
  Future<void> dropTables() async {
    final db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS INDISPONIBILITE');
    await db.execute('DROP TABLE IF EXISTS CATEGORIE');
    await db.execute('DROP TABLE IF EXISTS PRODUIT');
    await db.execute('DROP TABLE IF EXISTS DEMANDE');
    await db.execute('DROP TABLE IF EXISTS PRET');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CATEGORIE(
        idCategorie INTEGER PRIMARY KEY AUTOINCREMENT,
        nomCategorie TEXT
      )
    ''');

    // Création de la table PRODUIT
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PRODUIT(
        idProduit INTEGER PRIMARY KEY AUTOINCREMENT,
        nomProduit TEXT,
        descriptionProduit TEXT,
        lienImageProduit TEXT,
        idCategorie INTEGER,
        FOREIGN KEY(idCategorie) REFERENCES CATEGORIE(idCategorie)
      )
    ''');

    // Création de la table INDISPONIBILITE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS INDISPONIBILITE(
        idIndisponibilite INTEGER PRIMARY KEY AUTOINCREMENT,
        dateDebut TEXT,
        dateFin TEXT,
        idProduit INTEGER,
        FOREIGN KEY(idProduit) REFERENCES PRODUIT(idProduit)
      )
    ''');

    // Création de la table PRET
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PRET(
        idPret INTEGER PRIMARY KEY AUTOINCREMENT,
        titrePret TEXT,
        descriptionPret TEXT,
        datePublication TEXT,
        statutPret TEXT,
        dateDebutPret TEXT,
        dateFinPret TEXT,
        idProduit INTEGER,
        FOREIGN KEY(idProduit) REFERENCES PRODUIT(idProduit)
      )
    ''');

    // Création de la table DEMANDE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS DEMANDE(
        idDemande INTEGER PRIMARY KEY AUTOINCREMENT,
        titreDemande TEXT,
        descriptionDemande TEXT,
        datePublication TEXT,
        statutDemande TEXT,
        dateDebutDemande TEXT,
        dateFinDemande TEXT,
        idCategorie INTEGER,
        FOREIGN KEY(idCategorie) REFERENCES CATEGORIE(idCategorie)
      )
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    print("creation");
    // Création de la table CATEGORIE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CATEGORIE(
        idCategorie INTEGER PRIMARY KEY AUTOINCREMENT,
        nomCategorie TEXT
      )
    ''');

    // Création de la table PRODUIT
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PRODUIT(
        idProduit INTEGER PRIMARY KEY AUTOINCREMENT,
        nomProduit TEXT,
        descriptionProduit TEXT,
        lienImageProduit TEXT,
        idCategorie INTEGER,
        FOREIGN KEY(idCategorie) REFERENCES CATEGORIE(idCategorie)
      )
    ''');

    // Création de la table INDISPONIBILITE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS INDISPONIBILITE(
        idIndisponibilite INTEGER PRIMARY KEY AUTOINCREMENT,
        dateDebut TEXT,
        dateFin TEXT,
        idProduit INTEGER,
        FOREIGN KEY(idProduit) REFERENCES PRODUIT(idProduit)
      )
    ''');

    // Création de la table PRET
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PRET(
        idPret INTEGER PRIMARY KEY AUTOINCREMENT,
        titrePret TEXT,
        descriptionPret TEXT,
        datePublication TEXT,
        statutPret TEXT,
        dateDebutPret TEXT,
        dateFinPret TEXT,
        idProduit INTEGER,
        FOREIGN KEY(idProduit) REFERENCES PRODUIT(idProduit)
      )
    ''');

    // Création de la table DEMANDE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS DEMANDE(
        idDemande INTEGER PRIMARY KEY AUTOINCREMENT,
        titreDemande TEXT,
        descriptionDemande TEXT,
        datePublication TEXT,
        statutDemande TEXT,
        dateDebutDemande TEXT,
        dateFinDemande TEXT,
        idCategorie INTEGER,
        FOREIGN KEY(idCategorie) REFERENCES CATEGORIE(idCategorie)
      )
    ''');
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('sae');
  }

  /* --------------------------------- Méthodes de getteurs --------------------------  */
  Future<List<Map<String, dynamic>>> getProduits() async {
    final db = await instance.database;
    return db.query('PRODUIT');
  }

  Future<List<Map<String, dynamic>>> getDemandes() async {
    final db = await instance.database;
    return db.query('DEMANDE');
  }

  Future<List<Map<String, dynamic>>> getPrets() async {
    final db = await instance.database;
    return db.query('PRET');
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await instance.database;
    return db.query('CATEGORIE');
  }

  /* --------------------------------- Méthodes de setteurs --------------------------  */
  Future<int> insertProduit(String nomProduit, String descriptionProduit, String lienImageProduit, int idCategorie) async {
    final db = await instance.database;
    return db.insert(
      'PRODUIT',
      {
        'nomProduit': nomProduit,
        'descriptionProduit': descriptionProduit,
        'lienImageProduit': lienImageProduit,
        'idCategorie': idCategorie,
      },
    );
  }

  Future<int> insertDemande(String titreDemande, String descriptionDemande, String datePublication, String statutDemande, String dateDebutDemande, String dateFinDemande, int idCategorie) async {
    final db = await instance.database;
    return db.insert(
      'DEMANDE',
      {
        'titreDemande': titreDemande,
        'descriptionDemande': descriptionDemande,
        'datePublication': datePublication,
        'statutDemande': statutDemande,
        'dateDebutDemande': dateDebutDemande,
        'dateFinDemande': dateFinDemande,
        'idCategorie': idCategorie,
      },
    );
  }

  Future<int> insertPret(String titrePret, String descriptionPret, String datePublication, String statutPret, String dateDebutPret, String dateFinPret, int idProduit) async {
    final db = await instance.database;
    return db.insert(
      'PRET',
      {
        'titrePret': titrePret,
        'descriptionPret': descriptionPret,
        'datePublication': datePublication,
        'statutPret': statutPret,
        'dateDebutPret': dateDebutPret,
        'dateFinPret': dateFinPret,
        'idProduit': idProduit,
      },
    );
  }

  Future<int> insertCategorie(String nomCategorie) async {
    final db = await instance.database;

    final categorieExistante = await db.query('CATEGORIE', where: 'nomCategorie = ?', whereArgs: [nomCategorie]);
    if (categorieExistante.isNotEmpty) {
      return categorieExistante.first['idCategorie'] as int;
    }

    final idCategorie = await db.insert('CATEGORIE', {'nomCategorie': nomCategorie});

    return idCategorie;
  }
}