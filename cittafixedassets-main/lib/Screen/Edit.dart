import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Others/FlutterModel.dart';

class Edit extends StatefulWidget {
  final String fixedAssetCode;

  const Edit({Key? key, required this.fixedAssetCode}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late AssetDetails _assetData = AssetDetails(
    assetTag: '',
    description: '',
    fixedAssetCode: '',
    manufacturer: '',
    model: '',
    assetspecs: '',
    supplier: '',
    assetUser: '',
    assetDetail: '',
    assetManufacturersNum: '',
    parentAssetCode: '',
    lastMaintenanceDate: '',
    purchaseDate: '',
    assetLocation: '',
    assetType: '',);
  bool _isEditing = false;
  late String _editedDescription; // Separate variable to hold edited description

  // Add TextEditingController for other fields if needed
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _manufacturerController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _specsController = TextEditingController();
  TextEditingController _supplierController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _manufacturerNoController = TextEditingController();
  TextEditingController _parentCodeController = TextEditingController();
  TextEditingController _lastMaintenanceDateController = TextEditingController();
  TextEditingController _purchaseDateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _editedDescription = ''; // Initialize the edited description
    _fetchAssetDetails();
  }

  Future<void> _fetchAssetDetails() async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetdetails?assetTag=0';
          //FixedAssetCode=${widget.fixedAssetCode}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final assetData = AssetDetails.fromJson(jsonResponse);
        setState(() {
          _assetData = assetData;
          _descriptionController.text = _assetData.description;
          _editedDescription = _assetData.description; // Initialize the edited description
          _manufacturerController.text = _assetData.manufacturer;
          _modelController.text = _assetData.model;
          _specsController.text = _assetData.assetspecs;
          _supplierController.text = _assetData.supplier;
          _userController.text = _assetData.assetUser;
          _detailController.text = _assetData.assetDetail;
          _manufacturerNoController.text = _assetData.assetManufacturersNum;
          _parentCodeController.text = _assetData.parentAssetCode;
          _lastMaintenanceDateController.text = _assetData.lastMaintenanceDate;
          _purchaseDateController.text = _assetData.purchaseDate;
          _locationController.text = _assetData.assetLocation;
          _typeController.text = _assetData.assetType;
        });
      } else {
        print("FAC is ${widget.fixedAssetCode}");
        throw Exception('Failed to load asset details');
      }
    } catch (e) {
      print('Error fetching asset details: $e');
    }
  }

  Future<void> _updateAssetDetails() async {
    try {
      // Prepare the updated data
      AssetDetails updatedData = AssetDetails(
        assetTag: _assetData.assetTag,
        description: _editedDescription, // Use the edited description
        fixedAssetCode: _assetData.fixedAssetCode,
        manufacturer: _manufacturerController.text,
        model: _modelController.text,
        assetspecs: _specsController.text,
        supplier: _supplierController.text,
        assetUser: _userController.text,
        assetDetail: _detailController.text,
        assetManufacturersNum: _manufacturerNoController.text,
        parentAssetCode: _parentCodeController.text,
        lastMaintenanceDate: _lastMaintenanceDateController.text,
        purchaseDate: _purchaseDateController.text,
        assetLocation: _locationController.text,
        assetType: _typeController.text,
      );

      // Perform the API update request
      // Adjust the URL and request type (PUT, POST, etc.) based on your API
      String updateUrl = 'https://your_api_url_here';
      final response = await http.put(
        Uri.parse(updateUrl),
        body: json.encode(updatedData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Show a success message or perform any other necessary actions
        print('Asset details updated successfully!');
      } else {
        throw Exception('Failed to update asset details');
      }
    } catch (e) {
      print('Error updating asset details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        backgroundColor: Colors.red,
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: () {
                _updateAssetDetails();
                // Implement your logic to request approval here
              },
              icon: const Icon(Icons.request_page),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField(
              'Asset Tag',
              _assetData.assetTag,
              enabled: false,
            ),
            buildTextField(
              'Description',
              _isEditing ? _editedDescription : _assetData.description,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _editedDescription = value; // Store the edited description
                });
              },
            ),
            buildTextField(
              'Fixed Asset Code',
              _assetData.fixedAssetCode,
              enabled: false,
            ),
            buildTextField(
              'Manufacturer',
              _manufacturerController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.manufacturer = value;
                });
              },
            ),
            buildTextField(
              'Model',
              _modelController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.model = value;
                });
              },
            ),
            buildTextField(
              'Specs',
              _specsController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetspecs = value;
                });
              },
            ),
            buildTextField(
              'Supplier',
              _supplierController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.supplier = value;
                });
              },
            ),
            buildTextField(
              'User',
              _userController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetUser = value;
                });
              },
            ),
            buildTextField(
              'Detail',
              _detailController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetDetail = value;
                });
              },
            ),
            buildTextField(
              'Manufacturer No',
              _manufacturerNoController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetManufacturersNum = value;
                });
              },
            ),
            buildTextField(
              'Parent Code',
              _parentCodeController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.parentAssetCode = value;
                });
              },
            ),
            buildTextField(
              'Last Maintenance Date',
              _lastMaintenanceDateController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.lastMaintenanceDate = value;
                });
              },
            ),
            buildTextField(
              'Purchase Date',
              _purchaseDateController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.purchaseDate = value;
                });
              },
            ),
            buildTextField(
              'Location',
              _locationController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetLocation = value;
                });
              },
            ),
            buildTextField(
              'Type',
              _typeController.text,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _assetData.assetType = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String value, {
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
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
            enabled: enabled,
            onChanged: onChanged,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              // Customize the appearance of the text field if needed
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
