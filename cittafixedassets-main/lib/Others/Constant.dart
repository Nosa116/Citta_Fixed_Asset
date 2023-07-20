import 'package:flutter/material.dart';

Color ored = Color(0xFFCE1B34);
Color lgrey = Color(0xFF808080);
Color lblue = Color.fromARGB(255, 54, 54, 202);
Color lgreen = Color.fromARGB(255, 21, 184, 16);

class BoldTextWidget extends StatelessWidget {
  final String text;

  const BoldTextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}