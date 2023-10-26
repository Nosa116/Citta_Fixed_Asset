import 'dart:convert';

import 'package:cittakpex/Screen/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController orgCodeController = TextEditingController();
  final TextEditingController staffNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: orgCodeController,
              hintText: 'Organization',
              prefixIcon: Icons.business,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: staffNumberController,
              hintText: 'Staff Number',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: passwordController,
              hintText: 'New Password',
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: dobController,
              hintText: 'Date of Birth (DD/MM/YYYY)',
              prefixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null // Disable the button when loading
                  : () {
                      // Set isLoading to true when the button is pressed
                      setState(() {
                        isLoading = true;
                      });

                      // Implement your password reset logic here
                      resetPassword();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24.0, // Adjust width as needed
                      height: 24.0, // Adjust height as needed
                      child: CircularProgressIndicator(),
                    ) // Show a loading indicator
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() async {
    final orgCode = orgCodeController.text;
    final staffNumber = staffNumberController.text;
    final password = passwordController.text;
    final dob = dobController.text;
    String baseUrl = 'https://citta.azure-api.net/api/FAsset/passwordchange';

    Map<String, String> requestBody = {
      "org_code": orgCode,
      "dob": dob,
      "password": password,
      "loginstaff": staffNumber,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json'
      }, // Set the content type to JSON
      body: jsonEncode(requestBody), // Encode the map to JSON
    );

    // Print the response content
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Password reset was successful
      // You can handle the success case here, such as showing a success message.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset Successful'),
          backgroundColor: Colors.green[700],
        ),
      );
    } else {
      // Password reset failed
      // You can handle the failure case here, such as showing an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          prefixIconColor: MaterialStateColor.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return Colors.grey; // Set the focused color to grey
              }
              return Colors.grey; // Set the default color to grey
            },
          ),
        ),
      ),
    ),
  );
}
