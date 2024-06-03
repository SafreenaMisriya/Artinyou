import 'package:art_inyou/blocs/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/repositories/post/fetching.dart';
import 'package:art_inyou/repositories/profile/profiledata.dart';
import 'package:art_inyou/screens/account/follow_tabview.dart';
import 'package:art_inyou/screens/search/price_rangedisply.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/appbar/customappbar.dart';
import 'package:art_inyou/widgets/label/followlabel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherUserProfile extends StatelessWidget {
  final String username;
  final String profile;
  final String userid;
  const OtherUserProfile(
      {super.key,
      required this.username,
      required this.profile,
      required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(CheckfollowStatusEvent(otheruserid: userid));
      String  currentUserid = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
        child: Scaffold(
            appBar: customAppbartop(context, username),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                bool isfollowing = false;
                if (state is FollowingStatusState) {
                  isfollowing = state.isFollowing;
                }
                return Column(
                  children: [
                    SizedBox(height: height * 0.03),
                    Center(
                      child: SizedBox(
                        width: height * 0.1,
                        height: height * 0.1,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder(
                          future: getPostCount(userid),
                          builder: (context, snapshot) {
                          return Column(
                            children: [
                              Text(
                               ' ${snapshot.data ?? 0}',
                                style: MyFonts.headingTextStyle,
                              ),
                             const Text(
                                'Posts',
                                style: MyFonts.boldTextStyle,
                              )
                            ],
                          );
                           },
                        ),
                        GestureDetector(
                            child: StreamBuilder(
                              stream:getFollowersCount(userid) ,
                              builder:(context, snapshot){
                              return Column(
                                children: [
                                  Text(
                                    ' ${snapshot.data ?? 0}',
                                    style: MyFonts.headingTextStyle,
                                  ),
                                  const Text(
                                    'Followers',
                                    style: MyFonts.boldTextStyle,
                                  )
                                ],
                              );
                              }
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Tabfollow(
                                            userid: userid,
                                            username: username,
                                          )));
                            }),
                        GestureDetector(
                            child:  StreamBuilder(
                              stream: getFollowingCount(userid),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    Text(
                                      ' ${snapshot.data ?? 0}',
                                      style: MyFonts.headingTextStyle,
                                    ),
                                    const Text(
                                      'Following',
                                      style: MyFonts.boldTextStyle,
                                    )
                                  ],
                                );
                              }
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Tabfollow(
                                            userid: userid,
                                            username: username,
                                          )));
                            })
                      ],
                    ),
                    if(userid !=currentUserid)
                    SizedBox(height: height * 0.04),
                     if(userid !=currentUserid)
                    followlabelwidget(
                      labelText: isfollowing ? 'Following' : 'Follow',
                      color: isfollowing ? iconcolor : redcolor,
                      onTap: () {
                        if (isfollowing) {
                          profileBloc.add(UnFollowEvent(otheruserid: userid));
                        } else {
                          profileBloc.add(FollowEvent(otheruserid: userid));
                        }
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Expanded(
                        child: DropdownPrice(
                      postsFuture: getPostOfuser(userid),
                      visible: false,
                    )),
                  ],
                );
              },
            )));
  }
}
