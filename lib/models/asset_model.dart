class AssetModel {
  String? gatewayId;
  String? id;
  String? locationId;
  String? name;
  String? parentId;
  String? sensorId;
  String? sensorType;
  String? status;
  String? companyId;
  List<AssetModel>? _children;

  AssetModel({
    this.gatewayId,
    this.id,
    this.locationId,
    this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.companyId,
  });

  List<AssetModel>? get children => _children;

  set children(List<AssetModel>? children) {
    if (children == null) return;
    _children = children;
  }

  AssetModel.fromJson({
    required Map<String, dynamic> json,
    required String companyId,
  }) {
    gatewayId = json['gatewayId'];
    id = json['id'];
    locationId = json['locationId'];
    name = json['name'];
    parentId = json['parentId'];
    sensorId = json['sensorId'];
    sensorType = json['sensorType'];
    status = json['status'];
    companyId = companyId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['gatewayId'] = gatewayId;
    data['id'] = id;
    data['locationId'] = locationId;
    data['name'] = name;
    data['parentId'] = parentId;
    data['sensorId'] = sensorId;
    data['sensorType'] = sensorType;
    data['status'] = status;
    data['companyId'] = companyId;
    return data;
  }
}
