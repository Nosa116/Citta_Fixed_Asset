import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../Others/FlutterModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Import the typeahead package



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
    assetUser: '',
    assetDetail: '',
    assetManufacturersNum: '',
    parentAssetCode: '',
    lastMaintenanceDate: '',
    purchaseDate: '',
    assetLocation: '',
    assetType: '',
  );
  bool _isEditing = false;
  //bool _isRequestingApproval = false;
  bool _hasChanges = false;

  late String
      _editedDescription; // Separate variable to hold edited description

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
  TextEditingController _lastMaintenanceDateController =
      TextEditingController();
  TextEditingController _purchaseDateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();



// Separate variables for each field to hold the edited values
  String _editedAssetTag = '';
  String _editedManufacturer = '';
  String _editedModel = '';
  String _editedSpecs = '';
  String _editedSupplier = '';
  String _editedUser = '';
  String _editedDetail = '';
  String _editedManufacturerNo = '';
  String _editedParentCode = '';
  String _editedLastMaintenanceDate = '';
  String _editedPurchaseDate = '';
  String _editedLocation = '';
  String _editedType = '';

  String _selectedUser = ''; // Variable to store the selected user

  List<String> _assetStaffs = [];
  List<String> _supplierList = [];
  List<String> _locationsList = [];

  @override
  void initState() {
    super.initState();
    _editedDescription = ''; // Initialize the edited description
    _fetchAssetDetails();   
  }

  String formatDate(String inputDate) {
    if (inputDate.length == 8) {
      // Assuming the inputDate is in the format "YYYYMMDD"
      String year = inputDate.substring(0, 4);
      String month = inputDate.substring(4, 6);
      String day = inputDate.substring(6, 8);
      return '$day/$month/$year';
    }
    // Return the original inputDate if the length is not as expected
    return inputDate;
  }


