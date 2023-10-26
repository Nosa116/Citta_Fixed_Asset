import 'dart:convert';

import 'package:cittakpex/Screen/Forgot%20password.dart';
import 'package:cittakpex/Screen/Home.dart';
import 'package:flutter/services.dart'; // Import this for rootBundle
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
  TextEditingController OrgcodeController = TextEditingController();
  bool isPasswordVisible = false;
  bool loginFailed = false;
  bool isLoading = false;

  String errorMessage = '';
  Future<void> login() async {
    String baseUrl = 'https://citta.azure-api.net/api/FAsset/StaffLogin';

    String staffCode = staffCodeController.text;
    String Password = passwordController.text;
    String Orgcode = OrgcodeController.text; // Set the org_code value

    // Create a map with the required parameters
    Map<String, String> requestBody = {
      'Loginstaff': staffCode,
      'password': Password,
      'org_code': Orgcode,
    };

    setState(() {
      isLoading = true; // Set isLoading to true when login is tapped
      loginFailed = false; // Reset loginFailed
    });

    try {
      http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json'
        }, // Set the content type to JSON
        body: jsonEncode(requestBody), // Encode the map to JSON
      );

      void navigateToHomeScreen() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              staffCode: staffCodeController.text,
              Orgcode: OrgcodeController.text,
            ),
          ),
        );
      }

      if (response.statusCode == 200) {
        // Handle the successful response
        print('Login successful');
        navigateToHomeScreen();
      } else {
        // Handle the error response
        setState(() {
          loginFailed = true;
          errorMessage = 'Username/Password failed';
          isLoading = false; // Reset isLoading
        });
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        loginFailed = true;
        errorMessage = 'Error, please try again later';
        isLoading = false; // Reset isLoading
        print('Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        backgroundColor: const Color(0xFFFFFAFA),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(// Wrap with a Column widget
                children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Row(
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Please log in to continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: lgrey,
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
                          controller: OrgcodeController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Organization',
                            prefixIcon: const Icon(Icons.business),
                            prefixIconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused)) {
                                return Colors
                                    .grey; // Set the focused color to grey
                              }
                              return Colors
                                  .grey; // Set the default color to black
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
                        padding: const EdgeInsets.only(left: 5.00),
                        child: TextField(
                          controller: staffCodeController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Staff Number',
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused)) {
                                return Colors
                                    .grey; // Set the focused color to grey
                              }
                              return Colors
                                  .grey; // Set the default color to black
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
                          obscureText:
                              !isPasswordVisible, // Set obscureText based on isPasswordVisible value
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            prefixIcon: const IconTheme(
                              data: IconThemeData(
                                  color: Colors
                                      .grey), // Set the prefix icon color to grey
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPasswordVisible =
                                      !isPasswordVisible; // Toggle the visibility state on tap
                                });
                              },
                              child: IconTheme(
                                data: const IconThemeData(
                                    color: Colors
                                        .grey), // Set the suffix icon color to grey
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: login, // Call login() when the button is pressed
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 16,
                          color: lblue,
                        ),
                      ),
                    ),
                  ),
                    SizedBox(
                        height:
                            40), // Add some space between the image and other content

                    Center(
                      child: Image.asset(
                        'Images/adronLogo.png', // Adjust the path as needed
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                        // You can add other properties like alignment, color, etc.
                      ),
                    ),
                    SizedBox(
                        height:
                            2), // Add some space between the image and other content
                  ],
                ),
              ),
            ])));
  }
}
