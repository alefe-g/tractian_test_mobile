import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'app_database.db',
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute(_companies);
    await db.execute(_locations);
    await db.execute(_assets);
  }

  String get _companies => '''
  CREATE TABLE IF NOT EXISTS companies (
    id TEXT PRIMARY KEY,
    name TEXT
  );
''';

  String get _locations => '''
  CREATE TABLE IF NOT EXISTS locations (
    id TEXT PRIMARY KEY,
    name TEXT,
    parentId TEXT,
    companyId TEXT,
    FOREIGN KEY (parentId) REFERENCES locations (id) ON DELETE CASCADE,
    FOREIGN KEY (companyId) REFERENCES companies (id) ON DELETE CASCADE
  );
''';

  String get _assets => '''
  CREATE TABLE IF NOT EXISTS assets (
    id TEXT PRIMARY KEY,
    gatewayId TEXT,
    locationId TEXT,
    name TEXT,
    parentId TEXT,
    sensorId TEXT,
    sensorType TEXT,
    status TEXT,
    companyId TEXT,
    FOREIGN KEY (locationId) REFERENCES locations (id) ON DELETE SET NULL,
    FOREIGN KEY (parentId) REFERENCES assets (id) ON DELETE CASCADE,
    FOREIGN KEY (companyId) REFERENCES companies (id) ON DELETE CASCADE
  );
''';
}
