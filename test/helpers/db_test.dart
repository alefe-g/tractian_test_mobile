import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_test_mobile/helpers/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
  });

  group('DB Tests', () {
    test('Database initialization', () async {
      final db = await DB.instance.database;
      expect(db, isA<Database>());
    });

    test('Tables creation', () async {
      final db = await DB.instance.database;
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");

      expect(
        tables.map((table) => table['name']),
        containsAll(['companies', 'locations', 'assets']),
      );

      await db.close();
    });
  });
}
