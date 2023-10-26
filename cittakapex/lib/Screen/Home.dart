import 'dart:convert';

import 'package:cittakpex/Others/Methods.dart';
import 'package:cittakpex/Screen/BarcodeSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../Others/Constant.dart';
import 'Details.dart';
import 'Search.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String staffCode;
  final String Orgcode;
  const HomeScreen({required this.staffCode, required this.Orgcode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = '';
  bool isProcessing = false;

  void navigateToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Searchscreen(
          staffCode: widget.staffCode,
          Orgcode: widget.Orgcode,
        ),
      ),
    );
  }

  void navigateToBarcodeSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeSearchscreen(
          staffCode: widget.staffCode,
          Orgcode: widget.Orgcode,
        ),
      ),
    );
  }


  Future<String?> fetchFixedAssetCode(String assetTag) async {
    final apiUrl =
        'https://citta.azure-api.net/api/FAsset/assetdetails?assettag=$assetTag&org_code=${widget.Orgcode}&loginstaff=${widget.staffCode}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey("fixedAssetCode")) {
          // Extract the fixedAssetCode field and store it in a variable
          String fixedAssetCode = data["fixedAssetCode"];
          return fixedAssetCode;
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    // Return null if there was an error or if the field was not found
    return null;
  }

  Future<void> scanBarcode() async {
    setState(() {
      isProcessing = true;
    });

    var res = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Customize the scan UI color
        "Cancel", // Button text to cancel the scan
        true, // Enable flash option while scanning
        ScanMode.QR, // Set the scan mode (you can use other modes too)
      );
    String bcod = res;

    setState(() {
      isProcessing = false;
    });

    setState(() async {
      if (res != null && res is String && res.isNotEmpty && res != '-1') {
        // Fetch the fixedAssetCode
        String? fixedAssetCode = await fetchFixedAssetCode(res);
        if (fixedAssetCode != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(
                fixedAssetCode: fixedAssetCode,
                staffCode: widget.staffCode,
                Orgcode: widget.Orgcode,
              ),
            ),
          );
          print(bcod);
        } else {
          // Handle the case where the fixedAssetCode couldn't be fetched
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error please try again '),
              backgroundColor: Colors.red,
            ),
          );
          // You can show an error message or take appropriate action.
          print('Failed to fetch fixedAssetCode ');
          print(bcod);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green[700],
        actions: [
          // Add the logout button at the top right of the app bar
          IconButton(
            onPressed: () {
              logout(
                  context); // Call the logout function when the button is pressed
            },
            icon: Icon(Icons.logout), // You can customize the icon
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'Images/scanner.svg',
                width: 500,
                height: 400,
              ),
              const SizedBox(height: 7),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.green[700]!),
                ),
                onPressed: () {
                  navigateToSearchScreen();
                },
                child: const Text('Search for Asset'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.green[700]!),
                ),
                onPressed: () {
                  navigateToBarcodeSearchScreen();
                },
                child: const Text('Search barcode'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.green[700]!),
                ),
                onPressed: () {
                  scanBarcode();
                },
                child: const Text('Scan barcode'),
              ),

              if (isProcessing)
                CircularProgressIndicator(), // Loading indicator
            ],
          ),
        ),
      ),
    );
  }
}
