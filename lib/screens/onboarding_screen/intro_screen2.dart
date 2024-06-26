
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
              height: height *1,
              decoration: const BoxDecoration(
                image: DecorationImage(image:  AssetImage('assets/image/intro2.jpg'),fit: BoxFit.cover)
              )
             )
            ],
          ),
        ),
      ),
    );
  }
}