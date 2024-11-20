import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/company_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';

class UseApi {
  final _scheme = 'https';
  final _host = 'fake-api.tractian.com';

  Future<List<AssetModel>> fetchAssets({required String companyId}) async {
    final uri = Uri(
      scheme: _scheme,
      host: _host,
      path: '/companies/$companyId/assets',
    );

    try {
      final response = await http.get(uri);
      List responseBody = jsonDecode(response.body);
      return responseBody
          .map((asset) => AssetModel.fromJson(
                json: asset,
                companyId: companyId,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationModel>> fetchLocations(
      {required String companyId}) async {
    final uri = Uri(
      scheme: _scheme,
      host: _host,
      path: '/companies/$companyId/locations',
    );

    try {
      final response = await http.get(uri);
      List responseBody = jsonDecode(response.body);
      return responseBody
          .map((location) => LocationModel.fromJson(
                json: location,
                companyId: companyId,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CompanyModel>> fetchCompanies() async {
    final uri = Uri(
      scheme: _scheme,
      host: _host,
      path: '/companies',
    );

    try {
      final response = await http.get(uri);
      List responseBody = jsonDecode(response.body);
      return responseBody
          .map((company) => CompanyModel.fromJson(company))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
