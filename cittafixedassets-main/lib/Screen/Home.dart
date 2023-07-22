import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../Others/Constant.dart';
import 'Details.dart';
import 'Search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = '';

  Future<void> scanBarcode() async {
 var res = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SimpleBarcodeScannerPage(),
    ),
  );
    setState(() {
    if (res != null && res is String && res.isNotEmpty && res != '-1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(assetTag: res, description: "00"),
        ),
      );
    }
  });
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'Images/scanner.svg',
                width: 500,
                height: 500,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => ored),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Searchscreen()),
                  );
                },
                child: const Text('Search'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => ored),
                ),
                onPressed: () {
                  scanBarcode();
                },
                child: const Text('Scan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
