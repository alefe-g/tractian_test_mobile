import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';

class FetchAssetsTreeService {
  late List<LocationModel> _locations;
  late List<AssetModel> _assets;
  final String? searchQuery;
  final String? status;

  FetchAssetsTreeService({
    required List<LocationModel> locations,
    required List<AssetModel> assets,
    this.searchQuery,
    this.status,
  }) {
    _locations = locations;
    _assets = assets;
  }

  List<LocationModel> get locations => _fetchLocationsInTree();

  List<LocationModel> _fetchLocationsInTree() {
    if (status != null) {
      _assets = _filterAssetByStatus();
    }

    if (searchQuery != null) {
      _assets = _filterAssetByName();
      _locations = _filterLocationsByName();
    }

    if (searchQuery != null) {}

    final results = _locations
        .where(
          (element) => element.parentId == null,
        )
        .toList();

    results.forEach(_fetchLocationChildren);
    results.forEach(_fetchAssetsByLocation);
    return results;
  }

  _fetchAssetParents(AssetModel asset, List<AssetModel> assets) {
    final parent = _assets.where((e) => e.id == asset.parentId).firstOrNull;

    if (parent == null) {
      return;
    }

    if (!assets.contains(parent)) {
      assets.add(parent);
    }

    if (parent.parentId != null) {
      _fetchAssetParents(parent, assets);
    }
  }

  _fetchLocationParents(LocationModel location, List<LocationModel> locations) {
    final parent = _locations.where((e) => e.id == location.parentId).firstOrNull;

    if (parent == null) {
      return;
    }

    if (!locations.contains(parent)) {
      locations.add(parent);
    }

    if (parent.parentId != null) {
      _fetchLocationParents(parent, locations);
    }
  }

  List<AssetModel> _filterAssetByName() {
    var assets = _assets
        .where((e) => e.name!.toLowerCase().contains(searchQuery!))
        .toList();

    final parents = <AssetModel>[];

    for (final asset in assets) {
      _fetchAssetParents(asset, parents);
    }

    assets += parents.where((e) => !assets.contains(e)).toList();

    return assets;
  }

  List<LocationModel> _filterLocationsByName() {
    var locations = _locations
        .where((e) => e.name!.toLowerCase().contains(searchQuery!))
        .toList();

    final ids = _assets
        .where((e) => e.locationId != null)
        .map((e) => e.locationId)
        .toList();

    locations += _locations
        .where((e) => ids.contains(e.id))
        .where((e) => !locations.contains(e))
        .toList();

    final parents = <LocationModel>[];

    for (final location in locations) {
      _fetchLocationParents(location, parents);
    }

    locations += parents.where((e) => !locations.contains(e)).toList();

    return locations;
  }

  List<AssetModel> _filterAssetByStatus() {
    var assets = _assets.where((e) => e.status == status).toList();

    final parents = <AssetModel>[];

    for (final asset in assets) {
      _fetchAssetParents(asset, parents);
    }

    assets += parents.where((e) => !assets.contains(e)).toList();

    return assets;
  }

  _fetchLocationChildren(LocationModel location) {
    final children = _locations
        .where(
          (item) => item.parentId == location.id && item.parentId != null,
        )
        .toList();

    children.forEach(_fetchLocationChildren);
    children.forEach(_fetchAssetsByLocation);

    location.children = children;
  }

  _fetchAssetsByLocation(LocationModel location) {
    final assets = _assets.where((item) {
      final haveNoParent = item.parentId == null;
      final isFromThisLocation = item.locationId == location.id;
      return haveNoParent && isFromThisLocation;
    }).toList();
    assets.forEach(_fetchAssetsChildren);
    location.assets = assets;
  }

  _fetchAssetsChildren(AssetModel asset) {
    final children = _assets.where((item) {
      return item.parentId == asset.id && item.parentId != null;
    }).toList();
    children.forEach(_fetchAssetsChildren);
    asset.children = children;
  }
}
