import 'package:flutter/material.dart';
import 'Login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'Images/mobilesearch.png',
                width: 600,
                height: 500,
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Effortlessly manage your Properties, Plants and Equipments with ',
                    ),
                    TextSpan(
                      text: 'Citta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue, // Set color of font to blue
                        fontFamily: 'brush script mt',
                      ),
                    ),
                    TextSpan(
                      text: 'kapex',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(
                            255, 255, 145, 0), // Set color to red
                        fontFamily: 'Mistral',
                      ),
                    ),
                    TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // const Text(
            //   'Effortlessly manage your fixed assets with Cittaassets.',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w400,
            //     color: Colors.black,
            //   ),
            //   textAlign: TextAlign.left,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: WelcomeScreen()));
}
