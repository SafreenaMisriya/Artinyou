import 'package:art_inyou/repositories/profile/profiledata.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class FollowersScreen extends StatelessWidget {
  final String userid;
  const FollowersScreen({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getFollowers(userid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitFadingCircle(
                      color: redcolor,
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            child: const Text(
                              'No Followers',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            )));
                  }
                  List<Map<String, dynamic>> followers = snapshot.data!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      final user = followers[index];
                      return GestureDetector(
                        child: ListTile(
                          leading: SizedBox(
                            height: height * 0.05,
                            width: height * 0.05,
                            child: ClipOval(
                              child: Image.network(
                                user['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            user['username'],
                            style: MyFonts.boldTextStyle,
                          ),
                          trailing: Container(
                            height: height * 0.05,
                            width: width * 0.25,
                            color: Colors.blue,
                            child: const Center(
                              child: Text(
                                'Followers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
