import 'package:flutter/material.dart';

Color ored = const Color(0xFFCE1B34);
Color lgrey = const Color(0xFF808080);
Color lblue = const Color.fromARGB(255, 54, 54, 202);
Color lgreen = const Color.fromARGB(255, 21, 184, 16);

class BoldTextWidget extends StatelessWidget {
  final String text;

  const BoldTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}