import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
     
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation Bar App'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'Assets/Logo.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the LoginScreen when the button is pressed
          Navigator.of(context).pushNamed('/login');
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.green, // Customize the button's background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position the button at the bottom right corner
    );
  }
}


