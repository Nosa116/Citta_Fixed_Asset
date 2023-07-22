import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Home.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({Key? key}) : super(key: key);

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  bool isSearchClicked = false;
bool isSearchTapped = false;

  @override
  void initState() {
    super.initState();
  }

  void fetchUsers() async {
    print('Fetch Users Called');
    const url = 'https://randomuser.me/api/?results=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
      filterUsers(_searchController.text); // Filter users after fetching
    });
    print('fetchUsers completed');
  }

  void filterUsers(String query) {
    setState(() {
      isSearchClicked = true;
      filteredUsers = users
          .where((user) =>
              user['email'].toLowerCase().contains(query.toLowerCase()))
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          title: Container(
            child: CupertinoTextField(
              controller: _searchController,
              placeholder: 'Search',
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
    isSearchClicked
        ? Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                final email = user['email'];

                return ListTile(
                  title: Text(email),
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
