import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboard1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0), // Add padding around the image
            child: SvgPicture.asset(
              'Images/Onimg1.svg',
              width: 400,
              height: 400,
            ),
          ),
          SizedBox(height: 10), // Add some spacing between the image and the text
Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Effortlessly scan, track, and update your fixed assets',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center, // Align the text at the center
            ),
          ),
        ],
      ),
    );
  }
}
