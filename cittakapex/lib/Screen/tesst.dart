import 'dart:convert';
import 'package:cittakpex/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../Others/FlutterModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../Others/Methods.dart'; // Import the typeahead package

class Edit extends StatefulWidget {
  final String fixedAssetCode;
  final String staffCode;
  final String Orgcode;

  const Edit(
      {required this.staffCode,
      required this.Orgcode,
      required this.fixedAssetCode});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late AssetDetails _assetData = AssetDetails(
    fixedAssetCode: '',
    assetTag: '',
    description: '',
    manufacturer: '',
    model: '',
    assetspecs: '',
    supplier: '',
    supplierName: '',
    assetUser: '',
    assetDetail: '',
    assetManufacturersNum: '',
    parentAssetCode: '',
    lastMaintenanceDate: '',
    purchaseDate: '',
    assetLocation: '',
    assetType: '',
    assetLocationName: '',
    assetTypeName: '',
  );
  bool _isEditing = false;
  bool _isFetchingDataError = false;
  bool _hasChanges = false;
  bool isEditedAndSaved = false;
  final _formKey = GlobalKey<FormState>();

  late String
      _editedDescription; // Separate variable to hold edited description

  // Add TextEditingController for other fields if needed
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _specsController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _manufacturerNoController = TextEditingController();
  final TextEditingController _parentCodeController = TextEditingController();
  final TextEditingController _lastMaintenanceDateController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _transtypeController = TextEditingController();

// Separate variables for each field to hold the edited values
  String _editedAssetTag = '';
  String _editedManufacturer = '';
  final String _editedModel = '';
  String _editedSpecs = '';
  String _editedSupplier = '';
  String _editedSupplierName = '';
  String _editedUser = '';
  String _editedBranch = '';
  String _editedDetail = '';
  final String _editedManufacturerNo = '';
  String _editedParentCode = '';
  String _editedLastMaintenanceDate = '';
  String _editedPurchaseDate = '';
  String _editedLocation = '';
  String _editedLocationName = '';
  final String _editedType = '';
  String _editedtranstype = '';
  String _generatedReference = '';

  String _selectedUser = ''; // Variable to store the selected user
  String _selectedBranch = ''; // Variable to store the selected user
  String _editedtranstypename = '';

  final List<String> _assetStaffs = [];
  final List<String> _branchlist = [];
  final List<String> _supplierList = [];
  final List<String> _locationsList = [];

  @override
  void initState() {
    super.initState();
    _editedDescription = ''; // Initialize the edited description
    _fetchAssetDetails();

    // Set _editedSupplierName to the initial supplier name from API response
  }

