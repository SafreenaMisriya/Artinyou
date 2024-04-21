
import 'dart:async';

import 'package:art_inyou/core/presentation/pages/bottombar.dart';
import 'package:art_inyou/core/presentation/pages/onboarding_screen.dart/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
String? finalemail;
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getvalidation()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var obtainedEmail=sharedPreferences.getString('email');
    setState(() {
      finalemail=obtainedEmail;
    });

  }
  @override
  void initState() {
    getvalidation().whenComplete((){
     Timer(const Duration(seconds: 2), () { 
      finalemail==null
      ? Navigator.push(context, MaterialPageRoute(builder: (context)=>const OnboardingScreen()))
      : Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomBar()));
     });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/image/logo.png',
        ),
      ),
    );
  }
}
// import 'package:art_inyou/core/presentation/bloc/email/bloc/emailauth_bloc.dart';
// import 'package:art_inyou/core/presentation/pages/home_screen.dart';
// import 'package:art_inyou/core/presentation/pages/onboarding_screen.dart/onboarding_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailAuthBloc = context.read<EmailauthBloc>();
//     emailAuthBloc.add(CheckLoginStatusEvent());

//     return BlocListener<EmailauthBloc, EmailauthState>(
//       listener: (context, state) {
//         if (state is AuthenticatedState) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const BottomBar()),
//           );
//         } else if (state is Unauthenticated) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//           );
//         }
//       },
//       child: Scaffold(
//         body: Center(
//           child: Image.asset(
//             'assets/image/logo.png',
//           ),
//         ),
//       ),
//     );
//   }
// }
