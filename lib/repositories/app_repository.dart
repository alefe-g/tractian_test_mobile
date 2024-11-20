import 'package:sqflite/sqflite.dart';
import 'package:tractian_test_mobile/helpers/db.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/company_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';

class AppRepository {

  Future<List<Object?>> upsertCompanies({
    required List<CompanyModel> companies,
  }) async {
    final db = await DB.instance.database;
    final batch = db.batch();
    for (final company in companies) {
      batch.insert(
        'companies',
        company.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return await batch.commit();
  }

  Future<List<Object?>> upsertLocations({
    required List<LocationModel> locations,
  }) async {
    final db = await DB.instance.database;
    final batch = db.batch();
    for (final location in locations) {
      batch.insert(
        'locations',
        location.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return await batch.commit();
  }

  Future<List<Object?>> upsertAssets({
    required List<AssetModel> assets,
  }) async {
    final db = await DB.instance.database;
    final batch = db.batch();
    for (final asset in assets) {
      batch.insert(
        'assets',
        asset.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return await batch.commit();
  }

  Future<List<CompanyModel>> fetchCompanies() async {
    final db = await DB.instance.database;
    final results = await db.query('companies');
    return results.map((company) => CompanyModel.fromJson(company)).toList();
  }

  Future<List<LocationModel>> fetchLocationsByCompanyId({
    required String companyId,
  }) async {
    final db = await DB.instance.database;
    final results = await db.query(
      'locations',
      where: "companyId = '$companyId'",
    );
    return results
        .map((location) => LocationModel.fromJson(
              json: location,
              companyId: companyId,
            ))
        .toList();
  }

  Future<List<AssetModel>> fetchAssetsByLocationIds({
    required String companyId,
    required List<String> locationIds,
  }) async {
    final db = await DB.instance.database;
    final results = await db.query(
      'assets',
      where: "locationId IN (${List.filled(locationIds.length, '?').join(',')}) AND companyId = '$companyId'",
      whereArgs: locationIds,
    );
    return results
        .map((asset) => AssetModel.fromJson(
              json: asset,
              companyId: companyId,
            ))
        .toList();
  }
}
