import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_test_mobile/api/use_api.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/company_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';

void main() {
  final useApi = UseApi();

  test('testing try to get companies', () async {
    final companies = await useApi.fetchCompanies();
    expect(companies, isA<List<CompanyModel>>());
    expect(companies, isNotEmpty);
  });

  test('testing try to get locations', () async {
    final companies = await useApi.fetchCompanies();
    final company = companies[0];
    final locations = await useApi.fetchLocations(companyId: company.id ?? '');
    expect(locations, isA<List<LocationModel>>());
    expect(locations, isNotEmpty);
  });

  test('testing try to get assets', () async {
    final companies = await useApi.fetchCompanies();
    final company = companies[0];
    final assets = await useApi.fetchAssets(companyId: company.id ?? '');
    expect(assets, isA<List<AssetModel>>());
    expect(assets, isNotEmpty);
  });
}
