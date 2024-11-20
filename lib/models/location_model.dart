import 'package:tractian_test_mobile/models/asset_model.dart';

class LocationModel {
  String? id;
  String? name;
  String? parentId;
  String? companyId;
  List<LocationModel>? _children;
  List<AssetModel>? _assets;

  LocationModel({this.id, this.name, this.parentId, this.companyId});

  List<AssetModel>? get assets => _assets;

  List<LocationModel>? get children => _children;

  set children(List<LocationModel>? children) {
    if (children == null) return;
    _children = children;
  }

  set assets(List<AssetModel>? asset) {
    if (asset == null) return;
    _assets = asset;
  }

  LocationModel.fromJson({
    required Map<String, dynamic> json,
    required String companyId,
  }) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'];
    companyId = companyId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['parentId'] = parentId;
    data['companyId'] = companyId;
    return data;
  }
}
