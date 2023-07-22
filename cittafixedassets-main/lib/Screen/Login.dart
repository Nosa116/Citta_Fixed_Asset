import 'package:cittafixedassets/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Others/Constant.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController staffCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool loginFailed = false;
String errorMessage = '';
Future<void> login() async {
  String baseUrl =
      'https://cittafixedassetphone-apim.azure-api.net/AllowLogin';
  String staffCode = staffCodeController.text;
  String password = passwordController.text;

  String url =
      '$baseUrl?staff_code=$staffCode&Password=$password';

  try {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // String responseData = response.body;
      // Process the response data as per your requirement
      if (response.statusCode == 200) {
        // Login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
            setState(() {
          loginFailed = true;
          errorMessage = 'Username/Password failed';
        });
      }
    } else {
      // Handle the error here
        setState(() {
        loginFailed = true;
        errorMessage = 'Error, please try again later';
      });
    }
  } catch (e) {
    // Handle the exception here
        setState(() {
      loginFailed = true;
      errorMessage = 'Error, please try again later';
    });
  }
}
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFFAFA),
 body: SingleChildScrollView(
  padding: const EdgeInsets.all(20.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Please log in to continue',
          style: TextStyle(
            fontSize: 15,
           color:  lgrey,
          ),
        ),
        const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.00),
              child: TextField(
  controller: staffCodeController,
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: 'Staff Code',
    prefixIcon: const Icon(Icons.person),
    prefixIconColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return Colors.grey; // Set the focused color to grey
      }
      return Colors.grey; // Set the default color to black
    }),
  ),
),
            ),
          ),
          const SizedBox(height: 30),
Container(
  decoration: BoxDecoration(
    color: Colors.grey[200],
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(12),
  ),
child: Padding(
  padding: const EdgeInsets.only(left: 5.0),
  child: TextField(
    controller: passwordController,
    autocorrect: false,
    obscureText: !isPasswordVisible, // Set obscureText based on isPasswordVisible value
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Password',
      prefixIcon: const IconTheme(
        data: IconThemeData(color: Colors.grey), // Set the prefix icon color to grey
        child: Icon(Icons.lock),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible; // Toggle the visibility state on tap
          });
        },
        child: IconTheme(
          data: const IconThemeData(color: Colors.grey), // Set the suffix icon color to grey
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    ),
  ),
),
),

          const SizedBox(height: 30),
          if (loginFailed)
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ored ,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: login, // Call login() when the button is pressed
              child: Center(
                child: Text(
                  'Sign In',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
      alignment: Alignment.center,
      child: Text(
        'Forgot Password',
        style: TextStyle(
          fontSize: 16,
          color:  lblue,
        ),
      ),
    ),
  ],
      ),
    ),
  ));
}
}