import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/craft_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/creative_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/digitalart_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/fantasy_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/gameart_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/horror_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/photography_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/drawings_screen.dart';
import 'package:art_inyou/core/presentation/pages/tapbar_screens/traditionalart_screen.dart';
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
      length: 11,
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
                child: Text('Drawings'),
              ),
              Tab(
                child: Text('Craft'),
              ),
              Tab(
                child: Text('Horror'),
              ),
              Tab(
                child: Text('TraditionalArt'),
              ),
              Tab(
                child: Text('DigitalArt'),
              ),
              Tab(
                child: Text('GameArt'),
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
                DrawingsScreen(
                  userId: userId,
                ),
                CraftScreen(
                  userId: userId,
                ),
                HorrorScreen(userid: userId),
                TraditionalArtScreen(userid: userId),
                DigitalArtScreen(userid: userId, ),
                GameArtScreen(userid: userId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
