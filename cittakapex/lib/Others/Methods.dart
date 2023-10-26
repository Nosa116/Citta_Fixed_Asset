import 'package:cittakpex/Screen/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../Others/Constant.dart';


// Function to log out and navigate to the LoginScreen
void logout(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(), // Replace with your LoginScreen route
    ),
  );
}