  Future<void> _fetchAssetDetails() async {
    try {
      String url =
          'https://citta.azure-api.net/api/FAsset/assetdetails?FixedAssetCode=${widget.fixedAssetCode}&Org_code=${widget.Orgcode}&Loginstaff=${widget.staffCode}';
      //FixedAssetCode=${widget.fixedAssetCode}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final assetData = AssetDetails.fromJson(jsonResponse);

        setState(() {
          _assetData = assetData;
          _descriptionController.text = _assetData.description;

          _selectedUser =
              _assetData.assetUser; // Set the selected user from assetData

          _editedDescription =
              _assetData.description; // Initialize the edited description
          //_editedSupplier = _assetData.supplier;
          _editedSupplierName = _assetData.supplierName;
          // Update _editedLocationName with the initial asset location name from API response
          _editedLocationName = _assetData.assetLocation;
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
          _locationController.text = _assetData.assetLocationName;

          // _typeController.text = _assetData.assetType;
          _typeController.text = _assetData.assetTypeName;

          generateReference();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing Data'),
          duration:
              Duration(milliseconds: 700), // Specify the duration in seconds
        ),
      );

      // Prepare the updated data
      AssetDetails pdata = AssetDetails(
        fixedAssetCode: _assetData.fixedAssetCode,
        assetTag:
            _editedAssetTag.isNotEmpty ? _editedAssetTag : _assetData.assetTag,
        description: _editedDescription,
        manufacturer: _editedManufacturer.isNotEmpty
            ? _editedManufacturer
            : _manufacturerController.text,
        model: _editedModel.isNotEmpty
            ? _editedModel
            : _assetData
                .model, //  model: _editedModel.isNotEmpty ? _editedModel : _assetData.model,
        assetspecs:
            _editedSpecs.isNotEmpty ? _editedSpecs : _specsController.text,
        supplier: _editedSupplier.isNotEmpty
            ? _editedSupplier
            : _supplierController.text,
        supplierName: _editedSupplierName.isNotEmpty
            ? _editedSupplierName
            : _supplierController.text,
        assetUser: _editedUser.isNotEmpty ? _editedUser : _userController.text,
        assetDetail:
            _editedDetail.isNotEmpty ? _editedDetail : _detailController.text,
        assetManufacturersNum: _editedManufacturerNo.isNotEmpty
            ? _editedManufacturerNo
            : _manufacturerNoController.text,
        parentAssetCode: _editedParentCode.isNotEmpty
            ? _editedParentCode
            : _parentCodeController.text,
        lastMaintenanceDate: _editedLastMaintenanceDate.isNotEmpty
            ? _editedLastMaintenanceDate
            : _lastMaintenanceDateController.text,
        purchaseDate: _editedPurchaseDate.isNotEmpty
            ? _editedPurchaseDate
            : _purchaseDateController.text,
        assetLocation: _editedLocation.isNotEmpty
            ? _editedLocation
            : _locationController.text,
        assetType: _editedType.isNotEmpty ? _editedType : _typeController.text,
        assetLocationName: _editedLocation.isNotEmpty
            ? _editedLocation
            : _locationController.text,
        assetTypeName:
            _editedType.isNotEmpty ? _editedType : _typeController.text,
      );

      print('Updated AssetDetails: $pdata');

      Map<String, dynamic> updatedData = {
        "fixedAssetCode": _assetData.fixedAssetCode,
        "assetTag": pdata
            .assetTag, //_editedAssetTag.isNotEmpty ? _editedAssetTag : _assetData.assetTag,
        "description": _editedDescription,
        "manufacturerTrans": pdata.manufacturer,
        "modelTrans": _editedModel.isNotEmpty
            ? _editedModel
            : _assetData
                .model, //  model: _editedModel.isNotEmpty ? _editedModel : _assetData.model,
        "specsTrans":
            _editedSpecs.isNotEmpty ? _editedSpecs : _specsController.text,

        "sourceUser": pdata.assetUser,
        "manual_reference": _generatedReference,

        "maintenance_date": pdata.lastMaintenanceDate,
        "sourceBranch": pdata.assetDetail,
        "targetBranch": pdata.parentAssetCode,

        "targetLocation": _editedLocation.isNotEmpty
            ? _editedLocation
            : _locationController.text,

        "transfer_type": _editedtranstype.isNotEmpty
            ? _editedtranstype
            : _transtypeController.text,
        "Org_code": widget.Orgcode,
        "Loginstaff": widget.staffCode
      };

      // Print the updated data before sending it to the API
      print('Updated AssetDetails: $updatedData');

      // Perform the API update request using POST method
      String updateUrl = 'https://citta.azure-api.net/api/FAsset/updateassets';
      final response = await http.post(
        Uri.parse(updateUrl),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Request for approval sent successfully!');

        setState(() {
          _hasChanges =
              false; // Reset _hasChanges to false after successful update
          _isEditing = false;
        });

        // Display a SnackBar with the "submitted" message
        const snackBar = SnackBar(
          content: Text('submitted'),
          duration: Duration(seconds: 3), // Set the duration for the SnackBar
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    staffCode: '',
                    Orgcode: '',
                  )), // Replace with your home screen widget
        );
      } else {
        print(updatedData);
        print(
            'Failed to update asset details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        const snackBar = SnackBar(
          content: Text('Failed to submit '),
          duration: Duration(seconds: 3), // Set the duration for the SnackBar
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        throw Exception('Failed to update asset details');
      }
    } catch (e) {
      print('Error updating asset details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTypeaheadDropdownLocation(_locationsList,
                  _editedLocation), // Use the new method for the "Location" field

              buildTextField(
                'Fixed Asset Code',
                _assetData.fixedAssetCode,
                enabled: false,
              ),
              buildTextField(
                'Type',
                _typeController.text,
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    _assetData.assetTypeName = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTypeaheadDropdownLocation(
    List<String> locationsList,
    String selectedLocation,
  ) {
    TextEditingController locationTextController =
        TextEditingController(text: _editedLocationName);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: locationTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                enabled: _isEditing, // Enable the text field only when editing
              ),
              suggestionsCallback: (String pattern) async {
                // Call the API to fetch the suggestions based on the input pattern
                if (pattern.length >= 3) {
                  // Call the API to fetch the suggestions based on the input pattern
                  return _fetchLocationsByQuery(pattern);
                } else {
                  return []; // Return an empty list if input is less than 3 characters
                }
              },
              itemBuilder: (BuildContext context, String suggestion) {
                final List<String> parts =
                    suggestion.split(' - '); // Split description and code
                final String description =
                    parts[0]; // Description is the first part
                // Location code is the second part, you can ignore it in the UI
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _editedLocation =
                          parts[1]; // Update the selected location code
                      _editedLocationName =
                          description; // Update the selected location name
                      locationTextController.text =
                          description; // Update the text controller's value
                    });
                    // Close the dropdown when a suggestion is selected
                    FocusScope.of(context).unfocus();
                  },
                  child: ListTile(
                    title: Text(description), // Display only the description
                  ),
                );
              },
              onSuggestionSelected: (String suggestion) {
                // No action needed here
                 // Close the dropdown when a suggestion is selected
                    FocusScope.of(context).unfocus();
              },
              noItemsFoundBuilder: (BuildContext context) {
                if (_isFetchingDataError) {
                  return const Text(
                    'Error fetching data, please try again.',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
