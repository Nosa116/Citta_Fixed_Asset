import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Others/FlutterModel.dart';
import 'Details.dart';
import 'Home.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({Key? key}) : super(key: key);

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> asset = [];
  List<dynamic> filteredAssets = [];
  bool isSearchClicked = false;
  bool isSearchTapped = false;
  bool isLoading = false; // New state variable for loading indicator

  @override
  void initState() {
    super.initState();
  }

  void fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    print('Fetch Asset Called');
    const url = 'https://citta.azure-api.net/Adron/api/FAsset/assetlist';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //print('API Response: $data');

      setState(() {
        asset = data.map((item) => Asset.fromJson(item)).toList();
        print('Asset List: $asset');
        filterUsers(_searchController.text); // Filter users after fetching
        isLoading = false;
      });
      print('Fetch Asset completed');
    } else {
      print('Error fetching asset list. Status code: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
      // Handle the error here, show an error message, or retry the request.
    }
  }

  void filterUsers(String query) {
    setState(() {
      isSearchClicked = true;
      filteredAssets = asset
          .where((asset) =>
              asset.fixedAssetCode.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchClicked() {
    setState(() {
      isSearchTapped = true;
    });
    fetchUsers(); // Fetch users and filter based on the search query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          title: Container(
            child: CupertinoTextField(
              controller: _searchController,
              placeholder: 'Search Asset',
              prefix: const Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: Icon(Icons.search),
              ),
              suffix: Container(
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
          isLoading
              ? Center(child: CircularProgressIndicator()) // Show the loading indicator if loading is in progress
              : isSearchClicked
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: filteredAssets.length,
                        itemBuilder: (context, index) {
                          final asset = filteredAssets[index];

                          return ListTile(
                            title: Text(asset.fixedAssetCode),
                            subtitle: Text(asset.description),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Details(
                                    //assetTag: asset.assetTag,
                                    fixedAssetCode: asset.fixedAssetCode,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Container(), // Empty container if search is not clicked yet
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Searchscreen(),
  ));
}
