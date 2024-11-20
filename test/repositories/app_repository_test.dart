import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tractian_test_mobile/helpers/db.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/company_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';
import 'package:tractian_test_mobile/repositories/app_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Database? db;
  AppRepository? repository;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    db = await DB.instance.database;
    repository = AppRepository();
  });

  setUp(() async {
    if (db != null) {
      await db!.transaction((txn) async {
        await txn.delete('companies');
        await txn.delete('locations');
        await txn.delete('assets');
      });
    }
  });

  test('Test if upsert in companies is found', () async {
    List<CompanyModel> companies = [
      CompanyModel(id: '1', name: 'company A'),
      CompanyModel(id: '2', name: 'company B'),
      CompanyModel(id: '3', name: 'company C'),
    ];
    List<Object?>? results =
        await repository?.upsertCompanies(companies: companies);
    expect(results, isNotNull);
    expect(results?.length, 3);

    companies = [
      CompanyModel(id: '2', name: 'company B'),
      CompanyModel(id: '3', name: 'company C'),
    ];
    await repository?.upsertCompanies(companies: companies);
    final result = await db?.query('companies');
    expect(result?.length, 3);
  });

  test('Test if upsert in locations is found', () async {
    await repository?.upsertCompanies(companies: [
      CompanyModel(id: '1', name: 'temporary company'),
    ]);

    List<LocationModel> locations = [
      LocationModel(
          id: '1', name: 'location A', parentId: null, companyId: '1'),
      LocationModel(id: '2', name: 'location B', parentId: '1', companyId: '1'),
      LocationModel(
          id: '3', name: 'location C', parentId: null, companyId: '1'),
    ];

    List<Object?>? results =
        await repository?.upsertLocations(locations: locations);
    expect(results, isNotNull);
    expect(results?.length, 3);

    var result = await db?.query('locations');
    expect(result?.length, 3);

    locations = [
      LocationModel(
          id: '2', name: 'updated location B', parentId: '1', companyId: '1'),
      LocationModel(
          id: '4', name: 'location D', parentId: null, companyId: '1'),
    ];
    await repository?.upsertLocations(locations: locations);

    result = await db?.query('locations');
    expect(result?.length, 4);

    final updatedLocation =
        result?.firstWhere((loc) => loc['id'] == '2')['name'];
    expect(updatedLocation, 'updated location B');
  });

  test('Test if upsert in assets is found', () async {
    await repository?.upsertCompanies(companies: [
      CompanyModel(id: '1', name: 'temporary company'),
    ]);

    List<AssetModel> assets = [
      AssetModel(
        id: '1',
        gatewayId: 'gw1',
        locationId: 'loc1',
        name: 'asset A',
        parentId: null,
        sensorId: 'sensor1',
        sensorType: 'type1',
        status: 'active',
        companyId: '1',
      ),
      AssetModel(
        id: '2',
        gatewayId: 'gw2',
        locationId: 'loc2',
        name: 'asset B',
        parentId: '1',
        sensorId: 'sensor2',
        sensorType: 'type2',
        status: 'inactive',
        companyId: '1',
      ),
    ];

    List<Object?>? results = await repository?.upsertAssets(assets: assets);
    expect(results, isNotNull);
    expect(results?.length, 2);

    var result = await db?.query('assets');
    expect(result?.length, 2);

    assets = [
      AssetModel(
        id: '2',
        gatewayId: 'gw2',
        locationId: 'loc2',
        name: 'updated asset B',
        parentId: '1',
        sensorId: 'sensor2',
        sensorType: 'type2',
        status: 'inactive',
        companyId: '1',
      ),
      AssetModel(
        id: '3',
        gatewayId: 'gw3',
        locationId: 'loc3',
        name: 'asset C',
        parentId: null,
        sensorId: 'sensor3',
        sensorType: 'type3',
        status: 'active',
        companyId: '1',
      ),
    ];
    await repository?.upsertAssets(assets: assets);

    result = await db?.query('assets');
    expect(result?.length, 3);

    final updatedAsset =
        result?.firstWhere((asset) => asset['id'] == '2')['name'];
    expect(updatedAsset, 'updated asset B');
  });

  test('Test fetchLocationsByCompanyId returns correct locations', () async {
    await repository?.upsertCompanies(companies: [
      CompanyModel(id: '1', name: 'Test Company'),
    ]);

    List<LocationModel> locations = [
      LocationModel(
        id: '1',
        name: 'Location A',
        parentId: null,
        companyId: '1',
      ),
      LocationModel(
        id: '2',
        name: 'Location B',
        parentId: '1',
        companyId: '1',
      ),
      LocationModel(
        id: '3',
        name: 'Location C',
        parentId: null,
        companyId: '1',
      ),
    ];

    await repository?.upsertLocations(locations: locations);

    List<LocationModel> fetchedLocations =
        await repository!.fetchLocationsByCompanyId(companyId: '1');

    expect(fetchedLocations.length, 3);
    expect(fetchedLocations[0].name, 'Location A');
    expect(fetchedLocations[1].name, 'Location B');
    expect(fetchedLocations[2].name, 'Location C');
  });

  test('Test fetchAssetsByLocationIds returns correct assets', () async {
    await repository?.upsertCompanies(companies: [
      CompanyModel(id: '1', name: 'Test Company'),
    ]);

    List<LocationModel> locations = [
      LocationModel(
        id: '1',
        name: 'Location A',
        parentId: null,
        companyId: '1',
      ),
      LocationModel(
        id: '2',
        name: 'Location B',
        parentId: '1',
        companyId: '1',
      ),
    ];
    await repository?.upsertLocations(locations: locations);

    List<AssetModel> assets = [
      AssetModel(
        id: '1',
        gatewayId: 'gw1',
        locationId: '1',
        name: 'Asset A',
        parentId: null,
        sensorId: 'sensor1',
        sensorType: 'type1',
        status: 'active',
        companyId: '1',
      ),
      AssetModel(
        id: '2',
        gatewayId: 'gw2',
        locationId: '2',
        name: 'Asset B',
        parentId: '1',
        sensorId: 'sensor2',
        sensorType: 'type2',
        status: 'inactive',
        companyId: '1',
      ),
      AssetModel(
        id: '3',
        gatewayId: 'gw3',
        locationId: '1',
        name: 'Asset C',
        parentId: null,
        sensorId: 'sensor3',
        sensorType: 'type3',
        status: 'active',
        companyId: '1',
      ),
    ];
    await repository?.upsertAssets(assets: assets);

    List<AssetModel> fetchedAssets = await repository!
        .fetchAssetsByLocationIds(companyId: '1', locationIds: ['1', '2']);

    expect(fetchedAssets.length, 3);
    expect(fetchedAssets[0].name, 'Asset A');
    expect(fetchedAssets[1].name, 'Asset B');
    expect(fetchedAssets[2].name, 'Asset C');
  });
}
