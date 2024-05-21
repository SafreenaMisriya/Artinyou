
import 'dart:async';
import 'package:art_inyou/core/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
   @override
  void initState() {
     Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            
             Center(
              child: Lottie.asset('assets/animation/success.json',width: 200,height: 200) 
                     ),
                     const Center(child: Text('Order Confirmed Successfully',style: TextStyle(color: Colors.green,fontSize: 18),),)
           ],
         ),
      
    );
  }
}