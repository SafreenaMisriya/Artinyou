import 'package:art_inyou/core/presentation/pages/account_screen.dart';
import 'package:art_inyou/core/presentation/pages/chat_screen.dart';
import 'package:art_inyou/core/presentation/pages/home_screen.dart';
import 'package:art_inyou/core/presentation/pages/post_screen.dart';
import 'package:art_inyou/core/presentation/pages/search_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';

    final List<Widget> pages = [
      const HomeScreen(),
      const SearchScreen(),
      PostScreen(userId:  userId),
       ChatScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: redcolor,
            tabBackgroundColor: color,
            gap: 6,
            padding: const EdgeInsets.all(14),
            tabs: const [
              GButton(text: 'Home', icon: Icons.home),
              GButton(text: 'Search', icon: Icons.search),
              GButton(text: 'Post', icon: Icons.add_circle_outline_rounded),
              GButton(text: 'Chat', icon: Icons.chat_rounded),
              GButton(text: 'Profile', icon: Icons.account_circle),
            ],
            onTabChange: (index) {
              setState(() {
                currentIndex = index;
              });
              pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}
