import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:art_inyou/repositories/internet/internet_checking.dart';
import 'package:art_inyou/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late ValueNotifier<String?> finalEmail;

  @override
  void initState() {
    super.initState();
    finalEmail = ValueNotifier<String?>(null);
    getValidation().then((_) {
      Timer(const Duration(seconds: 2), () {
        finalEmail.value == null
           ? Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()))
            : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  InternetCheck()),(route) => false,);
      });
    });
  }

  Future<void> getValidation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? obtainedEmail = sharedPreferences.getString('email');
    String? obtainedPhone = sharedPreferences.getString('phone');
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();

    if (googleSignInAccount!= null) {
      finalEmail.value = googleSignInAccount.email;
    } else if (obtainedPhone!= null) {
      finalEmail.value = obtainedPhone;
    } else {
      finalEmail.value = obtainedEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BounceInDown(
        from: 200,
        child: Center(
          child: Image.asset('assets/image/logo7.png'),
        ),
      ),
    );
  }
}
