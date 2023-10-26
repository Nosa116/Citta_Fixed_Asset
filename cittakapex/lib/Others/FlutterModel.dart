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
   String supplierName;
   String assetUser;
   String assetUserName;
   String assetDetail;
   String assetManufacturersNum;
   String parentAssetCode;
   String lastMaintenanceDate;
   String purchaseDate;
   String assetLocation;
   String assetLocationName;
   String assetType;
   String assetTypeName;
   String branchCode;
   String branchName;

  AssetDetails(
      {required this.assetTag,
      required this.description,
      required this.fixedAssetCode,
      required this.manufacturer,
      required this.model,
      required this.assetspecs,
      required this.supplier,
      required this.supplierName,
       required this.assetUser,
      required this.assetUserName,
      required this.assetDetail,
      required this.assetManufacturersNum,
      required this.parentAssetCode,
      required this.lastMaintenanceDate,
      required this.purchaseDate,
      required this.assetLocation,
      required this.assetLocationName,
      required this.assetType,
      required this.assetTypeName,
      required this.branchCode,
      required this.branchName,
       });

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
        'supplierName: $supplierName, '
        'assetUser: $assetUser, '
        'assetUserName: $assetUserName, '
        'assetDetail: $assetDetail, '
        'assetManufacturersNum: $assetManufacturersNum, '
        'parentAssetCode: $parentAssetCode, '
        'lastMaintenanceDate: $lastMaintenanceDate, '
        'purchaseDate: $purchaseDate, '
        'assetLocation: $assetLocation, '
        'assetLocationName: $assetLocationName, '
        'assetType: $assetType'
        'assetTypeName: $assetTypeName'
        'branchName: $branchName'
        ')';
  }

  factory AssetDetails.fromJson(Map<String, dynamic> json) {
  return AssetDetails(
    assetTag: json['assetTag'] ?? 'Unknown',
    description: json['description'] ?? 'Description not available',
    fixedAssetCode: json['fixedAssetCode'] ?? 'Unknown',
    manufacturer: json['manufacturer'] ?? 'Unknown',
    model: json['model'] ?? 'Unknown',
    assetspecs: json['assetspecs'] ?? 'Unknown',
    supplier: json['supplier'] ?? 'Unknown',
    supplierName: json['supplierName'] ?? 'Unknown',
    assetUser: json['assetUser'] ?? 'Unknown',
    assetUserName: json['assetUserName'] ?? 'Unknown',
    assetDetail: json['assetDetail'] ?? 'Unknown',
    assetManufacturersNum: json['assetManufacturersNum'] ?? 'Unknown',
    parentAssetCode: json['parentAssetCode'] ?? 'Unknown',
    lastMaintenanceDate: json['lastMaintenanceDate'] ?? 'Unknown',
    purchaseDate: json['purchaseDate'] ?? 'Unknown',
    assetLocation: json['assetLocation'] ?? 'Unknown',
    assetLocationName: json['assetLocationName'] ?? 'Unknown',
    assetType: json['assetType'] ?? 'Unknown',
    assetTypeName: json['assetTypeName'] ?? 'Unknown',
    branchCode: json['branchCode'] ?? 'Unknown',
    branchName: json['branchName'] ?? 'Unknown',
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
      'SupplierName': supplierName,
      'assetUser': assetUser,
      'assetUserName': assetUserName,
      'Detail': assetDetail,
      'Manufacturer No': assetManufacturersNum,
      'Parent Code': parentAssetCode,
      'Last Maintenance Date': lastMaintenanceDate,
      'Purchase Date': purchaseDate,
      'assetLocation': assetLocation,
      'assetLocationName': assetLocationName,
      'Type': assetType,
      'branchName': branchName,
    };
  }
}
