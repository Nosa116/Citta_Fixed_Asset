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

  const Edit({Key? key, required this.fixedAssetCode}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}


late String _selectedStaffNumber = '';


class _EditState extends State<Edit> {
  late AssetDetails _assetData = AssetDetails(
   
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
  //bool _isRequestingApproval = false;
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

  final TextEditingController _typeController = TextEditingController();

// Separate variables for each field to hold the edited values
  String _editedAssetTag = '';
  String _editedManufacturer = '';
  final String _editedModel = '';
  String _editedSpecs = '';
  String _editedSupplier = '';
  String _editedSupplierName = '';
  String _editedUser = '';
  String _editedDetail = '';
  final String _editedManufacturerNo = '';
  String _editedParentCode = '';
  String _editedLastMaintenanceDate = '';
  String _editedPurchaseDate = '';
  String _editedLocation = '';
  String _editedLocationName = '';
  final String _editedType = '';
  String _generatedReference = '';

  String _selectedUser = ''; // Variable to store the selected user

  final List<String> _assetStaffs = [];
  final List<String> _supplierList = [];
  final List<String> _locationsList = [];

  @override
  void initState() {
    super.initState();
    _editedDescription = ''; // Initialize the edited description
    _fetchAssetDetails();
    

    // Set _editedSupplierName to the initial supplier name from API response
  }

  void generateReference() {
  // Adjust the format and separator as needed
  _generatedReference = '${_assetData.fixedAssetCode} -- ${_assetData.lastMaintenanceDate }';
}

  


  Future<List<String>> _fetchAssetStaffsByQuery(String query) async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetstaffs?staff=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('success');
        print('Response body: ${response.body}');
        final jsonResponse = json.decode(response.body);
        List<String> staffs = (jsonResponse as List).map((staff) {
          // Use the 'staffName' field instead of 'name'
          return staff['staffName']?.toString() ?? '';
        }).toList();
        return staffs;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch asset staffs');
      }
    } catch (e) {
      print('Error fetching asset staffs: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<List<String>> _fetchSuppliersByQuery(String query) async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetsupplier?supplier=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<String> suppliers = (jsonResponse as List).map((supplier) {
          return supplier['description']?.toString() ?? '';
        }).toList();
        print(suppliers);
        return suppliers;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch suppliers');
      }
    } catch (e) {
      print('Error fetching suppliers: $e');
      return []; // Return an empty list in case of error
    }
  }

  

  Future<void> _fetchAssetDetails() async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetdetails?FixedAssetCode=${widget.fixedAssetCode}';
      //FixedAssetCode=${widget.fixedAssetCode}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final assetData = AssetDetails.fromJson(jsonResponse);

        //Format the date time format
        if (_assetData.purchaseDate.length == 8) {
          _assetData.purchaseDate = formatDate(_assetData.purchaseDate);
        }

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
          _editedLocationName = _assetData.assetLocationName;
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

      
      AssetDetails pdata = AssetDetails(
        fixedAssetCode: _assetData.fixedAssetCode,
        assetTag:
            _editedAssetTag.isNotEmpty ? _editedAssetTag : _assetData.assetTag,
        description: _editedDescription,
        manufacturer: _editedManufacturer.isNotEmpty
            ? _editedManufacturer
            : _manufacturerController.text,
        
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
        "sourceBranch": _editedLocation.isNotEmpty
            ? _editedLocation
            : _locationController.text,
       
      };

      // Print the updated data before sending it to the API
      print('Updated AssetDetails: $updatedData');

      // Perform the API update request using POST method
      String updateUrl =
          'https://citta.azure-api.net/Adron/api/FAsset/updateassets';
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
              builder: (context) =>
                  HomeScreen()), // Replace with your home screen widget
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
      appBar: AppBar(
        title: const Text('Edit'),
        backgroundColor: Colors.red,
        actions: [
          if (!_isEditing)
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
                right: 8.0,
              ), // Add padding to create space between the button and app bar
              child: SizedBox(
                width: 80, // Set the desired width
                //height: 4,
                //  Visibility(visible: _hasChanges, ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_hasChanges) {
                      // Disable the button if already clicked
                      return;
                    } else {
                      //print('not done');
                      setState(() {
                        _hasChanges = false;
                        _isEditing = false;
                      });
                      _updateAssetDetails();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    //             fixedSize: Size(0, 50), // Set the desired width and height
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: IconButton(
              onPressed: () {
              
                setState(() {
                  _isEditing = !_isEditing;
                  _hasChanges =
                      _isEditing; // Enable the "Request Approval" button only if changes are made
                });
              },
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
            
              buildTypeaheadDropdownSupplier(
                  _supplierList, _editedSupplierName),

              buildTypeaheadDropdown(_assetStaffs,
                  _selectedUser), // Use the new method for the "Users" field
              buildTypeaheadDropdownLocation(_locationsList,
                  _editedLocation), // Use the new method for the "Location" field
              buildTextField(
                'Asset Detail',
                _editedDetail.isNotEmpty
                    ? _editedDetail
                    : _assetData.assetDetail,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _editedDetail = value;
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
                _editedParentCode.isNotEmpty
                    ? _editedParentCode
                    : _assetData.parentAssetCode,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _editedParentCode = value;
                  });
                },
              ),
              buildTextField(
                'Reference',
                _generatedReference,
                enabled: false,
              ),

              buildTextField(
                'Last Maintenance Date',
                _lastMaintenanceDateController.text,
                hintText: 'DD/MM/YYYY',
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _assetData.lastMaintenanceDate = value;
                    _lastMaintenanceDateController.text = value;
                    generateReference();
                  });
                },
              ),
          

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

  Widget buildTypeaheadDropdown(List<String> userList, String selectedUser) {
    TextEditingController userTextController =
        TextEditingController(text: _selectedUser);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asset User',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: userTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                enabled:
                    _isEditing, // Set the enabled property based on edit mode
              ),
              suggestionsCallback: (String pattern) async {
                return _fetchAssetStaffsByQuery(pattern);
              },
              itemBuilder: (BuildContext context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {

                

                setState(() {
                  _selectedUser = suggestion;
                  userTextController.text = suggestion;
                  _editedUser = suggestion; // Update _editedUser
                });
              },
              noItemsFoundBuilder: (BuildContext context) {
                return const SizedBox.shrink();
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
    String hintText = '',
    bool enabled = true,
    ValueChanged<String>? onChanged,
    IconButton? suffixIcon,
  }) {
    TextEditingController controller = TextEditingController(text: value);
    bool isFieldBeingEdited = true; // Track if the field is being edited

    if (enabled) {
      controller.value = controller.value.copyWith(
        // Set the selection to the beginning when the field becomes enabled
        selection: TextSelection.collapsed(offset: controller.text.length),
      );
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
            controller: controller,
            enabled: enabled,
            onChanged: (value) {
              if (enabled) {
                setState(() {
                  isFieldBeingEdited; // Mark the field as being edited
                  controller.text = value; // Update the controller value
                });
              }

              onChanged
                  ?.call(value); // Invoke the onChanged callback if provided
            },
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hintText,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
