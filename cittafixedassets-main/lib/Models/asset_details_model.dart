class AssetDetails {
  String fixedAssetCode;
  String description;
  String assetspecs;
  String model;
  String manufacturer;
  String assetTag;
  String assetUser;
  String assetLocation;

  AssetDetails({
    required this.fixedAssetCode,
    required this.description,
    required this.assetspecs,
    required this.model,
    required this.manufacturer,
    required this.assetTag,
    required this.assetUser,
    required this.assetLocation,
  });

  // Create a factory method to parse JSON and construct the model
  factory AssetDetails.fromJson(Map<String, dynamic> json) {
    return AssetDetails(
      fixedAssetCode: json['fixedAssetCode'],
      description: json['description'],
      assetspecs: json['assetspecs'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      assetTag: json['assetTag'],
      assetUser: json['assetUser'],
      assetLocation: json['assetLocation'],
    );
  }

  set assetDetail(String assetDetail) {}

  set supplier(String supplier) {}

  // Create a method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'fixedAssetCode': fixedAssetCode,
      'description': description,
      'assetspecs': assetspecs,
      'model': model,
      'manufacturer': manufacturer,
      'assetTag': assetTag,
      'assetUser': assetUser,
      'assetLocation': assetLocation,
    };
  }
}
