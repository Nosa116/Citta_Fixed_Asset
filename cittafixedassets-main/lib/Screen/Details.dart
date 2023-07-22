import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../Others/Constant.dart';
import '../Others/FlutterModel.dart';
import 'Edit.dart';

class Details extends StatefulWidget {
  final String assetTag;
  final String description;

  const Details({super.key, required this.assetTag, required this.description});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<AssetDetails> assetDetails;
  AssetDetails? _assetData; // Declare the variable to hold assetData

void navigateToEditScreen() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Edit(
        assetTag: _assetData!.assetTag,
        description: _assetData!.description,

       // sourcebranch: _assetData!.,

        // Pass other asset details as needed
      ),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    assetDetails = fetchAssetDetails(widget.assetTag, widget.description);
  }

Future<AssetDetails> fetchAssetDetails(
  String assetTag, String assetName) async {
  String url;
  
  if (widget.description == "00") {
    url = 'https://cittafixedassetphone-apim.azure-api.net/assetdetails?assetTag=$assetTag';
  } else {
    url = 'https://cittafixedassetphone-apim.azure-api.net/assetdetails?assetTag=$assetTag&assetName=$assetName';
  }
  
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final assetData = AssetDetails.fromJson(jsonResponse[0]);
    setState(() {
      _assetData = assetData; // Assign the value to _assetData
    });
    return assetData;
  } else {
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final assetData = snapshot.data!;
          return Padding(
  padding: const EdgeInsets.all(16.0),
  child: ListView.builder(
    itemCount: assetData.toJson().length,
    itemBuilder: (context, index) {
      final field = assetData.toJson().entries.elementAt(index);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
  controller: TextEditingController(text: '${field.value}'),
  enabled: false,
   style: const TextStyle(color: Colors.black),
   keyboardType: TextInputType.multiline,
minLines: 1,
maxLines: 20,
  decoration: InputDecoration(
    labelText: field.key,
    // border: OutlineInputBorder(),
    // filled: true,
    // fillColor: Colors.grey[200],
  ),
),
        ],
      );
    },
  ),
);
        } else {
          return const Text('No data available');
        }
      },
    ),
    
  );
}
}