import 'package:cittakpex/Screen/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Others/Constant.dart';
import 'OnboardPage1.dart';
import 'OnBoardPage2.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  //PageView Controller
  final PageController _controller = PageController();
  //indicates whether we are on the last page
  bool indicateLastPage = false;

  _onboardstate() async {
    int seenonboard = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboard', seenonboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                indicateLastPage = (index == 1);
              });
            },
            children: const [
              //Screen One
              Onboard1(),
              //Screen Two
              Onboard2(),
            ],
          ),
          //Done
          indicateLastPage
              ? Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0), // Adjust the value as needed
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 50.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => ored),
                          ),
                          child: const Text('Done'),
                          onPressed: () async {
                            await _onboardstate();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              :
              //Next Button
              Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0), // Adjust the value as needed
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 50.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => ored),
                          ),
                          child: const Text('Next'),
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
          //Page Indicator
          Container(
            alignment: Alignment.bottomLeft,
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const JumpingDotEffect(
                dotColor: Color.fromARGB(0, 166, 166, 166),
                activeDotColor: Color.fromARGB(0, 147, 25, 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
