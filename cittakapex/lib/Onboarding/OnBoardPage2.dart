import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Others/FlutterModel.dart';

class Onboard2 extends StatefulWidget {
  const Onboard2({super.key});

  @override
  _Onboard2State createState() => _Onboard2State();
}

class _Onboard2State extends State<Onboard2> {
  Future<List<Organisation>> getRequest() async {
    String url =
        "https://cittafixedassetphone-apim.azure-api.net/AllowOrgs";
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);

    List<Organisation> organisations = [];
    for (var singleorg in responseData) {
      Organisation user = Organisation(
        org: singleorg["org"],
      );
      organisations.add(user);
    }
    return organisations;
  }

  String? selectedOrg;
  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    loadSelectedOrg();
  }

  void loadSelectedOrg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedOrg = prefs.getString('selectedOrg');
    if (savedOrg != null) {
      setState(() {
        selectedOrg = savedOrg;
      });
    }
  }

  void saveSelectedOrg(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOrg', value);
  }

  Widget _buildSvgImage() {
    return SvgPicture.asset(
      'Images/Onimg3.svg',
      width: 200,
      height: 200,
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<List<Organisation>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (snapshot.hasError) {
      return Container(
        child: Center(
          child: Text('Error: ${snapshot.error}'),
        ),
      );
    } else {
      dropdownItems.clear();
      dropdownItems.addAll(snapshot.data!.map((Organisation organisation) {
        return DropdownMenuItem<String>(
          value: organisation.org,
          child: Text(organisation.org!),
        );
      }).toList());

      if (selectedOrg != null && !dropdownItems.any((item) => item.value == selectedOrg)) {
        dropdownItems.insert(
          0,
          DropdownMenuItem<String>(
            value: selectedOrg,
            child: Text(selectedOrg!),
          ),
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
           Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: BorderRadius.circular(4),
    color: const Color.fromARGB(0, 105, 240, 175),
    
  ),
  child: DropdownButton<String>(
    value: selectedOrg,
    hint: const Text('Select Organisation'),
    underline: const SizedBox(),
    onChanged: (String? newValue) {
      setState(() {
        selectedOrg = newValue;
        saveSelectedOrg(newValue!);
      });
    },
    items: dropdownItems,
  ),
),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: Column(
    children: [
       const SizedBox(height: 40), 
      _buildSvgImage(),
      Expanded(
        child: FutureBuilder<List<Organisation>>(
          future: getRequest(),
          builder: _buildContent,
        ),
      ),
    ],
  ),
);

  }
}
