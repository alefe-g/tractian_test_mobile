import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';
import 'package:tractian_test_mobile/services/fetch_assets_tree_service.dart';

void main() {
  group('FetchAssetsTreeService Tests', () {
    late FetchAssetsTreeService fetchAssetsTreeService;

    setUp(() {
      final locations = [
        LocationModel(id: '1', name: 'Location 1', parentId: null),
        LocationModel(id: '2', name: 'Location 2', parentId: '1'),
        LocationModel(id: '3', name: 'Location 3', parentId: '1'),
      ];

      final assets = [
        AssetModel(id: 'a1', locationId: '1', parentId: null),
        AssetModel(id: 'a2', locationId: '2', parentId: 'a1'),
        AssetModel(id: 'a3', locationId: '3', parentId: 'a1'),
      ];

      fetchAssetsTreeService =
          FetchAssetsTreeService(locations: locations, assets: assets);
    });

    test('should fetch locations in tree structure', () {
      final locations = fetchAssetsTreeService.locations;

      expect(locations.length, 1);
      expect(locations[0].id, '1');
    });

    test('should fetch location children correctly', () {
      final locations = fetchAssetsTreeService.locations;
      final location1 = locations.firstWhere((location) => location.id == '1');

      expect(location1.children?.length, 2);
      expect(location1.children?[0].id, '2');
      expect(location1.children?[1].id, '3');
    });

    test('should fetch assets for location correctly', () {
      final locations = fetchAssetsTreeService.locations;
      final location1 = locations.firstWhere((location) => location.id == '1');

      expect(location1.assets?.length, 1);
      expect(location1.assets?[0].id, 'a1');
      expect(location1.assets?[0].children?.length, 2);
    });

    test('should filter locations and assets by search query', () {
      const searchQuery = 'Location 2';
      fetchAssetsTreeService.searchQuery = searchQuery;
      final locations = fetchAssetsTreeService.locations;

      expect(locations.length, 1);
    });
  });
}
