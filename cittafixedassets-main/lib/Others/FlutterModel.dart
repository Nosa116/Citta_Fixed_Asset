class Organisation {
  final String? org;

  Organisation({
    this.org,
  });
  }
class Asset {
  final String assetTag;
  final String description;

  Asset({required this.assetTag, required this.description});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetTag: json['assetTag'] ?? 'Unknown',
      description: json['description'] ?? 'Unknown',
    );
  }
}
class AssetDetails {
  final String assetTag;
  final String description;
  final String fixedAssetCode;
  final String manufacturer;
  final String model;
  final String assetspecs;
  final String supplier;
  final String assetUser;
  final String assetDetail;
  final String assetManufacturersNum;
  final String parentAssetCode;
  final String lastMaintenanceDate;
  final String purchaseDate;
  final String assetLocation;
  final String assetType;

  AssetDetails({
    required this.assetTag,
    required this.description,
    required this.fixedAssetCode,
    required this.manufacturer,
    required this.assetDetail,
    required this.assetLocation,
    required this.assetManufacturersNum,
    required this.assetType,
    required this.assetspecs,
    required this.assetUser,
    required this.lastMaintenanceDate,
    required this.parentAssetCode,
    required this.purchaseDate,
    required this.supplier,
    required this.model
  });

  factory AssetDetails.fromJson(Map<String, dynamic> json) {
    return AssetDetails(
      assetTag: json['assetTag'],
      description: json['description'],
      fixedAssetCode: json['fixedAssetCode'],
      manufacturer: json['manufacturer'],
      assetDetail: json['assetDetail'],
      assetLocation: json['assetLocation'],
      assetManufacturersNum: json['assetManufacturersNum'],
      assetType: json['assetType'],
      model: json['model'],
      supplier: json['supplier'],
      assetspecs: json['assetspecs'],
      assetUser: json['assetUser'],
      lastMaintenanceDate: json['lastMaintenanceDate'],
      parentAssetCode: json['parentAssetCode'],
      purchaseDate: json['purchaseDate']
    );
  }

 Map<String, dynamic> toJson() {
  return {
    'Asset Tag': assetTag,
    'Description': description,
    'Fixed Asset': fixedAssetCode,
    'Manufacturer': manufacturer,
    'Model': model,
    'Specs': assetspecs,
    'Supplier': supplier,
    'User': assetUser,
    'Detail': assetDetail,
    'Manufacturer No': assetManufacturersNum,
    'Parent Code': parentAssetCode,
    'Last Maintenance Date': lastMaintenanceDate,
    'Purchase Date': purchaseDate,
    'Location': assetLocation,
    'Type': assetType,
  };
}

}