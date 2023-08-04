import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../Others/Constant.dart';
import '../Others/FlutterModel.dart';
import 'Edit.dart';

class Details extends StatefulWidget {
  final String fixedAssetCode;

  const Details({Key? key, required this.fixedAssetCode}) : super(key: key);

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
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assetDetails = fetchAssetDetails(widget.fixedAssetCode); // Use fixedAssetCode
  }

  Future<AssetDetails> fetchAssetDetails(String fixedAssetCode) async {
    String url =
        'https://citta.azure-api.net/Adron/api/FAsset/assetdetails?FixedAssetCode=${widget.fixedAssetCode}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('API Response for Asset Details: $jsonResponse');
      final assetData = AssetDetails.fromJson(jsonResponse);
      setState(() {
        _assetData = assetData;
      });
      return assetData;
    } else {
          print ("this is the FAC: $fixedAssetCode");

      throw Exception('Failed to load asset details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.red,
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
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && _assetData != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                 buildTextField('Asset Tag', _assetData!.assetTag),
                      buildTextField('Description', _assetData!.description),
                      buildTextField(
                          'Fixed Asset Code', _assetData!.fixedAssetCode),
                      buildTextField('Manufacturer', _assetData!.manufacturer),
                      buildTextField('Model', _assetData!.model),
                      buildTextField('Specs', _assetData!.assetspecs),
                      buildTextField('Supplier', _assetData!.supplier),
                      buildTextField('User', _assetData!.assetUser),
                      buildTextField('Detail', _assetData!.assetDetail),
                      buildTextField(
                          'Manufacturer No', _assetData!.assetManufacturersNum),
                      buildTextField(
                          'Parent Code', _assetData!.parentAssetCode),
                      buildTextField('Last Maintenance Date',
                          _assetData!.lastMaintenanceDate),
                      buildTextField('Purchase Date', _assetData!.purchaseDate),
                      buildTextField('Location', _assetData!.assetLocation),
                      buildTextField('Type', _assetData!.assetType),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextField(
            controller: TextEditingController(text: value),
            enabled: false,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
