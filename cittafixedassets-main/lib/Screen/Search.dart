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

  void fetchUsers(String query) async {
    setState(() {
      isLoading = true;
    });

    print('Fetch Asset Called');
    final url =
        'https://citta.azure-api.net/Adron/api/FAsset/assetlist?FixedAssetCode=$query';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
       print('API Response: $data'); // Print the API response before converting it to a list
      setState(() {
        filteredAssets = data.map((item) => Asset.fromJson(item)).toList();
        isLoading = false;
      });
      print('Result $response');
      print('Fetch Asset completed');
    } else {
      print('Error fetching asset list. Status code: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchClicked() {
    setState(() {
      isSearchTapped = true;
    });
    final query = _searchController.text;
    fetchUsers(query); // Fetch users and filter based on the search query
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
          
           isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : filteredAssets.isNotEmpty // Check if filteredAssets is not empty
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
                                  fixedAssetCode: asset.fixedAssetCode,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : Visibility(
                    // Show the image if search is not tapped or no results found
                    visible: !isSearchTapped,
                    child: Center(
                      child: SvgPicture.asset(
                        'Images/search1.svg',
                        height: 100,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
