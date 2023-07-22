class AssetDetails {
  String assetTag;
  String description;
  String fixedAssetCode;
  String assetLocation;
  String manufacturer;
  String assetUser;
  String model;
  String assetspecs;

  AssetDetails({
    required this.assetTag,
    required this.description,
    required this.fixedAssetCode,
    required this.assetLocation,
    required this.manufacturer,
    required this.assetUser,
    required this.model,
    required this.assetspecs,
  });

  // Create a factory method to parse JSON and construct the model
  factory AssetDetails.fromJson(Map<String, dynamic> json) {
    return AssetDetails(
      assetTag: json['assetTag'],
      description: json['description'],
      fixedAssetCode: json['fixedAssetCode'],
      assetLocation: json['assetLocation'],
      manufacturer: json['manufacturer'],
      assetUser: json['assetUser'],
      model: json['model'],
      assetspecs: json['assetspecs'],
    );
  }

  // Create a method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'assetTag': assetTag,
      'description': description,
      'fixedAssetCode': fixedAssetCode,
      'assetLocation': assetLocation,
      'manufacturer': manufacturer,
      'assetUser': assetUser,
      'model': model,
      'assetspecs': assetspecs,
    };
  }
}
