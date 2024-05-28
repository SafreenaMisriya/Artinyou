// ignore_for_file: deprecated_member_use

import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
sendEmail() async {
  final Uri uri = Uri(scheme: 'mailto', path: 'safreenamisriya02@gmail.com');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
        child: Scaffold(
          backgroundColor: color,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    'Privacy Policy',
                    style: MyFonts.headingTextStyle,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
              Padding(
                padding:const EdgeInsets.all(8.0),
                child: Text("""
    Introduction:

    Hi there! Welcome to  ARTINYOU  is a social media app for artists and art enthusiasts. Your privacy is important to us, so we want to be transparent about how we collect and use your information.


    Information We Collect:

    When you sign up, we ask for basic information like your name and email. We also collect information about your interactions with the app, like posts you like and comments you make.


    How We Use Your Information:

    We use your information to improve your experience on the app, personalize content for you, and facilitate transactions if you decide to buy or sell artwork.


    Sharing Your Information:

    We don't sell your information to third parties. However, if you buy or sell artwork, we'll share necessary details with the other party to complete the transaction.


    Keeping Your Information Safe:

    We take security seriously and use measures like encryption to protect your information from unauthorized access.


    Your Choices:

    You have control over your information. You can update your profile or delete your account at any time.


    Children's Privacy:

    Our app is not intended for children under 13. If you're a parent and believe your child has provided us with personal information, please contact us.


    Updates to Our Privacy Policy:

    We may update our privacy policy from time to time. If we make significant changes, we'll let you know.


    Contact Us:

    If you have any questions or concerns about your privacy, please reach out to us at .""",style:  GoogleFonts.lato(fontSize: 17),),
  
              ),
               SizedBox(height: height *0.01),
            GestureDetector(
              onTap: sendEmail,
              child: const Text(
                'Contact Us: safreenamisriya02@gamil.com',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  
                ),
              )
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
