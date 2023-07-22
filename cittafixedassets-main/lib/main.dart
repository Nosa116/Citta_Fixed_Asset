// import 'package:cittafixedassets/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Onboarding/onBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'Screen/Login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Screen/Search.dart';
int? seenonboard;
void main() async{
  const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  WidgetsFlutterBinding.ensureInitialized();
SharedPreferences prefs = await SharedPreferences.getInstance();
seenonboard = prefs.getInt('onboard');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: seenonboard !=0 ? const OnBoardScreen() : const Searchscreen(),
      
    );
  }
}