Future<List<String>> _fetchLocationsByQuery(String query) async {
  try {
    String url = 'https://citta.azure-api.net/Adron/api/FAsset/assetlocation?location=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as List;
      List<String> locations = jsonResponse.map((item) {
        String description = item['description']?.toString() ?? '';
        String locationCode = item['locationCode']?.toString() ?? '';
        return '$description - $locationCode';
      }).toList();
      return locations;
    } else {
      throw Exception('Failed to fetch locations');
    }
  } catch (e) {
    print('Error fetching locations: $e');
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
        // Use the 'description' field instead of 'staffName'
        return supplier['description']?.toString() ?? '';
      }).toList();
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
          _editedSupplier = _assetData.supplier;

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
      // Check if any required field is empty
      // if (_editedDescription.isEmpty ||
      //     _manufacturerController.text.isEmpty ||
      //     _modelController.text.isEmpty ||
      //     _supplierController.text.isEmpty ||
      //     _userController.text.isEmpty ||
      //     _detailController.text.isEmpty ||
      //     _manufacturerNoController.text.isEmpty ||
      //     _parentCodeController.text.isEmpty ||
      //     _lastMaintenanceDateController.text.isEmpty ||
      //     _purchaseDateController.text.isEmpty ||
      //     _locationController.text.isEmpty ||
      //     _typeController.text.isEmpty) {
      //   print('Please fill all required fields.');
      //   return;
      // }

      // Prepare the updated data
      AssetDetails updatedData = AssetDetails(
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
      );

      // Print the updated data before sending it to the API
      print('Updated AssetDetails: $updatedData');

      // Perform the API update request using POST method
      String updateUrl =
          'https://citta.azure-api.net/Adron/api/FAsset/updateassets';
      final response = await http.post(
        Uri.parse(updateUrl),
        body: json.encode(updatedData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Show a success message or perform any other necessary actions
        print('Request for approval sent successfully!');
      } else {
        print(
            'Failed to update asset details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
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
          if (_isEditing || !_isEditing)
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
                right: 8.0,
              ), // Add padding to create space between the button and app bar
              child: SizedBox(
                width: 80, // Set the desired width
                //height: 4,
                child: ElevatedButton(
                  onPressed: () {
                    if (_hasChanges) {
                      // Disable the button if already clicked
                      return;
                    } else {
                      setState(() {
                        _hasChanges = false;
                        _isEditing = false;
                      });
                      _updateAssetDetails();
                      // Implement your logic to request approval here

                      // Reset the button state after a short delay (you can adjust the duration as needed)
                      // Future.delayed(Duration(seconds: 2), () {
                      //   setState(() {
                      //     _isRequestingApproval = false;
                      //   });
                      // });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    //             fixedSize: Size(0, 50), // Set the desired width and height
                  ),
                  child: Text(
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
        
        child: ListView(
          children: [
            buildTextField(
              'Fixed Asset Code',
              _assetData.fixedAssetCode,
              enabled: false,
            ),
            buildTextField(
              'Asset Tag',
              _editedAssetTag.isNotEmpty
                  ? _editedAssetTag
                  : _assetData.assetTag,
              enabled: _isEditing,
              suffixIcon: IconButton(
                onPressed: _isEditing ? _scanAssetTag : null,
                icon: Icon(Icons.qr_code_scanner),
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
            buildDropdownSupplier(_supplierList, _editedSupplier),
             buildTypeaheadDropdown(_assetStaffs, _selectedUser), // Use the new method for the "Users" field

            buildTextField(
              'Asset Detail',
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
              _editedPurchaseDate.isNotEmpty
                  ? _editedPurchaseDate
                  : formatDate(_assetData.purchaseDate),
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _editedPurchaseDate = value;
                });
              },
            ),
            buildTypeaheadDropdownLocation(_locationsList, _editedLocation), // Use the new method for the "Location" field

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

  Widget buildTypeaheadDropdown(List<String> userList, String selectedUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TypeAheadFormField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _userController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            suggestionsCallback: (String pattern) async {
              // Call the API to fetch the suggestions based on the input pattern
              return _fetchAssetStaffsByQuery(pattern);
            },
            itemBuilder: (BuildContext context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) {
              // Set the selected user when a suggestion is selected
              setState(() {
                _selectedUser = suggestion;
                _userController.text = suggestion; // Update the text field with the selected user
              });
            },
            noItemsFoundBuilder: (BuildContext context) {
              return SizedBox.shrink(); // Return an empty container if no suggestions are found
            },
          ),
        ],
      ),
    );
  }


  Widget buildDropdownSupplier(List<String> supplierList, String selectedSupplier) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _supplierController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
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
            // Set the selected supplier when a suggestion is selected
            setState(() {
              _editedSupplier = suggestion;
              _supplierController.text =
                  suggestion; // Update the text field with the selected supplier
            });
          },
          noItemsFoundBuilder: (BuildContext context) {
            return SizedBox.shrink(); // Return an empty container if no suggestions are found
          },
        ),
      ],
    ),
  );
}



Widget buildTypeaheadDropdownLocation(
  List<String> locationsList,
  String selectedLocation,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _locationController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          suggestionsCallback: (String pattern) async {
            // Call the API to fetch the suggestions based on the input pattern
            return _fetchLocationsByQuery(pattern);
          },
          itemBuilder: (BuildContext context, String suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (String suggestion) {
            // Set the selected location when a suggestion is selected
            setState(() {
              _editedLocation = suggestion;
              _locationController.text = suggestion; // Update the text field with the selected location
            });
          },
          noItemsFoundBuilder: (BuildContext context) {
            return SizedBox.shrink(); // Return an empty container if no suggestions are found
          },
        ),
      ],
    ),
  );
}



  

Widget buildDropdown(List<String> userList, String selectedUser) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return userList;
            } else {
              return _fetchAssetStaffsByQuery(textEditingValue.text);
            }
          },
          onSelected: (String newValue) {
            setState(() {
              _selectedUser = newValue;
            });
          },
          displayStringForOption: (String option) => option,
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              onChanged: (value) {
                // We do not need to do anything here since onChanged of TextField will handle it
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            );
          },
          optionsMaxHeight: 200, // Set the maximum height of the dropdown
        ),
      ],
    ),
  );
}










  Widget buildTextField(
    String label,
    String value, {
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
            style: TextStyle(
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
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
