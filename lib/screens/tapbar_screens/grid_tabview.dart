import 'package:art_inyou/repositories/post/fetching.dart';
import 'package:art_inyou/repositories/save/savedpost_fetching.dart';
import 'package:art_inyou/screens/search/price_rangedisply.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabBarViewGridScreen extends StatelessWidget {
  const TabBarViewGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
           const TabBar(
            indicatorColor: Colors.red,

            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Tab(
                  child: Icon(Icons.grid_view),
                ),
              ),
             
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Tab(
                  child: Icon(Icons.add_photo_alternate_outlined),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                DropdownPrice(postsFuture: getPostOfuser(userId),visible: false,),
               DropdownPrice(postsFuture: fetchSaved(userId),visible: false,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
