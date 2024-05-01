// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/domain/profiledata.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/pages/editprofile_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/alertdialog.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
     User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = currentUser?.uid ?? '';
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return FutureBuilder(
            future: getProfile(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                ProfileModel? profileData = snapshot.data;
                if (profileData != null) {
                  return Column(
                    children: [
                      SizedBox(height: height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Text(
                                  profileData.username,
                                  style: MyFonts.headingTextStyle,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                            
                              showDialog(context: context, builder: (BuildContext context) {
                               return  ConfirmationDialog(message: 'Are you sure you want to Logout ?',
                                onYesPressed:()async{
                                  SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.remove('email');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              ); 
                               }
                               
                               );
                                
                              });
                            },
                            icon: Icon(
                              Icons.menu_rounded,
                              size: height * 0.04,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          width: height * 0.1,
                          height: height * 0.1,
                          child: ClipOval(
                            child: Placeholder(
                              child: Image.network(
                                profileData.imageurl.isNotEmpty
                                    ? profileData.imageurl
                                    : 'https://cdn.vectorstock.com/i/500p/15/40/blank-profile-picture-image-holder-with-a-crown-vector-42411540.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        profileData.bio,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: height * 0.03),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '10',
                                style: MyFonts.normalTextStyle,
                              ),
                              Text(
                                'Post',
                                style: MyFonts.boldTextStyle,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '1000',
                                style: MyFonts.normalTextStyle,
                              ),
                              Text(
                                'Followers',
                                style: MyFonts.boldTextStyle,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '200',
                                style: MyFonts.normalTextStyle,
                              ),
                              Text(
                                'Following',
                                style: MyFonts.boldTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      labelwidget(
                        labelText: 'Edit Profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                edit: profileData,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      // Expanded(
                      //   child: GridViewScreen(
                      //     postsFuture: getPosts(),
                      //   ),
                      // ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('No Profile data available'),
                  );
                }
              } else {
                return const Center(
                  child: Text('No data available'),
                );
              }
            },
          );
        },
      ),
    );
  }
}

