// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';
import 'package:art_inyou/blocs/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/screens/account/editprofile_screen.dart';
import 'package:art_inyou/screens/buyandsell.dart/order_sell_screen.dart';
import 'package:art_inyou/screens/settings/settings.dart';
import 'package:art_inyou/screens/tapbar_screens/grid_tabview.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    User? currentUser = FirebaseAuth.instance.currentUser;
    Profilestorage storage = Profilestorage();
    String userId = currentUser?.uid ?? '';
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return FutureBuilder(
            future: storage.getProfile(userId),
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
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TabBarOrderandSell()));
                              },
                              child: const Text(
                                'My Orders',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                          Center(
                            child: Text(
                              profileData.username,
                              style: MyFonts.headingTextStyle,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen()));
                            },
                            icon: Icon(
                              Icons.settings,
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
                            child: CachedNetworkImage(
                              imageUrl: profileData.imageurl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        profileData.bio,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: height * 0.04),
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
                      const Expanded(child: TabBarViewGridScreen())

                      //  Expanded(child: DropdownPrice(postsFuture: getPostOfuser(userId),visible: false,)),
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
