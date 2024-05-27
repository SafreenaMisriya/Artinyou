import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
        double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      const Text(
                        'My Orders',
                        style: MyFonts.headingTextStyle,
                      ),
                      SizedBox(
                        height: height * 0.08,
                      ),
                    ],
                  ),
                
            ],
          ),
        ),
      ),
    );
  }
}