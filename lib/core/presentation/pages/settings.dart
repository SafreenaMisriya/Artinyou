// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/pages/savedpost_screen.dart';
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
          padding: const EdgeInsets.all(8.0),
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
                height: height * 0.06,
              ),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_ios),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedPostScreen()));
                      },
                      child: const Text('Saved Post',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_ios),
                  TextButton(
                      onPressed: () {
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
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  });
                            });
                      },
                      child: const Text('Log Out',
                          style: TextStyle(fontSize: 18, color: Colors.black))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
