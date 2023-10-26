import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../Others/Constant.dart';
import '../Others/FlutterModel.dart';
//import '../Others/Methods.dart';
import 'Edit.dart';

class Details extends StatefulWidget {
  final String fixedAssetCode;
  final String staffCode;
  final String Orgcode;
  const Details(
      {required this.staffCode,
      required this.Orgcode,
      required this.fixedAssetCode});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<AssetDetails> assetDetails;
  AssetDetails? _assetData;

  void navigateToEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edit(
          fixedAssetCode: widget.fixedAssetCode,
          staffCode: widget.staffCode,
          Orgcode: widget.Orgcode,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assetDetails =
        fetchAssetDetails(widget.fixedAssetCode); // Use fixedAssetCode
  }

  String formatPurchaseDate(String purchaseDate) {
    if (purchaseDate.length == 8) {
      final year = purchaseDate.substring(0, 4);
      final month = purchaseDate.substring(4, 6);
      final day = purchaseDate.substring(6, 8);
      return '$day/$month/$year';
    }
    return purchaseDate;
  }

  Future<AssetDetails> fetchAssetDetails(String fixedAssetCode) async {
    String url =
        'https://citta.azure-api.net/api/FAsset/assetdetails?FixedAssetCode=${widget.fixedAssetCode}&Org_code=${widget.Orgcode}&Loginstaff=${widget.staffCode}';

    final response = await http.get(Uri.parse(url));
    print(widget.Orgcode);
    print(widget.staffCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('API Response for Asset Details: $jsonResponse');
      final assetData = AssetDetails.fromJson(jsonResponse);

      // Format the purchase date
      assetData.purchaseDate = formatPurchaseDate(assetData.purchaseDate);

      setState(() {
        _assetData = assetData;
      });
      return assetData;
    } else {
      print("this is the FAC: $fixedAssetCode");

      throw Exception('Failed to load asset details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            onPressed: () {
              navigateToEditScreen();
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FutureBuilder<AssetDetails>(
        future: assetDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Try Again (Error): ${snapshot.error}');
          } else if (snapshot.hasData && _assetData != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildTextField('Fixed Asset Code', _assetData!.fixedAssetCode),
                  buildTextField('Type', _assetData!.assetTypeName),
                  buildTextField('Barcode', _assetData!.assetTag),
                  buildTextField('Description', _assetData!.description),
                  buildTextField('Manufacturer', _assetData!.manufacturer),
                  buildTextField('Model', _assetData!.model),
                  buildTextField('Specs', _assetData!.assetspecs),
                  buildTextField('Supplier', _assetData!.supplier),
                  buildTextField('Asset User', _assetData!.assetUserName),
                  buildTextField('Detail', _assetData!.assetDetail),
                  buildTextField('Manufacturer No', _assetData!.assetManufacturersNum),
                  buildTextField('Reference', _assetData!.parentAssetCode),
                  buildTextField('Last Maintenance Date', _assetData!.lastMaintenanceDate),
                  buildTextField('Purchase Date', _assetData!.purchaseDate),
                  buildTextField('Location', _assetData!.assetLocationName),
                  buildTextField('Branch', _assetData!.branchName),
                  // Add other fields using buildTextField as shown above
                ],
              ),
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    if (label == 'Supplier') {
      value = _assetData!
          .supplierName; // Use supplierName value instead of supplier
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextField(
            controller: TextEditingController(text: value),
            enabled: false,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
