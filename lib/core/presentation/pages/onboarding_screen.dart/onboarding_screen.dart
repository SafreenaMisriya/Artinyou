
import 'package:art_inyou/core/presentation/pages/onboarding_screen.dart/intro_screen1.dart';
import 'package:art_inyou/core/presentation/pages/onboarding_screen.dart/intro_screen2.dart';
import 'package:art_inyou/core/presentation/pages/onboarding_screen.dart/intro_screen3.dart';
import 'package:art_inyou/core/presentation/pages/authentication/signup_screen.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  bool onLastpage = false;
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                onLastpage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(2);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      dotWidth: height * 0.01,
                      dotHeight: height * 0.01,
                      activeDotColor: Colors.red),
                ),
                onLastpage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpAuth()));
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ))
                    : GestureDetector(
                        onTap: () {
                          pageController.nextPage(
                              duration: const Duration(microseconds: 500),
                              curve: Curves.bounceIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
