// import 'package:cittafixedassets/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'Screen/Login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Screen/Welcome.dart';
void main() async{
  const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      
    );
  }
}
