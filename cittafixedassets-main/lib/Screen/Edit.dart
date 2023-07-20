import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Others/FlutterModel.dart';

class Edit extends StatefulWidget {
  final String assetTag;
  final String description;

  const Edit({
    required this.assetTag,
    required this.description,
  });

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _fixedAssetCode = TextEditingController();
  final TextEditingController _manufacturer = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _specs = TextEditingController();
  final TextEditingController _sourcelocation = TextEditingController();
  final TextEditingController _sourcebranch = TextEditingController();
  final TextEditingController _staff = TextEditingController();

  AssetDetails? assetDetails;
  late String assetUser;
  List<String> staffNames = []; // List to store staff names
  String selectedStaffName = ''; // Currently selected staff name

  List<String> branchNames = []; // List to store branch names
  String selectedBranchName = ''; // Currently selected branch name
  String selectedstaffName = ''; // Currently selected branch name

  bool requestFailed = false; // Variable to track if the request failed
  String requestResult = '';
  bool isDataFetched = false; // Variable to track if data fetching is complete
  bool _isButtonEnabled = true; // Variable to track button's enabled state

  @override
  void initState() {
    super.initState();
    _description.text = widget.description;
    fetchAssetDetails();
    fetchData();
  }

  Future<void> fetchAssetDetails() async {
    final url =
        'https://cittafixedassetphone-apim.azure-api.net/assetdetails?assetTag=${widget.assetTag}&assetName=${widget.description}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          final assetJson = responseData[0];
          assetDetails = AssetDetails.fromJson(assetJson);
          if (isDataFetched) {
            _fixedAssetCode.text = assetDetails!.fixedAssetCode;
            _sourcelocation.text = assetDetails?.assetLocation ?? "unknown";
            _manufacturer.text = assetDetails!.manufacturer;
            _staff.text = assetDetails!.assetUser;
            _model.text = assetDetails!.model;
            _specs.text = assetDetails!.assetspecs;
            //_model.text = assetDetails!.;
          }
          setState(() {});
        } else {
          print('No asset details found');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      final responseStaffs = await http.get(
          Uri.parse(
              'https://cittafixedassetphone-apim.azure-api.net/assetstaffs'));
      final responseBranches = await http.get(
          Uri.parse(
              'https://cittafixedassetphone-apim.azure-api.net/assetbranches?branchcode=07'));

      if (responseStaffs.statusCode == 200 &&
          responseBranches.statusCode == 200) {
        final List<dynamic> dataStaffs = json.decode(responseStaffs.body);
        final List<dynamic> dataBranches =
            json.decode(responseBranches.body);

        setState(() {
          staffNames = dataStaffs
              .map((item) => item['staffName'].toString())
              .toList(); // Extract staff names from the JSON response

          branchNames = dataBranches
              .map((item) => item['parameterName'].toString())
              .toList(); // Extract branch names from the JSON response
          isDataFetched = true; // Mark data fetching as complete
          if (assetDetails != null) {
            _fixedAssetCode.text = assetDetails?.fixedAssetCode ?? 'unknown';
            _sourcelocation.text = assetDetails?.assetLocation ?? "unknown";
            _manufacturer.text = assetDetails?.manufacturer ?? 'unknown';
            _staff.text = assetDetails!.assetUser;
            _model.text = assetDetails!.model;
            _specs.text = assetDetails!.assetspecs;
          }
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _sendRequestForApproval() async {
    setState(() {
      _isButtonEnabled = false; // Disable the button to prevent multiple clicks
    });

    // Construct the request URL
    final url = Uri.parse(
        'https://cittafixedassetphone-apim.azure-api.net/EditAsset?fixedAssetCode=${_fixedAssetCode.text}&description=${_description.text}&specsTrans=${_specs.text}&modelTrans=${_model.text}&manufacturerTrans=${_manufacturer.text}&sourceUser=assetUser&sourceLocation=test&sourceBranch=${_sourcebranch.text}&targetLocation=&targetBranch=test&targetUser=test');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        // Request successful
        setState(() {
          requestResult = 'Request for approval sent successfully.';
        });
      } else {
        // Request failed
        setState(() {
          requestResult = 'Failed to send request for approval.';
        });
      }
    } catch (error) {
      // Error occurred
      setState(() {
        requestResult = 'Error: $error';
      });
    }

    setState(() {
      _isButtonEnabled = true; // Enable the button after the request is sent
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (assetDetails != null) ...[
                Text(
                  'Asset Tag: ${assetDetails!.assetTag}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextField('Description', _description),
                buildTextField('Fixed Asset Code', _fixedAssetCode),
                buildTextField('Specifications', _specs),
                               buildTextField('branch', _sourcebranch),
                buildSearchList(
                  branchNames,
                  selectedBranchName,
                  'Select Branch',
                  (String newValue) {
                    setState(() {
                      selectedBranchName = newValue;
                    });
                  },
                ),
                buildTextField('Staff', _staff),
                buildSearchList(
                  staffNames,
                  selectedStaffName,
                  'Select Staff',
                  (String newValue) {
                    setState(() {
                      selectedStaffName = newValue;
                    });
                  },
                ),
                buildTextField('manufacture', _manufacturer),
                buildTextField('location', _sourcelocation),
                buildTextField('model', _model),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _sendRequestForApproval : null,
                  child: Text('Request for Approval'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 16.0),
                if (requestResult.isNotEmpty)
                  Text(
                    requestResult,
                    style: TextStyle(
                      color: requestFailed ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchList(
    List<String> items,
    String value,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            labelText: hint,
          ),
          controller: TextEditingController(text: value),
        ),
        suggestionsCallback: (pattern) {
          return items
              .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, String itemData) {
          return ListTile(
            title: Text(itemData),
          );
        },
        onSuggestionSelected: (String? selectedItem) {
          onChanged(selectedItem!);
        },
      ),
    );
  }
}

Widget buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
    ),
  );
}
