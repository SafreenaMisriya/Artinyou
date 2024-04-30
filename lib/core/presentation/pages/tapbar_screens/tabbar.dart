import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/craft_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/creative_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/fantasy_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/photography_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/screen3d.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/wallpapers_screen.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabBarViewScreen extends StatelessWidget {
  const TabBarViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    return DefaultTabController(
      length: 7,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Creative'),
              ),
              Tab(
                child: Text('Fantasy'),
              ),
              Tab(
                child: Text('Photography'),
              ),
              Tab(
                child: Text('Wallpapers'),
              ),
              Tab(
                child: Text('3D Art'),
              ),
              Tab(
                child: Text('Craft'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                GridViewScreen(
                  postsFuture: getPosts(),
                  userId: userId,
                ),
                CreativeScreen(
                  userId: userId,
                ),
                FantasyScreen(
                  userId: userId,
                ),
                PhotographyScreen(
                  userId: userId,
                ),
                WallpapersScreen(
                  userId: userId,
                ),
                Screen3d(
                  userId: userId,
                ),
                CraftScreen(
                  userId: userId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
