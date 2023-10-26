import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Others/FlutterModel.dart';
import 'Details.dart';
import 'Home.dart';

class BarcodeSearchscreen extends StatefulWidget {
  final String staffCode;
  final String Orgcode;

  //const BarcodeSearchscreen({Key? key}) : super(key: key);
  const BarcodeSearchscreen({required this.staffCode, required this.Orgcode});

  @override
  State<BarcodeSearchscreen> createState() => _BarcodeSearchscreenState();
}

class _BarcodeSearchscreenState extends State<BarcodeSearchscreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> asset = [];
  List<dynamic> assetItem = [];
  bool isSearchClicked = false;
  bool isSearchTapped = false;
  bool isLoading= false;
  @override
  void initState() {
    super.initState();
  }

  void fetchAssetList(String query) async {
     setState(() {
      isLoading = true; // Show loading indicator when fetching
    });
    print('Fetch Asset Called');
    final url =
        'https://citta.azure-api.net/api/FAsset/assetlisttag?Org_code=${widget.Orgcode}&Loginstaff=${widget.staffCode}&assetname=$query';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //print('API Response: $data');

      setState(() {
        asset = data.map((item) => Asset.fromJson(item)).toList();
        print('Asset List: $asset');
        // Filter users after fetching
        isLoading = false;
      });
      print('Fetch Asset completed');
    } else {
       setState(() {
        isLoading = false; // Hide loading indicator when fetch has an error
      });
      print(url);
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching asset list. Status code: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ),
    );
      print('Error fetching asset list. Status code: ${response.statusCode}');
      // Handle the error here, show an error message, or retry the request.
    }
  }

  // void filterUsers(String query) {
  //   setState(() {
  //     isSearchClicked = true;
  //     filteredAssets = asset
  //         .where((asset) =>
  //             asset.fixedAssetCode.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

void _onSearchClicked() {
  final searchText = _searchController.text.trim(); // Trim any leading/trailing spaces
  if (searchText.isEmpty) {
    // Display a message if the search bar is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please type an asset in the search bar'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    // Call the fetchAssetList function only if the search bar is not empty
    setState(() {
      isSearchTapped = true;
      isSearchClicked = true;
    });
    fetchAssetList(searchText);
  }
}


  void navigateToDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          staffCode: widget.staffCode,
          Orgcode: widget.Orgcode,
          // fixedAssetCode: asset.fixedAssetCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            staffCode: widget.staffCode,
                            Orgcode: widget.Orgcode,
                          )));
            },
          ),
          title: Container(
            child: CupertinoTextField(
              controller: _searchController,
              placeholder: 'Search for Barcode',
              prefix: const Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: Icon(Icons.search),
              ),
              suffix: SizedBox(
                width: 40, // Fixed width to control the size of the button
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _onSearchClicked,
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.all(3),
            ),
          ),
        ),
      ),
      
      body: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !isSearchTapped, // Show the image if search is not tapped
            child: SvgPicture.asset(
              'Images/search1.svg',
              height: 100,
              width: 100,
              color: Colors.black, // Customize the color of the SVG image
            ),
          ),

// Show a loading indicator while fetching data
          if (isLoading)
            Expanded(child: Center(
              child: CircularProgressIndicator(),
            ), ), // Loading indicator

          // Show a loading indicator while fetching data
          if (!isSearchClicked && isSearchTapped)
            const Center(
                child: CircularProgressIndicator()), // Loading indicator
          isSearchClicked
              ? Expanded(
               
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      itemCount: asset.length,
                      itemBuilder: (context, index) {
                        final assetItem = asset[index];
                        return ListTile(
                          //title: Text(assetItem.fixedAssetCode),
                          title: Text(assetItem.assetTag),
                          subtitle: Text(assetItem.description),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  staffCode: widget.staffCode,
                                  Orgcode: widget.Orgcode,
                                  fixedAssetCode: assetItem.fixedAssetCode,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              : Container(), // Empty container if search is not clicked yet
        ],
      ),
    );
  }
}

// void main() {
//   runApp(const MaterialApp(
//     home: BarcodeSearchscreen(staffCode: widget.staffCode, orgCode: '',),
//   ));
// }