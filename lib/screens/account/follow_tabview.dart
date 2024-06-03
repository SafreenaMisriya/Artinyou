import 'package:art_inyou/screens/account/followers.dart';
import 'package:art_inyou/screens/account/following.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/widgets/appbar/customappbar.dart';
import 'package:flutter/material.dart';

class Tabfollow extends StatelessWidget {
  final String userid;
  final String username;
  const Tabfollow(
      {super.key,required this.userid,required this.username});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbartop(context, username),
        body: DefaultTabController(
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
                      child: Text(
                        'Followers',
                        style: MyFonts.boldTextStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Tab(
                      child: Text(
                        'Following',
                        style: MyFonts.boldTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FollowersScreen(
                    userid: userid,
                    ),
                    FollowingScreen(
                      userid: userid,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
