// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/blocs/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/blocs/google_auth/cubit/googleauth_cubit.dart';
import 'package:art_inyou/blocs/otpauth_bloc/bloc/otpauth_bloc_bloc.dart';
import 'package:art_inyou/screens/settings/about_screen.dart';
import 'package:art_inyou/screens/authentication/login_screen.dart';
import 'package:art_inyou/screens/settings/privacy_policy.dart';
import 'package:art_inyou/screens/saved/savedpost_screen.dart';
import 'package:art_inyou/screens/settings/rating.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
                leading: const Icon(Icons.feedback),
                title:
                    const Text('Send feedback', style: MyFonts.boldTextStyle),
                onTap: () async {
                  final Uri uri = Uri(
                      scheme: 'mailto', path: 'safreenamisriya02@gmail.com');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate US', style: MyFonts.boldTextStyle),
                onTap: () {
                  showRating(context, height, width);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share', style: MyFonts.boldTextStyle),
                onTap: () {
                  Share.share(
                      'https://www.amazon.com/dp/B0D5LV6D99/ref=apps_sf_sta');
                },
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
                              sharedPreferences.remove('phone');
                              context.read<GoogleauthCubit>().logout();
                              context.read<OtpauthBloc>().add(SignOutEvent());
                              context.read<EmailauthBloc>().add(LogOutEvent());
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
             const Center(child: Text('V.1.0.0'),)
            ],
          ),
        ),
      ),
    );
  }

  
}
