
import 'dart:async';
import 'package:art_inyou/core/presentation/pages/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  final String text;
  const SuccessScreen({super.key,required this.text});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
   @override
  void initState() {
     Timer(
         const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomBar())));
    
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
                      Center(child:
                      Text( widget.text,
                      style:const TextStyle(color: Colors.green,fontSize: 18),),)
           ],
         ),
      
    );
  }
}