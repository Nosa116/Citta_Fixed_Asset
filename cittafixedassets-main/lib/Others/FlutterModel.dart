class Organisation {
  final String? org;

  Organisation({
    this.org,
  });
}

class Asset {
  final String assetTag;
  final String description;
  final String fixedAssetCode;

 Asset({
    required this.assetTag,
    required this.description, // Update the parameter to accept null
    required this.fixedAssetCode,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
  return Asset(
    assetTag: json['assetTag'] ?? 'Unknown',
    description: json['description'] ?? 'Description not available',
    fixedAssetCode: json['fixedAssetCode'] ?? 'Unknown',
  );
}

}

class AssetDetails {
   String assetTag;
   String description;
   String fixedAssetCode;
   String manufacturer;
   String model;
   String assetspecs;
   String supplier;
   String assetUser;
   String assetDetail;
   String assetManufacturersNum;
   String parentAssetCode;
   String lastMaintenanceDate;
   String purchaseDate;
   String assetLocation;
   String assetType;

  AssetDetails(
      {required this.assetTag,
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
      required this.model});

 @override
  String toString() {
    return 'AssetDetails('
        'assetTag: $assetTag, '
        'description: $description, '
        'fixedAssetCode: $fixedAssetCode, '
        'manufacturer: $manufacturer, '
        'model: $model, '
        'assetspecs: $assetspecs, '
        'supplier: $supplier, '
        'assetUser: $assetUser, '
        'assetDetail: $assetDetail, '
        'assetManufacturersNum: $assetManufacturersNum, '
        'parentAssetCode: $parentAssetCode, '
        'lastMaintenanceDate: $lastMaintenanceDate, '
        'purchaseDate: $purchaseDate, '
        'assetLocation: $assetLocation, '
        'assetType: $assetType'
        ')';
  }

  factory AssetDetails.fromJson(Map<String, dynamic> json) {
  return AssetDetails(
    assetTag: json['assetTag'] ?? 'Unknown',
    description: json['description'] ?? 'Description not available',
    fixedAssetCode: json['fixedAssetCode'] ?? 'Unknown',
    manufacturer: json['manufacturer'] ?? 'Unknown',
    assetDetail: json['assetDetail'] ?? 'Unknown',
    assetLocation: json['assetLocation'] ?? 'Unknown',
    assetManufacturersNum: json['assetManufacturersNum'] ?? 'Unknown',
    assetType: json['assetType'] ?? 'Unknown',
    assetspecs: json['assetspecs'] ?? 'Unknown',
    assetUser: json['assetUser'] ?? 'Unknown',
    lastMaintenanceDate: json['lastMaintenanceDate'] ?? 'Unknown',
    parentAssetCode: json['parentAssetCode'] ?? 'Unknown',
    purchaseDate: json['purchaseDate'] ?? 'Unknown',
    supplier: json['supplier'] ?? 'Unknown',
    model: json['model'] ?? 'Unknown',
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
