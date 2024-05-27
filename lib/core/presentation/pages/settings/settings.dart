// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/core/presentation/pages/settings/about_screen.dart';
import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/pages/settings/privacy_policy.dart';
import 'package:art_inyou/core/presentation/pages/saved/savedpost_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  const Text(
                    'Settings And Activity',
                    style: MyFonts.headingTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              ListTile(
                leading: const Icon(Icons.save_sharp),
                title: const Text('Saved Post', style: MyFonts.boldTextStyle),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedPostScreen()));
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title:
                    const Text('Privacy Policy', style: MyFonts.boldTextStyle),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_settings_alt),
                title: const Text('About', style: MyFonts.boldTextStyle),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()));
                },
              ),
               ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate US', style: MyFonts.boldTextStyle),
                onTap: () {},
              ),
               ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share', style: MyFonts.boldTextStyle),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out', style: MyFonts.boldTextStyle),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                            message: 'Are you sure you want to Logout ?',
                            onYesPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.remove('email');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            });
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
