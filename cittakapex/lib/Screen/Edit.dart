// ignore_for_file: avoid_print

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
  final TextEditingController _manufacturerNoController =
      TextEditingController();
  final TextEditingController _parentCodeController = TextEditingController();
  final TextEditingController _lastMaintenanceDateController =
      TextEditingController();
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
  String _editedtranstype='';
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

  void generateReference() {
    // Adjust the format and separator as needed
    _generatedReference =
        '${_assetData.fixedAssetCode} -- ${_assetData.lastMaintenanceDate}';
  }

final List<String> assetOptions = [
  'Asset Verification - 180',
  'Change of Asset Location - 124',
  'Asset adoption - 125',
];


  Future<List<String>> _fetchLocationsByQuery(String query) async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetlocation?location=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        List<String> locations = jsonResponse.map((item) {
          String description = item['description']?.toString() ?? '';
          String locationCode = item['locationCode']?.toString() ?? '';
          return '$description - $locationCode';
        }).toList();
        _isFetchingDataError = false; // Reset the error flag
        return locations;
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      _isFetchingDataError = true; // Set the error flag

      return []; // Return an empty list in case of an error
    }
  }

  Future<List<String>> _fetchAssetStaffsByQuery(String query) async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetstaffs?staff=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('success');
        print('Response body: ${response.body}');
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        List<String> staffs = jsonResponse.map((item) {
          String staffNumber = item['staffNumber']?.toString() ?? '';
          String staffName = item['staffName']?.toString() ?? '';
          return '$staffName - $staffNumber';
        }).toList();
        _isFetchingDataError = false; // Reset the error flag
        return staffs;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch asset staffs');
      }
    } catch (e) {
      print('Error fetching asset staffs: $e');
      _isFetchingDataError = true; // Set the error flag
      return []; // Return an empty list in case of error
    }
  }

  Future<List<String>> _fetchBranchByQuery(String query) async {
    try {
      String url =
          'https://citta.azure-api.net/Adron/api/FAsset/assetbranches?branchcode=a';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('success');
        print('Response body: ${response.body}');
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        List<String> branches= jsonResponse.map((item) {
          String BranchNumber = item['parameterType']?.toString() ?? '';
          String BranchName = item['parameterName']?.toString() ?? '';
          return '$BranchName - $BranchNumber';
        }).toList();
        _isFetchingDataError = false; // Reset the error flag
        return branches;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to branches');
      }
    } catch (e) {
      print('Error fetching asset staffs: $e');
      _isFetchingDataError = true; // Set the error flag
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

  Future<void> _scanAssetTag() async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Customize the scan UI color
        "Cancel", // Button text to cancel the scan
        true, // Enable flash option while scanning
        ScanMode.QR, // Set the scan mode (you can use other modes too)
      );

      if (scanResult != "-1") {
        // Update the Asset Tag with the scanned value
        setState(() {
          _assetData.assetTag = scanResult;
        });
      }
    } catch (e) {
      print('Error scanning asset tag: $e');
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

        "targetLocation": _editedLocation.isNotEmpty ? _editedLocation : _locationController.text,

        "transfer_type": _editedtranstype.isNotEmpty ? _editedtranstype : _transtypeController.text,    
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
                     if (_formKey.currentState!.validate()) {
              // The form is valid, submit the data
              _updateAssetDetails();
            }
                    if (_hasChanges) {
                      // Disable the button if already clicked
                      return;
                    } else {
                      //print('not done');
                      setState(() {
                        _hasChanges = false;
                        _isEditing = false;
                      });
                     // _updateAssetDetails();
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
                        fontSize: 10),
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
              buildTypeaheadDropdowntransType(assetOptions, _editedtranstypename), // Use the new method for the "Location" field
              buildTextField(
                'Barcode',
                _editedAssetTag.isNotEmpty
                    ? _editedAssetTag
                    : _assetData.assetTag,
                enabled: _isEditing,
                suffixIcon: IconButton(
                  onPressed: _isEditing ? _scanAssetTag : null,
                  icon: const Icon(Icons.qr_code_scanner),
                ),
              ),
              buildTextField(
                'Description',
                _editedDescription.isNotEmpty
                    ? _editedDescription
                    : _assetData.description,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _editedDescription = value;
                  });
                },
              ),
              buildTextField(
                'Manufacturer',
                _editedManufacturer.isNotEmpty
                    ? _editedManufacturer
                    : _assetData.manufacturer,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _editedManufacturer = value;
                  });
                },
              ),
              buildTextField(
                'Model',
                _editedModel.isNotEmpty ? _editedModel : _assetData.model,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _assetData.model = value;
                  });
                },
              ),
              buildTextField(
                'Specs',
                _editedSpecs.isNotEmpty ? _editedSpecs : _assetData.assetspecs,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
                    _editedSpecs = value;
                  });
                },
                // Set the desired number of lines for the "Specs" field
              ),
              buildTypeaheadDropdownSupplier(_supplierList, _editedSupplierName),

              buildTypeaheadDropdown(_assetStaffs,_selectedUser), // Use the new method for the "Users" field
              buildTypeaheadDropdownBranch(_branchlist,_selectedBranch), // Use the new method for the "Users" field
              buildTypeaheadDropdownLocation(_locationsList, _editedLocation), // Use the new method for the "Location" field
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

              // buildTextField(
              //   'Manufacturer No',
              //   _manufacturerNoController.text,
              //   enabled: _isEditing,
              //   onChanged: (value) {
              //     setState(() {
              //       _assetData.assetManufacturersNum = value;
              //     });
              //   },
              // ),
              // buildTextField(
              //   'Parent Code',
              //   _editedParentCode.isNotEmpty
              //       ? _editedParentCode
              //       : _assetData.parentAssetCode,
              //   enabled: _isEditing,
              //   onChanged: (value) {
              //     setState(() {
              //       _editedParentCode = value;
              //     });
              //   },
              // ),
              buildTextField('Reference',_generatedReference,enabled: false,),

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
            

              buildTextField( 'Fixed Asset Code', _assetData.fixedAssetCode, enabled: false,),
              buildTextField('Type', _typeController.text, enabled: false,
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
                List<String> staffs = await _fetchAssetStaffsByQuery(pattern);
                return staffs;
              },
              itemBuilder: (BuildContext context, String suggestion) {
                final List<String> parts =
                    suggestion.split(' - '); // Split name and number
                final String staffName =
                    parts[0]; // Staff name is the first part
                // Staff number is the second part, you can ignore it in the UI
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _editedUser =
                          parts[1]; // Update the selected staff number
                      _selectedUser =
                          staffName; // Update the selected staff name
                      userTextController.text =
                          staffName; // Update the text controller's value
                    });
                  },
                  child: ListTile(
                    title: Text(staffName), // Display only the staff name
                  ),
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

  Widget buildTypeaheadDropdownSupplier(
    List<String> supplierList,
    String selectedSupplier,
  ) {
    TextEditingController supplierTextController =
        TextEditingController(text: _editedSupplierName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Supplier',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SingleChildScrollView(
            // Add a SingleChildScrollView to make the suggestions scrollable
            child: TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: supplierTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                enabled: false, // Enable the text field only when editing
              ),
              suggestionsCallback: (String pattern) async {
                // Call the API to fetch the suggestions based on the input pattern
                return _fetchSuppliersByQuery(pattern);
              },
              itemBuilder: (BuildContext context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                // Set the selected supplier and supplier name when a suggestion is selected
                setState(() {
                  _editedSupplier = suggestion;
                  _editedSupplierName =
                      suggestion; // Update the selected supplier name

                  // Update the text controller's value with the selected suggestion
                  supplierTextController.text = suggestion;
                });
              },
              noItemsFoundBuilder: (BuildContext context) {
                return const SizedBox
                    .shrink(); // Return an empty container if no suggestions are found
              },
            ),
          ),
        ],
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
                return _fetchLocationsByQuery(pattern);
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
                  },
                  child: ListTile(
                    title: Text(description), // Display only the description
                  ),
                );
              },
              onSuggestionSelected: (String suggestion) {
                // No action needed here
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
final GlobalKey<FormState> _formmKey = GlobalKey<FormState>();

Widget buildTypeaheadDropdowntransType(List<String> suggestions, String selectedValue) {
  TextEditingController _transtypeController = TextEditingController(text: selectedValue);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Select Transaction Type',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      TypeAheadFormField<String>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _transtypeController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          enabled:true,
        ),
        suggestionsCallback: (String pattern) async {
          return assetOptions
              .where((option) =>
                  option.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (BuildContext context, String suggestion) {
          final List<String> parts = suggestion.split(' - ');
          final String description = parts[0];
          final String code = parts[1]; // Extract the code part

          return GestureDetector(
            onTap: () {
              setState(() {
                _editedtranstype = code; // Update with the code part
               _transtypeController.text = description;
                _editedtranstypename = description;
                print(_editedtranstype);
                print(_editedtranstypename);
                print(description);
              });
            },
            child: ListTile(
              title: Text(description),
            ),
          );
        },
        onSuggestionSelected: (String description) {
          // No action needed here       
        },
        
        noItemsFoundBuilder: (BuildContext context) {
          return const SizedBox.shrink();
        },

         validator: (String? value) {
          // Validator function
          if (value == null || value.isEmpty) {
            return 'Please select a transaction type';
          }
          return null; // Return null if validation succeeds
        },
      ),
    ],
  );
}


Widget buildTypeaheadDropdownBranch(List<String> branchList, String selectedBranch) {
    TextEditingController _parentCodeController =
        TextEditingController(text: _selectedBranch);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Branch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _parentCodeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                enabled:
                    _isEditing, // Set the enabled property based on edit mode
              ),
              suggestionsCallback: (String pattern) async {
                List<String> branches = await _fetchBranchByQuery(pattern);
                return branches;
              },
              itemBuilder: (BuildContext context, String suggestion) {
                final List<String> parts =
                    suggestion.split(' - '); // Split name and number
                final String branchname =
                    parts[0]; // Staff name is the first part
                // Staff number is the second part, you can ignore it in the UI
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _editedParentCode =
                          parts[1]; // Update the selected staff number
                      _selectedBranch =
                          branchname; // Update the selected staff name
                      _parentCodeController.text =
                          branchname; // Update the text controller's value
                    });
                  },
                  child: ListTile(
                    title: Text(branchname), // Display only the staff name
                  ),
                );
              },
              onSuggestionSelected: (String suggestion) {
                setState(() {
                  _selectedBranch = suggestion;
                  _parentCodeController.text = suggestion;
                  _editedParentCode = suggestion; // Update _editedUser
                });
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

