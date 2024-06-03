import 'package:art_inyou/blocs/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/repositories/profile/profiledata.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class FollowingScreen extends StatelessWidget {
  final String userid;
  const FollowingScreen({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(CheckfollowStatusEvent(otheruserid: userid));
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
             bool isfollowing = false;
                if (state is FollowingStatusState) {
                  isfollowing = state.isFollowing;
                }
            return Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: getFollowingStream(userid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return  Center(
                              child: SpinKitFadingCircle(color: redcolor,));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Shimmer.fromColors(
                                  baseColor: Colors.blue,
                                  highlightColor: Colors.white,
                                  child: const Text(
                                    'No Following',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  )));
                        }
                        List<Map<String, dynamic>> following = snapshot.data!;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: following.length,
                          itemBuilder: (context, index) {
                            final user = following[index];
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
                                trailing: GestureDetector(
                                  child: Container(
                                    height: height * 0.05,
                                    width: width * 0.25,
                                    color: isfollowing ? iconcolor: Colors.blue,
                                    child:  Center(
                                      child: Text(
                                       isfollowing ? 'Following':'Follow',
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (isfollowing) {
                                      profileBloc.add(
                                          UnFollowEvent(otheruserid: userid));
                                    } else {
                                      profileBloc.add(
                                          FollowEvent(otheruserid: userid));
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
